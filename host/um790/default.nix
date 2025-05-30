# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ xconfig, pkgs, disko, hostName, ... }:

{
  imports =
    [
      ../boot.nix
      disko.nixosModules.disko
      ./disko-config.nix
      ./hardware-configuration.nix
      ../amd.nix
      ../common.nix
      ../minidlna.nix
      ../jellyfin.nix
      #../xserver.nix
      ../printing.nix
      #../printing-client.nix
      ./nfs-client.nix
    ];

  networking.hostName = hostName; # Define your hostname.

  # bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;

  services.nix-serve = {
    enable = true;
    openFirewall = true;
    secretKeyFile = "${./nix-serve-priv-key.pem}";
  };
}
