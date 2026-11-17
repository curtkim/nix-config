{ ... }:
{
  flake.modules.nixos.keyboard-voyager =
    { pkgs, config, lib, ... }:
    {
      services.udev.packages = [
        pkgs.zsa-udev-rules
      ];
    }
    ;
}
