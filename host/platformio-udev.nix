{ pkgs, config, lib, ... }:
{
  services.udev.packages = with pkgs; [ 
    platformio-core.udev 
  ];
}
