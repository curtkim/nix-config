{ pkgs, pkgs-unstable, ... }:

{
  programs.google-chrome = {
    enable = true;
    # ver < 125 에서 --enable-wayland-ime관련 문제가 있었다.
    package = pkgs-unstable.google-chrome;

    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
    ];
  };
}