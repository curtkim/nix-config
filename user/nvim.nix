{ pkgs, pkgs-unstable, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs-unstable.neovim-unwrapped;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaPackages = ls:
      with ls; [
        luarocks
        magick              # required by 3rd/image.nvim
      ];
  };
}

