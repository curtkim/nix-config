# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, disko, hostName, ... }:

{
  imports =
    [
      ../boot.nix
      disko.nixosModules.disko
      ./disko-config.nix
      ./hardware-configuration.nix
      ./nfs.nix
      ../nvidia.nix
      ../common.nix
      #../xserver.nix
      ../icestick.nix
      #../printing.nix
      ./wake-on-lan.nix
      ../nix-distributed-build-client.nix
    ];

  networking.hostName = hostName; # Define your hostname.

  services.hardware.openrgb.enable = true;
}
