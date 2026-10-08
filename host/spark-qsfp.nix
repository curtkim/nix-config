# DGX Spark 두 대를 QSFP로 직결(stacked sparks)했을 때의 인터커넥트 설정.
#
# NVIDIA 가이드(https://build.nvidia.com/spark/connect-two-sparks/stacked-sparks)는
# netplan/nmcli로 매 부팅마다 ip를 붙이지만, 양쪽 모두 NixOS이므로 선언적으로 고정한다.
#
# 중요: QSFP 소켓 1개 = 100G MAC 2개(각각 별도 PCIe x4 링크)다.
# enp1s0f0np0 과 enP2p1s0f0np0 은 같은 물리 포트이고, 200Gbps를 내려면 둘 다
# 주소가 있어야 한다(RoCEv2 GID는 인터페이스의 IPv4에서 파생되므로, 주소가 없는
# MAC은 link-local GID만 갖고 NCCL이 쓰지 못한다). 케이블 1개로 충분하다.
{ lib, hostName, ... }:

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
}
