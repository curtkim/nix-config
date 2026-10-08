# DGX Spark 두 대를 QSFP로 직결(stacked sparks)했을 때의 인터커넥트 설정.
#
# NVIDIA 가이드(https://build.nvidia.com/spark/connect-two-sparks/stacked-sparks)는
# netplan/nmcli로 매 부팅마다 ip를 붙이지만, 양쪽 모두 NixOS이므로 선언적으로 고정한다.
#
# 중요: QSFP 소켓 1개 = 100G MAC 2개(각각 별도 PCIe x4 링크)다.
# enp1s0f0np0 과 enP2p1s0f0np0 은 같은 물리 포트이고, 200Gbps를 내려면 둘 다
# 주소가 있어야 한다(RoCEv2 GID는 인터페이스의 IPv4에서 파생되므로, 주소가 없는
# MAC은 link-local GID만 갖고 NCCL이 쓰지 못한다). 케이블 1개로 충분하다.

# 배포
# nixos-rebuild switch --flake .#spark1 --build-host spark1 --target-host spark1 --sudo --ask-sudo-password

# 수동설정
# spark1에서
#  ssh-keygen -t ed25519           # 없으면
#  ssh-copy-id curt@192.168.1.12   # 관리망으로 키 전달 (한 번)
#  ssh 192.168.100.12 hostname     # 인터커넥트 경로 확인 → spark2

# test
#
# nix develop github:graham33/nixos-dgx-spark#nccl-two-sparks
# nccl-rdma-check 192.168.100.11 192.168.100.12
# nccl-run-16g    192.168.100.11 192.168.100.12


{ lib, pkgs, hostName, ... }:

let
  # 노드별 호스트 옥텟 (nccl-two-sparks playbook 관례와 동일: .11 / .12)
  octet =
    {
      spark1 = 11;
      spark2 = 12;
    }
    .${hostName};

  # 같은 L2 세그먼트를 공유하는 두 MAC을 서로 다른 /24로 분리한다.
  links = [
    {
      dev = "enp1s0f0np0";
      subnet = "192.168.100";
    }
    {
      dev = "enP2p1s0f0np0";
      subnet = "192.168.101";
    }
  ];

  devs = map (l: l.dev) links;

  peerOctet = if octet == 11 then 12 else 11;

  # "<dev>=<상대 주소>" 쌍. 쉘 쪽에서 한 줄로 순회하므로 Nix 문자열 보간이
  # 여러 줄에 걸치지 않는다(들여쓰기가 깨지지 않는다).
  peerPlan = lib.concatMapStringsSep " " (
    l: "${l.dev}=${l.subnet}.${toString peerOctet}"
  ) links;

  # 상대 노드의 관리망(LAN) 주소. PRRTE/mpirun 콜백이 LAN 주소를 먼저 광고하므로
  # 상대의 관리망 주소에서 오는 트래픽도 받아줘야 다중 노드 실행이 붙는다.
  peerMgmt =
    {
      spark1 = "192.168.1.12";
      spark2 = "192.168.1.11";
    }
    .${hostName};
in
{
  # NetworkManager가 이 인터페이스에 DHCP를 걸지 않도록 손을 떼게 한다.
  # (주소는 아래 networking.interfaces 의 스크립티드 네트워킹이 담당)
  networking.networkmanager.unmanaged = map (d: "interface-name:${d}") devs;

  networking.interfaces = lib.listToAttrs (
    map (
      l:
      lib.nameValuePair l.dev {
        useDHCP = false;
        # RoCE path MTU는 netdev MTU에 묶인다. 기본 1500이면 RDMA MTU가 4096이 아니라
        # 1024로 협상된다. 스위치 없는 직결이므로 점보 프레임이 안전하다.
        mtu = 9000;
        ipv4.addresses = [
          {
            address = "${l.subnet}.${toString octet}";
            prefixLength = 24;
          }
        ];
      }
    ) links
  );

  # 두 MAC이 하나의 물리 포트 = 하나의 L2 세그먼트에 있으므로 기본 설정에서는
  # ARP flux가 발생한다(아무 인터페이스로나 응답/광고). arp_ignore=1 은 받은
  # 인터페이스의 주소에 대해서만 응답하고, arp_announce=2 는 항상 그 인터페이스의
  # 주소를 출처로 쓴다. systemd가 net device add 시 sysctl을 재적용하므로
  # 인터페이스가 늦게 올라와도 적용된다.
  boot.kernel.sysctl = lib.listToAttrs (
    lib.concatMap (d: [
      (lib.nameValuePair "net.ipv4.conf.${d}.arp_ignore" 1)
      (lib.nameValuePair "net.ipv4.conf.${d}.arp_announce" 2)
    ]) devs
  );

  # nftables를 쓰고 있어서 playbook의 nccl-net-setup이 찾는 iptables nixos-fw
  # 체인이 없다. 방화벽은 여기서 선언적으로 열어둔다.
  networking.firewall.trustedInterfaces = devs;
  networking.firewall.extraInputRules = ''
    ip saddr ${peerMgmt} accept comment "spark peer (mpirun/PRRTE callback)"
  '';

  networking.hosts = {
    "192.168.100.11" = [ "spark1-cx0" ];
    "192.168.100.12" = [ "spark2-cx0" ];
    "192.168.101.11" = [ "spark1-cx1" ];
    "192.168.101.12" = [ "spark2-cx1" ];
  };

  # RoCE는 ARP 해석을 기다려주지 않는다. 이웃 캐시가 비어 있으면 retry budget을
  # 태우고 IBV_WC_RETRY_EXC_ERR로 연결이 죽는다. 그래서 NCCL이 처음 건드리기 전에
  # 각 경로를 한 번 깨워 둔다. 두 번째 MAC(192.168.101.x)이 특히 잘 걸리는데,
  # 보통 첫 번째 MAC만 ping해보고 넘어가기 때문이다.
  #
  # multi-user.target의 Before= 가 없으므로(NixOS는 DefaultDependencies만 붙인다)
  # 이 유닛은 부팅을 지연시키지 않는다. 상대 노드가 꺼져 있으면 재시도만 하다가
  # 경고를 남기고 성공으로 끝낸다 -- 한쪽만 켜둔 부팅을 실패로 만들 이유는 없다.
  systemd.services.spark-qsfp-arp-warm = {
    description = "Warm neighbour entries on the QSFP interconnect";
    wantedBy = [ "multi-user.target" ];
    wants = map (l: "network-addresses-${l.dev}.service") links;
    after = [ "network.target" ] ++ map (l: "network-addresses-${l.dev}.service") links;
    path = [ pkgs.iputils ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutStartSec = "180s";
    };
    script = ''
      warm() {
        dev="$1"
        peer="$2"
        i=0
        while [ "$i" -lt 30 ]; do
          i=$((i + 1))
          # -c 4: 이웃 해석이 진행되는 동안 앞쪽 패킷이 떨어지는 것은 정상이고,
          # ping은 응답이 하나라도 오면 성공으로 보고한다.
          if ping -c 4 -W 2 -I "$dev" "$peer" >/dev/null 2>&1; then
            echo "warmed $dev -> $peer (attempt $i)"
            return 0
          fi
          sleep 2
        done
        echo "warning: $peer unreachable via $dev after $i attempts." >&2
        echo "  RoCE on this path will fail with IBV_WC_RETRY_EXC_ERR until it" >&2
        echo "  is pinged. Is the peer up? 'systemctl restart spark-qsfp-arp-warm'" >&2
        return 1
      }

      # 두 경로를 병렬로 깨운다. 순차로 하면 상대가 꺼져 있을 때 재시도 시간이
      # 두 배가 된다. `wait` 는 인자가 없으면 항상 0을 반환하지만 스크립트가
      # `-e` 로 돌기 때문에 의도를 명시해 둔다 -- 경고는 저널에 남기고 유닛은
      # 성공으로 끝낸다.
      for pair in ${peerPlan}; do
        warm "''${pair%%=*}" "''${pair#*=}" &
      done
      wait || true
      exit 0
    '';
  };
}
