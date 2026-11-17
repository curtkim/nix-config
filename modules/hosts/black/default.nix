{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
  shared = import ../../../parts/shared.nix { inherit inputs; };
in
{
  flake.nixosConfigurations.black = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      {
        nixpkgs.config = shared.commonPkgsConfig // shared.cudaPkgsConfig;
        nixpkgs.overlays = shared.overlays;
      }
      (
        # Edit this configuration file to define what should be installed on
        # your system.  Help is available in the configuration.nix(5) man page
        # and in the NixOS manual (accessible by running ‘nixos-help’).

        { config, pkgs, ... }:

        {
          imports =
            [
              nixos.boot
              inputs.disko.nixosModules.disko
              ./_disko-config.nix
              ./_hardware-configuration.nix
              ./_nfs.nix
              nixos.nvidia
              nixos.common
              #../xserver.nix
              nixos.icestick
              #../printing.nix
              ./_openrgb-off.nix
              #./_sunshine.nix
              #../nix-distributed-build-client.nix
            ];

          networking.hostName = "black"; # Define your hostname.

          # Wake-on-LAN (systemd .link 파일로 설정되므로 링크 재설정 후에도 유지된다)
          networking.interfaces.enp14s0.wakeOnLan.enable = true;

          services.hardware.openrgb.enable = true;
        }
      )
    ];
  };
}
