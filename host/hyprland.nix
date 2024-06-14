{ config, pkgs, hyprland, ... }:

{
  programs.hyprland = {
    enable = true;
    package = hyprland.packages."${pkgs.system}".hyprland;
  };

  # greetd
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "curt";
      };
#      initial_session = {
#        user = "enzo";
#        command = "$SHELL -l";
#      };
    };
  };

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

#  environment.systemPackages = with pkgs; [
#    hyprland
#    cinnamon.nemo
#    libsForQt5.dolphin
#    wofi
#    grim
#    gnome.eog
#    waybar
#    wlogout
#    foot
#  ];
}
