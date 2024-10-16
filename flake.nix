{
  nixConfig = {
    extra-experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #    hyprland = {
    #      url = "github:hyprwm/Hyprland";
    #      inputs.nixpkgs.follows = "nixpkgs";
    #    };
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };
    #hyprlock.url = "github:hyprwm/Hyprlock";
    #hyprlock.inputs.nixpkgs.follows = "nixpkgs-unstable";
    #hyprland.url = "github:hyprwm/Hyprland";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs"; # ...
    };
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , nixpkgs-unstable
    , hyprland
    , home-manager
    , disko
    , darwin
    , ...
    }:
    let
      system = "x86_64-linux";
      specialArgs = {
        hostName = "none";
        userName = "curt";
        cudaSupport = false;
        disko = disko;
        hyprland = hyprland;
        pkgs-unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
          config.cudaCapabilities = [ "8.6" ];
          config.permittedInsecurePackages = [
            "freeimage-unstable-2021-11-01"
          ];
        };
        inherit inputs;
      };
      pkgs = import nixpkgs {
        config.allowUnfree = true; # 여기서 allowUnfree 설정
        config.cudaCapabilities = [ "8.6" ];
        config.permittedInsecurePackages = [
          "freeimage-unstable-2021-11-01"
        ];
        system = system;
      };
    in
    {
      nixosConfigurations.um790 = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = specialArgs // { hostName = "um790"; };
        modules = [
          ({pkgs, ...}: {
            # why working?
            nixpkgs.config.allowUnfree = true;
          })
          ./host/um790
          #          home-manager.nixosModules.home-manager
          #          {
          #            home-manager.users.curt = import ./user;
          #            home-manager.extraSpecialArgs = specialArgs;
          #          }
        ];
      };

      nixosConfigurations.roter = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = specialArgs // { hostName = "roter"; };
        modules = [
          ./host/roter
        ];
      };

      nixosConfigurations.vostro = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = specialArgs // { hostName = "vostro"; };
        modules = [
          ./host/vostro
        ];
      };

      nixosConfigurations."vostro-console" = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = specialArgs // { hostName = "vostro"; };
        modules = [
          ./host/vostro-console
        ];
      };

      nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
        pkgs = pkgs;
        system = system;
        specialArgs = specialArgs // { hostName = "workstation"; cudaSupport = true; };
        modules = [
          ./host/workstation
          #hyprland.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.users.curt = import ./user;
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };

      darwinConfigurations."curtg" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/m2/default.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.users.curt = import ./user/default_mac.nix;
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };

      homeConfigurations.curt = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        extraSpecialArgs = specialArgs;
        modules = [
          ./user
        ];
      };

      packages = import ./pkgs nixpkgs.legacyPackages.x86_64-linux;

    };
}
