# roter: 집 라우터 (network.md 참고)
#
#   enp1s0      WAN   ISP DHCP
#   enp2s0      LAN   10.0.10.0/24  서버 스위치 (max1, spark1/2, black)
#   enp3s0      TRUNK -             OpenWrt AP 로 가는 트렁크. 주소 없음, VLAN 만 실린다
#   enp3s0.20   WIFI  10.0.20.0/24  OpenWrt AP VLAN 20 tagged (sanggyun5g / sanggyun2g)
#   enp3s0.30   IOT   10.0.30.0/24  OpenWrt AP VLAN 30 tagged (sanggyun2) - 인터넷 차단
#   wg0         VPN   10.0.100.0/24 외부에서 노트북/패드/폰 접속
#
# 지금은 IPv4 만 쓴다. (IPv6 를 켜면 IoT 차단 규칙을 ip6 에도 적용해야 한다)
{ lib, pkgs, ... }:
let
  wan = "enp1s0";
  lan = "enp2s0";
  trunk = "enp3s0"; # AP 트렁크. 주소를 주지 않는다 - VLAN 둘만 올라탄다
  wifi = "enp3s0.20";
  iot = "enp3s0.30";
  vpn = "wg0";

  wgPort = 51820;
  wgKey = "/var/lib/wireguard/wg0.key";

  lanHosts = import ./_lan-hosts.nix;

  # dnsmasq/ssh 등 라우터 자신에게 허용할 서비스 (신뢰하는 내부망용)
  trusted = {
    allowedTCPPorts = [ 22 53 ];
    allowedUDPPorts = [ 53 67 123 5353 ];
  };
in
{
  # ── 인터페이스 (systemd-networkd) ─────────────────────────────
  networking.useNetworkd = true;
  networking.useDHCP = false; # hardware-configuration 의 mkDefault true 를 덮는다
  networking.networkmanager.enable = lib.mkForce false;
  services.resolved.enable = false; # DNS 는 dnsmasq 가 담당

  systemd.network = {
    enable = true;
    wait-online.anyInterface = true; # 랜선 하나 빠졌다고 부팅이 멈추지 않게

    # AP 로 가는 트렁크는 태그된 VLAN 둘만 나른다. 메인 LAN(20)도 태그인 것은
    # 일부러 그렇게 한 것이다. AP 쪽이 untagged 네이티브 VLAN 을 쓰려면 브리지
    # VLAN 필터링이 필요하고, 그러면 AP 의 관리 주소가 br-lan.20 위에 놓인다.
    # 그게 올라오지 않으면 AP 에 접근할 길이 사라진다(두 번 겪었다). 둘 다
    # 태그로 두면 AP 쪽은 평범한 브리지 두 개로 끝난다. openwrt-init.sh 참고.
    netdevs = {
      "20-wifi" = {
        netdevConfig = {
          Kind = "vlan";
          Name = wifi;
        };
        vlanConfig.Id = 20;
      };
      "20-iot" = {
        netdevConfig = {
          Kind = "vlan";
          Name = iot;
        };
        vlanConfig.Id = 30;
      };
    };

    networks = {
      "10-wan" = {
        matchConfig.Name = wan;
        networkConfig = {
          DHCP = "ipv4";
          IPv6AcceptRA = false;
        };
        dhcpV4Config = {
          UseDNS = false; # 업스트림 DNS 는 dnsmasq 에서 지정
          UseHostname = false;
        };
        linkConfig.RequiredForOnline = "routable";
      };
      "20-lan" = {
        matchConfig.Name = lan;
        address = [ "10.0.10.1/24" ];
        networkConfig.IPv6AcceptRA = false;
        linkConfig.RequiredForOnline = "no";
      };
      "20-trunk" = {
        matchConfig.Name = trunk;
        vlan = [
          wifi
          iot
        ];
        networkConfig.IPv6AcceptRA = false;
        linkConfig.RequiredForOnline = "no";
      };
      "25-wifi" = {
        matchConfig.Name = wifi;
        address = [ "10.0.20.1/24" ];
        networkConfig.IPv6AcceptRA = false;
        linkConfig.RequiredForOnline = "no";
      };
      "30-iot" = {
        matchConfig.Name = iot;
        address = [ "10.0.30.1/24" ];
        networkConfig.IPv6AcceptRA = false;
        linkConfig.RequiredForOnline = "no";
      };
    };
  };

  # ── 라우팅 / NAT ─────────────────────────────────────────────
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;

  networking.nftables.enable = true;
  networking.nat = {
    enable = true;
    externalInterface = wan;
    # IoT(10.0.30.0/24) 는 넣지 않는다 → 혹시 forward 규칙이 새도 NAT 가 안 돼 인터넷에 못 나간다.
    internalIPs = [
      "10.0.10.0/24"
      "10.0.20.0/24"
      "10.0.100.0/24"
    ];
  };

  # ── 방화벽 ───────────────────────────────────────────────────
  services.openssh.openFirewall = false; # ssh 는 내부망에서만 (아래 interfaces 에서 연다)

  networking.firewall = {
    enable = true;
    filterForward = true; # forward 기본 drop, established/related 는 허용
    allowPing = true;

    interfaces = {
      ${wan}.allowedUDPPorts = [ wgPort ];
      ${lan} = trusted;
      ${wifi} = trusted;
      ${vpn} = trusted;
      # IoT 는 라우터의 DHCP/DNS/NTP 만
      ${iot} = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 67 123 ];
      };
    };

    # 새 연결 허용 규칙. 응답 트래픽(established)은 기본으로 허용된다.
    #   서버/와이파이/VPN → 어디든 (인터넷, 서로, IoT 제어)
    #   IoT → 어디로도 새 연결 불가 (인터넷 차단, 내부망 접근 차단)
    extraForwardRules = ''
      iifname { "${lan}", "${wifi}", "${vpn}" } oifname { "${wan}", "${lan}", "${wifi}", "${iot}", "${vpn}" } accept
    '';
  };

  # ── DHCP + DNS (dnsmasq) ─────────────────────────────────────
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = true; # 라우터 자신도 dnsmasq 로 질의
    settings = {
      interface = [ lan wifi iot vpn ];
      bind-dynamic = true; # wg0 / vlan 이 나중에 올라와도 붙는다

      # 업스트림 DNS
      no-resolv = true;
      server = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      domain-needed = true;
      bogus-priv = true;
      stop-dns-rebind = true;
      rebind-localhost-ok = true;
      cache-size = 10000;

      # 로컬 도메인: <호스트>.lan
      domain = "lan";
      local = "/lan/";
      expand-hosts = true;
      no-hosts = true; # /etc/hosts 의 roter → 127.0.0.2 가 새지 않게
      # roter.lan 은 질의가 들어온 망의 라우터 주소로 답한다 (localise-queries).
      # 한 인터페이스만 쓰면 그 랜선이 빠졌을 때(no-carrier → 주소 없음) 빈 응답이 된다.
      interface-name = map (i: "roter.lan,${i}/4") [ lan wifi vpn ];
      localise-queries = true;

      dhcp-authoritative = true;
      dhcp-range = [
        "10.0.10.100,10.0.10.199,12h"
        "10.0.20.100,10.0.20.249,12h"
        "10.0.30.100,10.0.30.249,12h"
      ];
      # 0.0.0.0 = 해당 인터페이스의 라우터 주소 (chrony)
      dhcp-option = [ "option:ntp-server,0.0.0.0" ];

      dhcp-host = lib.mapAttrsToList (name: h: "${h.mac},${name},${h.v4}") lanHosts;
      # OpenWrt AP 관리 주소도 여기에 고정하면 좋다. 예) "aa:bb:cc:dd:ee:ff,ap,10.0.20.2"
    };
  };

  # ── NTP (인터넷이 막힌 IoT 용) ──────────────────────────────
  services.chrony = {
    enable = true;
    extraConfig = ''
      allow 10.0.0.0/16
    '';
  };

  # ── mDNS reflector: 서버망 ↔ 와이파이 간 기기 검색 ─────────────
  services.avahi = {
    enable = true;
    reflector = true;
    openFirewall = false; # 5353 은 내부망 인터페이스에서만 연다
    allowInterfaces = [ lan wifi ];
  };

  # ── WireGuard ────────────────────────────────────────────────
  # 첫 부팅 때 개인키를 만든다. 공개키 확인: sudo wg show wg0 public-key
  systemd.services.wg0-keygen = {
    description = "Generate WireGuard private key for wg0";
    wantedBy = [ "systemd-networkd.service" ];
    before = [ "systemd-networkd.service" ];
    unitConfig.ConditionPathExists = "!${wgKey}";
    serviceConfig.Type = "oneshot";
    path = [ pkgs.wireguard-tools ];
    script = ''
      mkdir -p -m 700 "$(dirname ${wgKey})"
      umask 077
      wg genkey > ${wgKey}
    '';
  };

  environment.systemPackages = [ pkgs.wireguard-tools ];

  networking.wireguard = {
    enable = true;
    interfaces.${vpn} = {
      ips = [ "10.0.100.1/24" ];
      listenPort = wgPort;
      privateKeyFile = wgKey;
      # 클라이언트 추가: 기기에서 키를 만들고 공개키를 여기에 넣는다.
      # 클라이언트 설정 예)
      #   [Interface] Address = 10.0.100.2/32, DNS = 10.0.100.1
      #   [Peer] Endpoint = <DDNS 주소>:51820
      #          AllowedIPs = 10.0.10.0/24, 10.0.20.0/24, 10.0.100.0/24   (split tunnel)
      #                     또는 0.0.0.0/0                                 (full tunnel)
      peers = [
        # { name = "phone";  publicKey = "..."; allowedIPs = [ "10.0.100.2/32" ]; }
        # { name = "laptop"; publicKey = "..."; allowedIPs = [ "10.0.100.3/32" ]; }
        # { name = "pad";    publicKey = "..."; allowedIPs = [ "10.0.100.4/32" ]; }
      ];
    };
  };
}
