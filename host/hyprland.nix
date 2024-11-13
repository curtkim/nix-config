{ config, pkgs, hyprland, ... }:

{
  #  services.xserver = {
  #    enable = true;
  #    displayManager.gdm = {
  #      enable = true;
  #      wayland = true;
  #    };
  #  };
  #
  #  # hyprland
  #  programs.hyprland = {
  #    enable = true;
  #    xwayland.enable = true;
  #    #package = hyprland.packages."${pkgs.system}".hyprland;
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
  ];
}
