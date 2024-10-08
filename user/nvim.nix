{ pkgs, pkgs-unstable, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs-unstable.neovim-unwrapped;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}

