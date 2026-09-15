{ config, ... }:
let
  openrgb = "${config.services.hardware.openrgb.package}/bin/openrgb";
in
{
  # 부팅 시 RGB 소등
  systemd.services.openrgb-off = {
    description = "Turn off RGB lighting";
    after = [ "openrgb.service" ];
    wants = [ "openrgb.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = [
        "${openrgb} --noautoconnect --device 0 --mode direct --color 000000 -b 0"
        "${openrgb} --noautoconnect --device 1 --mode direct --color 000000 -b 0"
      ];
    };
  };
}
