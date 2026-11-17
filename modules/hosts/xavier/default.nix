{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
  shared = import ../../../parts/shared.nix { inherit inputs; };
in
{
  flake.modules.nixos.xavier =
    { pkgs, ... }:

    {
      imports =
        [
          inputs.jetpack-nixos.nixosModules.default
          inputs.disko.nixosModules.disko
          ./_disko-config.nix
          ./_hardware-configuration.nix
          nixos.nix
          nixos.user-curt
        ];

      networking.hostName = "xavier"; # Define your hostname.

      hardware.nvidia-jetpack = {
        enable = true;
        som = "xavier-agx";
        carrierBoard = "devkit";
        modesetting.enable = false; # For X11
      };

      boot.kernelModules = [ "iwlwifi" ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = false;

      networking.wireless.enable = true;
      hardware.firmware = with pkgs; [
        linux-firmware
        firmwareLinuxNonfree
      ];

      services.openssh.enable = true;

      system.stateVersion = "25.05";

      environment.systemPackages = with pkgs; [
        git
        nvtopPackages.nvidia
        ollama-cuda
        #python3Packages.torchWithCuda
      ];

    }
    ;

  flake.nixosConfigurations.xavier = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      {
        nixpkgs.config = shared.xavierCudaPkgsConfig;
        nixpkgs.overlays = [
          inputs.jetpack-nixos.overlays.default
        ];
      }
      nixos.xavier
    ];
  };

  flake.nixosConfigurations."xavier-cross" = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      {
        nixpkgs.buildPlatform = "x86_64-linux";
        nixpkgs.hostPlatform = "aarch64-linux";
        nixpkgs.config = shared.xavierCudaPkgsConfig;
        nixpkgs.overlays = [
          inputs.jetpack-nixos.overlays.default
        ];
      }
      nixos.xavier
    ];
  };
}
