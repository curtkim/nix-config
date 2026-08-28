{ inputs, ... }:
let
  shared = import ./shared.nix { inherit inputs; };
  inherit (shared) overlays commonPkgsConfig specialArgs;
  inherit (inputs) nixpkgs nixpkgs-unstable home-manager hyprland yt-x;

  mkHome = { system, modules }:
    let
      pkgs = import nixpkgs {
        system = system;
        config = commonPkgsConfig;
        overlays = overlays;
      };
      pkgs-unstable = import nixpkgs-unstable {
        system = system;
        config = commonPkgsConfig;
        overlays = [ ];
      };
      extraSpecialArgs = specialArgs // {
        pkgs-unstable = pkgs-unstable;
        hyprland = hyprland;
        yt-x = yt-x;
      };
    in
    home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs;
      extraSpecialArgs = extraSpecialArgs;
      inherit modules;
    };
in
{
  flake.homeConfigurations = {
    curt = mkHome {
      system = "x86_64-linux";
      modules = [
        ../user
      ];
    };
    curt_arm = mkHome {
      system = "aarch64-linux";
      modules = [
        ../user
      ];
    };

    curt_minimal = mkHome {
      system = "x86_64-linux";
      modules = [
        ../user/default-minimal.nix
      ];
    };
    curt_minimal_arm = mkHome {
      system = "aarch64-linux";
      modules = [
        ../user/default-minimal.nix
      ];
    };
  };
}
