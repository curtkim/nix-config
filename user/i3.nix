{
  config,
  pkgs,
  lib,
  ...
}:

{
  xsession = {
    enable = true;
    scriptPath = ".xinitrc";
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;

      config = {
        modifier = "Mod4"; # Super key

        terminal = "kitty";

        keybindings =
          let
            mod = config.xsession.windowManager.i3.config.modifier;
          in
          lib.mkOptionDefault {
            "${mod}+Return" = "exec kitty";
            "${mod}+space" = "exec --no-startup-id rofi -show drun";
          };

        startup = [
          {
            command = "kitty";
            notification = false;
          } # 원하면 제거
        ];

        bars = [
          {
            position = "bottom";
            statusCommand = "${pkgs.i3status}/bin/i3status";
          }
        ];
      };
    };
  };

  home.packages = with pkgs; [
    kitty
    rofi
    i3status
  ];
}
