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
      ./openrgb-off.nix
      #./sunshine.nix
      #../nix-distributed-build-client.nix
    ];

  networking.hostName = hostName; # Define your hostname.

  # Wake-on-LAN (systemd .link 파일로 설정되므로 링크 재설정 후에도 유지된다)
  networking.interfaces.enp14s0.wakeOnLan.enable = true;

  services.hardware.openrgb.enable = true;
}
