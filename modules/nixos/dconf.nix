{ ... }:
{
  flake.modules.nixos.dconf =
    { config, pkgs, ... }:
    {
      programs.dconf.enable = true;
    };
}
