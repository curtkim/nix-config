{ pkgs, config, lib, ... }:
{
  services.udev.packages = [
    pkgs.zsa-udev-rules
  ];
}
