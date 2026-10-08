{ lib, xconfig, pkgs, disko, hostName, ... }:

{
  imports = [
    disko.nixosModules.disko
    ./disko-config.nix
    ./hardware-configuration.nix
    ../common.nix
    ../spark.nix
    ../spark-qsfp.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = hostName; # Define your hostname.
}
