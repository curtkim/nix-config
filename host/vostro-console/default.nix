# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, disko, hyprland, hostName, userName, ... }:

{
  imports =
    [
      disko.nixosModules.disko
      ../vostro/disko-config.nix
      ../vostro/hardware-configuration.nix
      ../common.nix
      ../boot.nix
    ];

  networking.hostName = hostName; # Define your hostname.

  programs.hyprland.enable = true;
  programs.hyprland.package = hyprland.packages."${pkgs.system}".hyprland;

  #  environment.systemPackages = with pkgs; [
  #    hyprland
  #    cinnamon.nemo
  #    libsForQt5.dolphin
  #    wofi
  #    grim
  #    gnome.eog
  #    waybar
  #    wlogout
  #    foot
  #  ];
}
