{
  nixConfig = {
    # current flake에 적용된다.
    extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://graham33.cachix.org"
      "https://hyprland.cachix.org"
      "http://192.168.0.198:5000"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "graham33.cachix.org-1:DqH72VpwSrACa3+L9eqh4bixjWx9IQUaxQtRh4gtkX8="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "192.168.0.198:xAxl3IZFQCZKbaEfNm/HljvQvm+Q14HSIHcdeMccy6g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #hyprlock.url = "github:hyprwm/Hyprlock";
    #hyprlock.inputs.nixpkgs.follows = "nixpkgs-unstable";
    #hyprland.url = "github:hyprwm/Hyprland";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #nur.url = "github:nix-community/NUR";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jetpack-nixos.url = "github:anduril/jetpack-nixos";
    yt-x = {
      url = "github:Benexl/yt-x";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dgx-spark.url = "github:graham33/nixos-dgx-spark";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      hyprland,
      home-manager,
      disko,
      rust-overlay,
      nvf,
      jetpack-nixos,
      yt-x,
      dgx-spark,
      ...
    }:
    let
      system = "x86_64-linux";
      overlays = [
        (import rust-overlay)
        (
          final: prev:
          import ./pkgs { pkgs = prev; }
        )
        inputs.firefox-addons.overlays.default
      ];
      cudaPkgsConfig = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
        cudaSupport = true;
        cudaCapabilities = [ "8.6" ];
      };
      xavierCudaPkgsConfig = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
        cudaSupport = true;
        cudaCapabiligies = [ "7.2" ];
      };
      commonPkgsConfig = {
        allowUnfreePredicate =
          pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "immersive-translate"
            "samsung-unified-linux-driver"
            "amp-cli"
            "google-chrome"
          ];
        permittedInsecurePackages = [
          "freeimage-unstable-2021-11-01"
          "immersive-translate-1.26.5"
        ];
      };
      pkgs = import nixpkgs {
        system = system;
        config = commonPkgsConfig; # // cudaPkgsConfig;
        overlays = overlays;
      };
      pkgs-unstable = import nixpkgs-unstable {
        system = system;
        config = commonPkgsConfig // cudaPkgsConfig;
        overlays = [ ];
      };
      specialArgs = {
        hostName = "none";
        userName = "curt";
        nixpkgs = nixpkgs;
        disko = disko;
        hyprland = hyprland;
        jetpack-nixos = jetpack-nixos;
        pkgs-unstable = pkgs-unstable;
        yt-x = yt-x;
        inherit inputs;
      };


    in
    {
      nixosConfigurations.um790 = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = specialArgs // {
          hostName = "um790";
        };
        modules = [
          {
            nixpkgs.config = commonPkgsConfig; # // cudaPkgsConfig;
            nixpkgs.overlays = overlays;
          }
          ./host/um790
          #          home-manager.nixosModules.home-manager
          #          {
          #            home-manager.users.curt = import ./user;
          #            home-manager.extraSpecialArgs = specialArgs;
          #          }
        ];
      };

      nixosConfigurations.max1 = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = specialArgs // {
          hostName = "max1";
        };
        modules = [
          ./host/max1
        ];
      };

      nixosConfigurations.spark1 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = specialArgs // {
          hostName = "spark1";
        };
        modules = [
          dgx-spark.nixosModules.dgx-spark
          ./host/spark1
        ];
      };

      nixosConfigurations.roter = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = specialArgs // {
          hostName = "roter";
        };
        modules = [
          ./host/roter
        ];
      };

      nixosConfigurations.gen53 = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = specialArgs // {
          hostName = "gen53";
        };
        modules = [
          ./host/gen53
        ];
      };

      nixosConfigurations.vostro = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = specialArgs // {
          hostName = "vostro";
        };
        modules = [
          ./host/vostro
        ];
      };

      nixosConfigurations."vostro-console" = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = specialArgs // {
          hostName = "vostro";
        };
        modules = [
          ./host/vostro-console
        ];
      };

      nixosConfigurations.black = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = specialArgs // {
          hostName = "black";
          cudaSupport = true;
        };
        modules = [
          {
            nixpkgs.config = commonPkgsConfig // cudaPkgsConfig;
            nixpkgs.overlays = overlays;
          }
          ./host/black
        ];
      };

      nixosConfigurations.xavier = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = specialArgs // {
          hostName = "xavier";
        };
        modules = [
          {
            nixpkgs.config = xavierCudaPkgsConfig;
            nixpkgs.overlays = [
              jetpack-nixos.overlays.default
            ];
          }
          ./host/xavier
        ];
      };

      # x86_64에서 크로스 컴파일용 설정
      nixosConfigurations.xavier-cross = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = specialArgs // {
          hostName = "xavier";
        };
        modules = [
          {
            nixpkgs.buildPlatform = "x86_64-linux";
            nixpkgs.hostPlatform = "aarch64-linux";
            nixpkgs.config = xavierCudaPkgsConfig;
            nixpkgs.overlays = [
              jetpack-nixos.overlays.default
            ];
          }
          ./host/xavier
        ];
      };

      nixosConfigurations.empty-aarch64 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = specialArgs // {
          hostName = "empty-aarch64";
        };
        modules = [
          ./host/empty-aarch64
        ];
      };

      nixosConfigurations.silver = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = specialArgs // {
          hostName = "silver";
        };
        modules = [
          ./host/silver
        ];
      };

      # for silver iso
      nixosConfigurations.silver-installer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ./host/silver/broadcom-wifi.nix
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
          ./user/default-minimal.nix
        ];
      };

      packages."x86_64-linux" =
        let
          neovimConfigured = nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [
              {
                config.vim = import ./nvf.nix { pkgs = pkgs; };
              }
            ];
          };
        in
        {
          vi = neovimConfigured.neovim;
        }
        // (import ./pkgs { inherit pkgs; });
    };
}
