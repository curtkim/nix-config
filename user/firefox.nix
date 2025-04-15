{ config, pkgs, lib, pkgs-unstable, ... }: {
  programs.firefox = {
    enable = true;
    #package = pkgs-unstable.firefox;

    profiles.default = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      # ~/.mozilla/firefox/default/chrome/userChrome.css
      userChorme = lib.readFile ./firefox-userChrome.css;
      # userChrome = ''
      #   #nav-bar, #urlbar-container, #searchbar { visibility: collapse !important; }
      #   #tab-background { max-height: 32px !important; }
      #   :root {	--tab-min-height: 32px !important;
      #           --tab-max-height: 32px !important;}
      # '';

      # https://addons.mozilla.org/firefox/downloads/file/4210117/vimium_c-1.99.997.xpi
      # https://addons.mozilla.org/firefox/downloads/file/4460303/immersive_translate-1.15.10.xpi
      extensions = with pkgs.firefox-addons; [
        vimium-c
        #immersive-translate
      ];
    };
  };
}
