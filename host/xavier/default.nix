{ disko, jetpack-nixos, hostName, pkgs, ... }:

{
  imports =
    [
      jetpack-nixos.nixosModules.default
      disko.nixosModules.disko
      ./disko-config.nix
      ./hardware-configuration.nix
      ../nix.nix
      ../user_curt.nix
    ];

  networking.hostName = hostName; # Define your hostname.

  environment.systemPackages = with pkgs; [
    git
    home-manager
  ];

  hardware.nvidia-jetpack = {
    enable = true;
    som = "xavier-agx";
    carrierBoard = "devkit";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  services.openssh.enable = true;

  system.stateVersion = "25.05";
}
