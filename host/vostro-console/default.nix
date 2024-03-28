# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, disko, hostName, ... }:

{
  imports =
    [
      disko.nixosModules.disko
      ../vostro/disko-config.nix
      ../vostro/hardware-configuration.nix
      ../common.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  networking.hostName = hostName; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


#  # Enable the X11 windowing system.
#  services.xserver.enable = true;
#
#  # Enable the GNOME Desktop Environment.
#  services.xserver.displayManager.gdm.enable = true;
#  services.xserver.desktopManager.gnome.enable = true;
#
#  # Configure keymap in X11
#  services.xserver = {
#    layout = "kr";
#    xkbVariant = "";
#  };
  environment.systemPackages = with pkgs; [
    hyprland
    cinnamon.nemo
    libsForQt5.dolphin
    wofi
    grim
    gnome.eog
    waybar
    wlogout
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
}
