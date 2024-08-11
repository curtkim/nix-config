# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ xconfig, pkgs, disko, hostName, ... }:

{
  imports =
    [
      disko.nixosModules.disko
      ./disko-config.nix
      ./hardware-configuration.nix
      ../amd.nix
      ../common.nix
      #../xserver.nix
      ../hyprland.nix
      ../boot.nix
    ];

  networking.hostName = hostName; # Define your hostname.
}
