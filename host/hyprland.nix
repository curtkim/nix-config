{ config, pkgs, hyprland, ... }:

{
  services.xserver = {
      enable = true;
    #videosDrivers = ["nvidia"];
      displayManager.gdm = {
          enable = true;
          wayland = true;
      };
  };

  hardware = {
      opengl.enable = true;
  };

  # hyprland
  programs.hyprland = {
      enable = true;
      xwayland.enable = true;
  };

  #  programs.hyprland = {
  #    enable = true;
  #    package = hyprland.packages."${pkgs.system}".hyprland;
  #  };

  #  # greetd
  #  services.greetd = {
  #    enable = true;
  #    settings = {
  #      default_session = {
  #        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
  #        user = "curt";
  #      };
  #    };
  #  };
  #
  #  programs.dconf.enable = true;
  #
  #  xdg.portal = {
  #    enable = true;
  #    wlr.enable = true;
  #  };

  environment.systemPackages = with pkgs; [
    cinnamon.nemo
    libsForQt5.dolphin
    wofi
    grim
    gnome.eog
    waybar
    wlogout
    foot
  ];
}
