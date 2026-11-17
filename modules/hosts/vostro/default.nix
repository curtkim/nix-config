{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.nixosConfigurations.vostro = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      (
        # Edit this configuration file to define what should be installed on
        # your system.  Help is available in the configuration.nix(5) man page
        # and in the NixOS manual (accessible by running ‘nixos-help’).

        { config, pkgs, ... }:

        {
          imports =
            [
              inputs.disko.nixosModules.disko
              ./_disko-config.nix
              ./_hardware-configuration.nix
              nixos.common
              nixos.xserver
              nixos.boot
            ];

          networking.hostName = "vostro"; # Define your hostname.
        }
      )
    ];
  };
}
