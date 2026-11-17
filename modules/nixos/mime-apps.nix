# user/xdg-mimeApps.nix 의 hjem 버전. ~/.config/mimeapps.list 를 만든다.
{ config, pkgs, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.modules.nixos.mime-apps =
    { config, pkgs, ... }:
    {
      imports = [ nixos.hjem ];

      environment.systemPackages = with pkgs; [
        imv 
      ];

      hjem.users.curt.xdg.mime-apps.default-applications =
        let
          #browser = "google-chrome.desktop";
          #browser = "firefox.desktop";
          browser = "helium.desktop";
          image-viewer = "imv.desktop";
        in
        {
          "image/png" = image-viewer;
          "text/html" = browser;
          "application/pdf" = browser;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "x-scheme-handler/about" = browser;
          "x-scheme-handler/unknown" = browser;
        };
    };
}
