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

  hardware.nvidia-jetpack = {
    enable = true;
    som = "xavier-agx";
    carrierBoard = "devkit";
    modesetting.enable = false; # For X11
  };

  boot.kernelModules = [ "iwlwifi" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.wireless.enable = true;
  hardware.firmware = with pkgs; [
    linux-firmware
    firmwareLinuxNonfree
  ];

  services.openssh.enable = true;

  system.stateVersion = "25.05";

  environment.systemPackages = with pkgs; [
    git
    nvtopPackages.nvidia
    ollama-cuda
    #python3Packages.torchWithCuda
  ];

}
