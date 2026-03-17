{
  config,
  pkgs,
  disko,
  hostName,
  ...
}:

{
  imports = [
    disko.nixosModules.disko
    ./disko-config.nix
    ./hardware-configuration.nix
    ./broadcom-wifi.nix
    ../common.nix
    ../xserver.nix
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

  networking.hostName = hostName; # Define your hostname.
}
