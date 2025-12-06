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

# url : http://localhost:8096/web/#/home.html
# 어디에 music, video 디렉토를 설정했는지 기억이 안남

