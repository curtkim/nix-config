{
  nixConfig = {
    # current flake에 적용된다.
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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
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
    , rust-overlay
    , nvf
    , ...
    }:
    let
      system = "x86_64-linux";
      rustVersion = "1.81.0";
      overlays = [
        (import rust-overlay)
        (final: prev: {
          kime = prev.kime.override { 
            rustc = final.rust-bin.stable.${rustVersion}.default;
            cargo = final.rust-bin.stable.${rustVersion}.default;
          };
        })
        (final: prev: 
          import ./pkgs prev
        )
      ];
      pkgsConfig = {
        allowUnfree = true;
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
        overlays = [
          #          (final: prev: {
          #            llama-cpp = prev.llama-cpp.overrideAttrs (old:{
          #              version = "4526";
          #              src = prev.fetchFromGitHub {
          #                owner = "ggerganov";
          #                repo = "llama.cpp";
          #                tag = "b4524";
          #                hash = "sha256-mB4jBNiTFVmwVU/qgo+AYe+jdHzuDCXlERdN+D+opuo=";
          #                leaveDotGit = true;
          #                postFetch = ''
          #                  git -C "$out" rev-parse --short HEAD > $out/COMMIT
          #                  find "$out" -name .git -print0 | xargs -0 rm -rf
          #                '';
          #              };
          #              buildInputs = old.buildInputs ++ [ prev.curl ];
          #              cmakeFlags = old.cmakeFlags ++ [
          #                (prev.lib.cmakeBool "LLAMA_CURL" true)
          #              ];
          #            });
          #          })

          (final: prev: {
            pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
              (
                python-final: python-prev: {
                  litellm = python-prev.litellm.overridePythonAttrs (oldAttrs: rec {
                    version = "1.59.3";
                    src = prev.fetchFromGitHub {
                      owner = "BerriAI";
                      repo = "litellm";
                      tag = "v${version}";
                      hash = "sha256-Qd8ToGVydRHncQPODH8Go8cc9bapoPZL7DLQjOjzq84=";
                    };
                  });
                }
              )
            ];
          })
        ];
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

      nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
        system = system;
        pkgs = pkgs;
        specialArgs = specialArgs // { hostName = "workstation"; cudaSupport = true; };
        modules = [
          ./host/workstation
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
      } // (import ./pkgs pkgs);

      devShells = import ./devshells { 
        pkgs = pkgs; 
        forAllSystems = forAllSystems; 
      };
    };
}
