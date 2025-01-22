{ config, pkgs, ... }:

{
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    #driSupport = true;
    #driSupport32Bit = true;
  };
  hardware.amdgpu.amdvlk.enable = true;

  services.xserver.videoDrivers = ["admgpu"]; 

}
