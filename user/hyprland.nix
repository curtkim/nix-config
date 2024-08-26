{ pkgs, ... }:
{
  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;

  # https://wiki.hyprland.org/Useful-Utilities/Must-have/
  services.dunst = {
    enable = true;
  };

  home.packages = with pkgs; [
    notify-desktop # notify-desktop "title" "BODY"
  ];
}
