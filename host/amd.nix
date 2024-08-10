{ config, pkgs, ... }:

{
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["admgpu"]; 

  hardware.hardware.extraPackages = with pkgs; [
    amdvlk
  ];

}
