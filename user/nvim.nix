{ pkgs, pkgs-unstable, ... }:

let
  unstable-neovim-unwrapped = pkgs-unstable.neovim-unwrapped.overrideAttrs (old: {
    meta = old.meta or { } // {
      maintainers = [ ];
    };
  });
in 
{
  programs.neovim = {
    enable = true;
    package = unstable-neovim-unwrapped; #pkgs-unstable.neovim-unwrapped;
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

