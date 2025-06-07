{ disko, jetpack-nixos, hostName, ... }:

{
  imports =
    [
      jetpack-nixos.nixosModules.default
      disko.nixosModules.disko
      ./disko-config.nix
      ./hardware-configuration.nix
      ../user_curt.nix
    ];

  networking.hostName = hostName; # Define your hostname.


  hardware.nvidia-jetpack = {
    enable = true;
    som = "xavier-agx";
    carrierBoard = "devkit";
  };
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  
  services.openssh.enable = true;
}
