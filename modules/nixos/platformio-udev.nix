{ ... }:
{
  flake.modules.nixos.platformio-udev =
    { pkgs, config, lib, ... }:
    {
      services.udev.packages = with pkgs; [ 
        platformio-core.udev 
      ];
    };
}
