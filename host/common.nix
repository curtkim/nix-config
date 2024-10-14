{ config, pkgs, ... }:
{
  imports = [
    ./nix.nix
    ./locale.nix
    ./font.nix
    ./input-method.nix
    ./virtualisation.nix
    ./network.nix
    ./sound.nix
    ./minidlna.nix
    ./services.nix
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.curt = {
    isNormalUser = true;
    description = "curt";
    extraGroups = [ "networkmanager" "wheel" "input" "incus-admin" ];
    packages = with pkgs; [
    ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    gcc
    usbutils
    pciutils
    lshw

    # for incus
    distrobuilder
    cdrkit
    hivex
    wimlib

    home-manager
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
