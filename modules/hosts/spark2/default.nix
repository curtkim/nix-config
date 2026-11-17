{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.nixosConfigurations.spark2 = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      inputs.dgx-spark.nixosModules.dgx-spark
      (
        { lib, xconfig, pkgs, ... }:

        {
          imports = [
            inputs.disko.nixosModules.disko
            ./_disko-config.nix
            ../spark1/_hardware-configuration.nix
            nixos.common
            nixos.spark
            nixos.spark-qsfp
          ];

          # Use the systemd-boot EFI boot loader.
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;

          networking.hostName = "spark2"; # Define your hostname.
        }
      )
    ];
  };
}
