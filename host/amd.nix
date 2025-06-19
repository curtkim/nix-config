{ config, pkgs, ... }:

{
  hardware.graphics= {
    enable = true;
  };
  hardware.amdgpu.amdvlk.enable = true;

  services.xserver.videoDrivers = ["admgpu"]; 

}
