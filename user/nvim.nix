{ pkgs, pkgs-unstable, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaPackages = ls:
      with ls; [
        luarocks
        # required by 3rd/image.nvim
        magick
      ];
  };
}

