# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, disko, userName, hostName, ... }:

{
  imports =
    [
      ../boot.nix
      disko.nixosModules.disko
      ./disko-config.nix
      ./hardware-configuration.nix
      ../nvidia.nix
      ../common.nix
      ../xserver.nix
      ../icestick.nix
      #../hyprland.nix
      ../printing.nix
    ];

  networking.hostName = hostName; # Define your hostname.

  services.openssh.enable = true;

  services.hardware.openrgb.enable = true;
}
