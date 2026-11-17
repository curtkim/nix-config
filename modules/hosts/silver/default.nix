{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.nixosConfigurations.silver = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      (
        {
          config,
          pkgs,
          ...
        }:

        {
          imports = [
            inputs.disko.nixosModules.disko
            ./_disko-config.nix
            ./_hardware-configuration.nix
            ./_broadcom-wifi.nix
            nixos.common
            nixos.xserver
          ];

          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;

          boot.kernelParams = [
            "i915.force_probe=0166"
            "acpi_osi="
            "acpi_backlight=vendor"
          ];
          boot.kernelModules = [ "apple-gmux" ];
          boot.initrd.kernelModules = [
            "i915"
            "apple-gmux"
          ];
          services.xserver.videoDrivers = [ "modesetting" ];

          # boot.blacklistedKernelModules = [
          #   "nouveau"
          #   "nvidia"
          # ];
          # boot.initrd.kernelModules = [ "i915" ];
          # boot.kernelParams = [
          #   "i915.modeset=1"
          # ];
          #
          # hardware.graphics.enable = true;
          # hardware.enableRedistributableFirmware = true;
          #
          # services.xserver = {
          #   videoDrivers = [ "modesetting" ];
          #   deviceSection = ''
          #     Driver "modesetting"
          #     BusID "PCI:0:2:0"
          #   '';
          # };

          # x시작전에 부팅중에 화면이 깨짐
          # nixpkgs.config.nvidia.acceptLicense = true;
          # #hardware.nvidia.open = false;
          # hardware.nvidia = {
          #   modesetting.enable = true;
          #   powerManagement.enable = false;
          #   package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
          # };
          # services.xserver.videoDrivers = [ "nvidia" ];

          networking.hostName = "silver"; # Define your hostname.
        }
      )
    ];
  };
  flake.nixosConfigurations."silver-installer" = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      # common 을 쓰지 않으므로 unfree 허용 목록(broadcom-sta)을 직접 import 한다.
      nixos.nixpkgs-common
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ./_broadcom-wifi.nix
    ];
  };
}
