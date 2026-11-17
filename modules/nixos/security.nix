{ ... }:
{
  flake.modules.nixos.security =
    { config, pkgs, ... }:
    {
      security = {
        polkit.enable = true;
        pam.services.hyprlock = {};
      };
    };
}
