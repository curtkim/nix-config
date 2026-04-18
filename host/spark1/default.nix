{ xconfig, pkgs, disko, hostName, ... }:

{
  imports = [
    disko.nixosModules.disko
    ./disko-config.nix
    ./hardware-configuration.nix
    ../common.nix
  ];

  # Enable DGX Spark hardware support with NVIDIA kernel
  hardware.dgx-spark.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable zram swap for better memory management
  # zramSwap.enable = true;

  networking.hostName = hostName; # Define your hostname.
}
