{ config, pkgs, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    #user="curt";
    #dataDir = "/var/lib/jellyfin";
    package = pkgs.jellyfin;
  };

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
}

