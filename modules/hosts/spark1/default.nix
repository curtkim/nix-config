{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  # dgx-spark 고유의 nixpkgs를 사용한다. root nixpkgs(최신 unstable)의
  # glibc 2.44 aarch64 헤더에 __u128 타입이 추가되어 커널 6.17.13
  # NVIDIA 모듈 빌드가 깨지기 때문이다.
  flake.nixosConfigurations.spark1 = inputs.dgx-spark.inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      inputs.dgx-spark.nixosModules.dgx-spark
      (
        { lib, xconfig, pkgs, ... }:

        {
          imports = [
            inputs.disko.nixosModules.disko
            ./_disko-config.nix
            ./_hardware-configuration.nix
            nixos.common
            nixos.spark
            nixos.spark-qsfp
          ];

          # Use the systemd-boot EFI boot loader.
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;

          networking.hostName = "spark1"; # Define your hostname.

          # ds4-server (HTTP API)
          networking.firewall.allowedTCPPorts = [ 8000 ];

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
