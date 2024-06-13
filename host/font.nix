{ config, pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ 
      ubuntu_font_family
      nanum
      nanum-gothic-coding
      (nerdfonts.override { fonts = ["JetBrainsMono" "Hack"]; })
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
  
    fontconfig = {
      defaultFonts = {
        serif = [ "Ubuntu" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ "JetBrainsMono Nerd Font, Light" ];
      };
    };
  };

}
