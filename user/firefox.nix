{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.firefox = {
    enable = true;

    # home-manager 26.05 부터 home.stateVersion >= 26.05 이면 프로필 기본 경로가
    # ~/.mozilla/firefox -> $XDG_CONFIG_HOME/mozilla/firefox 로 바뀐다.
    # 기존 ~/.mozilla/firefox/default 프로필(5GB+)을 그대로 쓰기 위해 예전 경로로 고정.
    configPath = ".mozilla/firefox";

    profiles.default = {
      settings = {
        # userChrome.css 를 적용하려면 반드시 필요
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.uidensity" = 1; # compact, let's see how long will it last
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";

        "browser.tabs.tabMinWidth" = 16;
        "browser.startup.homepage" = "https://www.google.com/";
        "browser.startup.page" = 3; # Restore previous tabs
        "privacy.trackingprotection.enabled" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
      };

      # ~/.mozilla/firefox/default/chrome/userChrome.css
      userChrome = lib.readFile ./firefox-userChrome.css;

      # userChrome = ''
      #   #nav-bar, #urlbar-container, #searchbar { visibility: collapse !important; }
      #   #tab-background { max-height: 32px !important; }
      #   :root {	--tab-min-height: 32px !important;
      #           --tab-max-height: 32px !important;}
      # '';

      # https://addons.mozilla.org/firefox/downloads/file/4210117/vimium_c-1.99.997.xpi
      # https://addons.mozilla.org/firefox/downloads/file/4460303/immersive_translate-1.15.10.xpi
      extensions.packages = with pkgs.firefox-addons; [
        vimium-c
        immersive-translate
        web-clipper-obsidian
        #tree-style-tab
      ];
    };
  };
}
