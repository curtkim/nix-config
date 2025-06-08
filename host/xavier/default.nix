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
  };

  boot.kernelModules = [ 
    # Enable NVIDIA kernel modules
    "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" 
    "iwlwifi"
  ];
  
  # Enable OpenGL/CUDA support
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  # CUDA environment setup
  environment.variables = {
    CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
    LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";
  };

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
  ];

}
