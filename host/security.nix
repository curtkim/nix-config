{ config, pkgs, hyprland, ... }:

{
  security = {
    polkit.enable = true;
    pam.services.hyprlock = {};
  };
}
