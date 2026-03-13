{
  config,
  pkgs,
  disko,
  hostName,
  ...
}:

{
  imports = [
    disko.nixosModules.disko
    ./disko-config.nix
    ./hardware-configuration.nix
    ./broadcom-wifi.nix
    ../common.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = hostName; # Define your hostname.
}
