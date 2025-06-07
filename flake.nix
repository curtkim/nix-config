{
  nixConfig = {
    # current flake에 적용된다.
    extra-experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://hyprland.cachix.org"
      "http://192.168.0.198:5000"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "192.168.0.198:xAxl3IZFQCZKbaEfNm/HljvQvm+Q14HSIHcdeMccy6g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
    rust-overlay.url = "github:oxalica/rust-overlay";

    nvf.url = "github:notashelf/nvf";

    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.flake-utils.follows = "flake-utils";
    };

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jetpack-nixos.url = "github:anduril/jetpack-nixos";
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , nixpkgs-unstable
    , hyprland
    , home-manager
    , disko
    , darwin
    , rust-overlay
    , nvf
    , ...
    }:
    let
      system = "x86_64-linux";
      overlays = [
        (import rust-overlay)
        (final: prev: {
          kime = let
              rustVersion = "1.81.0";
            in prev.kime.override {
              rustc = final.rust-bin.stable.${rustVersion}.default;
              cargo = final.rust-bin.stable.${rustVersion}.default;
            };
        })
        (final: prev: 
          import ./pkgs {
            pkgs = prev;
            inherit (inputs) uv2nix pyproject-nix pyproject-build-systems;
          }
        )
        (final: prev: {
          firefox-addons = import inputs.firefox-addons {
            inherit (final) fetchurl lib stdenv;
          };
        })
      ];
      pkgsConfig = {
        allowUnfree = true;
        allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
          "immersive-translate"
        ];
        nvidia.acceptLicense = true;
        cudaSupport = true;
        cudaCapabilities = [ "8.6" ];
        permittedInsecurePackages = [
          "freeimage-unstable-2021-11-01"
        ];
      };
      pkgs = import nixpkgs {
        system = system;
        config = pkgsConfig;
        overlays = overlays;
      };
      pkgs-unstable = import nixpkgs-unstable {
        system = system;
        config = pkgsConfig;
        overlays = [];
      };
      specialArgs = {
        hostName = "none";
        userName = "curt";
        nixpkgs = nixpkgs;
        disko = disko;
        hyprland = hyprland;
        pkgs-unstable = pkgs-unstable;
        inherit inputs;
      };

      forAllSystems = nixpkgs.lib.genAttrs [ system ];
    in
    {
      nixosConfigurations.um790 = nixpkgs.lib.nixosSystem {
        system = system;
        pkgs = pkgs;
        specialArgs = specialArgs // { hostName = "um790"; };
        modules = [
          #          ({pkgs, ...}: {
          #            # why working?
          #            nixpkgs.config.allowUnfree = true;
          #          })
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
        pkgs = pkgs;
        specialArgs = specialArgs // { hostName = "roter"; };
        modules = [
          ./host/roter
        ];
      };

      nixosConfigurations.gen53 = nixpkgs.lib.nixosSystem {
        system = system;
        pkgs = pkgs;
        specialArgs = specialArgs // { hostName = "gen53"; };
        modules = [
          ./host/gen53
        ];
      };

      nixosConfigurations.vostro = nixpkgs.lib.nixosSystem {
        system = system;
        pkgs = pkgs;
        specialArgs = specialArgs // { hostName = "vostro"; };
        modules = [
          ./host/vostro
        ];
      };

      nixosConfigurations."vostro-console" = nixpkgs.lib.nixosSystem {
        system = system;
        pkgs = pkgs;
        specialArgs = specialArgs // { hostName = "vostro"; };
        modules = [
          ./host/vostro-console
        ];
      };

      nixosConfigurations.black = nixpkgs.lib.nixosSystem {
        system = system;
        pkgs = pkgs;
        specialArgs = specialArgs // { hostName = "black"; cudaSupport = true; };
        modules = [
          ./host/black
          #          ({pkgs, ...}: {
          #            # why working?
          #            nixpkgs.config.allowUnfree = true;
          #          })
          #hyprland.nixosModules.default
          #          home-manager.nixosModules.home-manager
          #          {
          #            home-manager.users.curt = import ./user;
          #            home-manager.extraSpecialArgs = specialArgs;
          #          }
        ];
      };

      nixosConfigurations.xavier = nixpkgs.lib.nixosSystem {
        system = system;
        pkgs = pkgs;
        specialArgs = specialArgs // { hostName = "xavier"; };
        modules = [
          ./host/xavier
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
      homeConfigurations.curt_minimal = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        extraSpecialArgs = specialArgs;
        modules = [
          ./user/default_minimal.nix
        ];
      };

      #packages = import ./pkgs nixpkgs.legacyPackages.x86_64-linux;

      packages."x86_64-linux" = let
        neovimConfigured = (nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [{
            config.vim = import ./nvf.nix {pkgs = pkgs;};
          }];
        });
      in {
        vi = neovimConfigured.neovim;
      } // (import ./pkgs {
        inherit pkgs;
        inherit (inputs) uv2nix pyproject-nix pyproject-build-systems;
      });

      devShells = import ./devshells { 
        pkgs = pkgs; 
        forAllSystems = forAllSystems; 
      };
    };
}
