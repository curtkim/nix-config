# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ xconfig, pkgs, disko, hostName, ... }:

{
  imports = [
    ../boot.nix
    disko.nixosModules.disko
    ./disko-config.nix
    ./hardware-configuration.nix
    ../amd.nix
    ../common.nix
  ];


  networking.hostName = hostName; # Define your hostname.

  boot.kernelParams = [ 
    "ttm.pages_limit=29360128" 
  ];

  environment.systemPackages = with pkgs; [
    amdgpu_top
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
    ds4
    fastflowlm
  ];

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "memlock";
      value = "8388608";
    }
    {
      domain = "*";
      type = "hard";
      item = "memlock";
      value = "8388608";
    }
  ];
}
