{ pkgs, pkgs-unstable, ... }:

{
#  programs.chromium = {
#    enable = true;
#    # ver < 125 에서 --enable-wayland-ime관련 문제가 있었다.
#    package = pkgs-unstable.ungoogled-chromium;
#
#    commandLineArgs = [
#      "--ozone-platform=wayland"
#      "--enable-wayland-ime"
#      "--no-default-browser-check"
#      "--restore-last-sesion"
#    ];
#    extensions = [
#      # vimium C
#      "hfjbmagddngcpeloejdejnfgbamkjaeg"
#      "nacjakoppgmdcpemlfnfegmlhipddanj"
#
#      # mouse tooltip translator
#      "hmigninkgibhdckiaphhmbgcghochdjc"
#    ];
#  };
}
