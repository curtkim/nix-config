{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # DGX Spark typical kernel modules
  boot.initrd.availableKernelModules = [
    "nvme" # NVMe storage
    "usb_storage" # USB storage support
    "usbhid" # USB input devices
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];


  # Platform configuration for DGX Spark (ARM64)
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
