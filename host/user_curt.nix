{ config, pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.curt = {
    isNormalUser = true;
    description = "curt";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "video"
      "libvirt"
      "adbusers"
    ];
    packages = with pkgs; [
    ];
    #shell = pkgs.zsh;
  };

  #programs.zsh.enable = true;
}
