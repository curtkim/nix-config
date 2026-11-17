{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.nixosConfigurations.roter = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      (
        # Edit this configuration file to define what should be installed on
        # your system.  Help is available in the configuration.nix(5) man page
        # and in the NixOS manual (accessible by running ‘nixos-help’).

        { xconfig, pkgs, ... }:

        {
          imports =
            [
              nixos.boot
              inputs.disko.nixosModules.disko
              ./_disko-config.nix
              ./_hardware-configuration.nix
              nixos.common
              # max1 에서 원격 빌드 + substitute
              nixos.nix-distributed-build-client
              #../xserver.nix
              nixos.printing
            ];

          networking.hostName = "roter"; # Define your hostname.
        }
      )
    ];
  };
}
