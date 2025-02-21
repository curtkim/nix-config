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
      #../xserver.nix
      ../hyprland.nix
      ../printing.nix
      #../printing-client.nix
    ];

  networking.hostName = hostName; # Define your hostname.

  # bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;

  #  # dfs
  #  fileSystems = {
  #    "/data2" = {
  #      device = "192.168.0.239:/data";
  #      fsType = "nfs4";
  #      options = [
  #        #"vers=4.2"
  #        "x-systemd.automount" "noauto"
  #        "x-systemd.idle-timeout=600"
  #      ];
  #    };
  #  };
  #
  #  # Enable NFS client service
  #  services.rpcbind.enable = true;
}
