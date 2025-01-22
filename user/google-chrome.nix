{ pkgs, pkgs-unstable, ... }:

{
  programs.google-chrome = {
    enable = true;

    # ver < 125 에서 --enable-wayland-ime관련 문제가 있었다.
    #package = pkgs-unstable.google-chrome;
    package = pkgs.google-chrome;

    commandLineArgs = [
      #"--ozone-platform=wayland"
      "--enable-wayland-ime"

      "--enable-unsafe-webgpu"
      "--enable-webgpu-developer-feature"
      "--force-webgpu-compat"
    ];
  };
}
