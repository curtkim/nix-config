{ config, pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      ubuntu_font_family
      nanum
      nanum-gothic-coding
      #nerd-fonts.jetbrains-mono
      #nerd-fonts.hack
      #(nerdfonts.override { fonts = [ "JetBrainsMono" "Hack" ]; })
      nerd-fonts.hack
      nerd-fonts.jetbrains-mono
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
