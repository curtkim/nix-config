{ hyprland, pkgs, ...}: {
  
  imports = [
    #hyprland.homeManagerModules.default
    ./config.nix
    ./env.nix
  ];

  home.packages = (with pkgs; [
    wofi
    waybar
    wlogout
    tokyo-night-gtk
  ]);

#  dconf.settings = {
#    "org/gnome/desktop/interface" = {
#      color-scheme = "prefer-dark";
#    };
#
#    "org/gnome/shell/extensions/user-theme" = {
#      name = "Tokyonight-Dark-B-LB";
#    };
#  };

}
