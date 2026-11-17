{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.nixosConfigurations."vostro-console" = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      (
        # Edit this configuration file to define what should be installed on
        # your system.  Help is available in the configuration.nix(5) man page
        # and in the NixOS manual (accessible by running ‘nixos-help’).

        { config, pkgs, ... }:

        {
          imports =
            [
              inputs.disko.nixosModules.disko
              ../vostro/_disko-config.nix
              ../vostro/_hardware-configuration.nix
              nixos.common
              nixos.boot
            ];

          networking.hostName = "vostro"; # Define your hostname.

          programs.hyprland.enable = true;
          programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

          #  environment.systemPackages = with pkgs; [
          #    hyprland
          #    cinnamon.nemo
          #    libsForQt5.dolphin
          #    wofi
          #    grim
          #    gnome.eog
          #    waybar
          #    wlogout
          #    foot
          #  ];
        }
      )
    ];
  };
}
