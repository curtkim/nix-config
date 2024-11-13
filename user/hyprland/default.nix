{ pkgs, ... }:
{
  imports = [
    ./general.nix
    ./bind.nix
    ./rules.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    #package = hyprland.packages."${pkgs.system}".hyprland;
  };

  #home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;

  # https://wiki.hyprland.org/Useful-Utilities/Must-have/
  services.dunst = {
    enable = true;
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  home.packages = with pkgs; [
    #cinnamon.nemo
    #libsForQt5.dolphin
    wofi
    grim
    #gnome.eog
    waybar
    wlogout
    #foot
    notify-desktop # notify-desktop "title" "BODY"
  ];
}
