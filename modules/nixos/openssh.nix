{ ... }:
{
  flake.modules.nixos.services =
    {
      services.openssh.enable = true;
    };
}
