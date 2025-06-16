{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ethtool
  ];

  # 부팅 시 WOL 활성화
  systemd.services.wol-enable = {
    description = "Enable Wake on LAN";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ethtool}/bin/ethtool -s enp14s0 wol g";
      RemainAfterExit = true;
    };
  };
}
