{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.nixosConfigurations.spark2 = inputs.dgx-spark.inputs.nixpkgs.lib.nixosSystem {
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

          # dgx-spark nixpkgs를 사용하므로 nix registry 충돌을 해소한다.
          nix.registry.nixpkgs.to = lib.mkForce {
            type = "path";
            path = inputs.dgx-spark.inputs.nixpkgs.outPath;
          };
        }
      )
    ];
  };
}
