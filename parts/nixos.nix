{ inputs, ... }:
let
  shared = import ./shared.nix { inherit inputs; };
  inherit (shared) overlays commonPkgsConfig cudaPkgsConfig xavierCudaPkgsConfig specialArgs;
  inherit (inputs) nixpkgs nix-amd-ai dgx-spark jetpack-nixos;
in
{
  flake.nixosConfigurations = {
    um790 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = specialArgs // {
        hostName = "um790";
      };
      modules = [
        {
          nixpkgs.config = commonPkgsConfig;
          nixpkgs.overlays = overlays;
        }
        ../host/um790
      ];
    };

    max1 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = specialArgs // {
        hostName = "max1";
      };
      modules = [
        nix-amd-ai.nixosModules.default
        {
          hardware.amd-npu = {
            enable = true;
            enableNPU = true;
            enableFastFlowLM = true;
            enableLemonade = false;
            enableROCm = true;
            enableVulkan = true;
            enableImageGen = false;
            lemonade.user = "curt";
          };

          users.users.curt.extraGroups = ["video" "render"];
        }
        ../host/max1
      ];
    };

    spark1 = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = specialArgs // {
        hostName = "spark1";
      };
      modules = [
        dgx-spark.nixosModules.dgx-spark
        ../host/spark1
      ];
    };

    roter = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = specialArgs // {
        hostName = "roter";
      };
      modules = [
        ../host/roter
      ];
    };

    gen53 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = specialArgs // {
        hostName = "gen53";
      };
      modules = [
        ../host/gen53
      ];
    };

    vostro = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = specialArgs // {
        hostName = "vostro";
      };
      modules = [
        ../host/vostro
      ];
    };

    "vostro-console" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = specialArgs // {
        hostName = "vostro";
      };
      modules = [
        ../host/vostro-console
      ];
    };

    black = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = specialArgs // {
        hostName = "black";
        cudaSupport = true;
      };
      modules = [
        {
          nixpkgs.config = commonPkgsConfig // cudaPkgsConfig;
          nixpkgs.overlays = overlays;
        }
        ../host/black
      ];
    };

    xavier = nixpkgs.lib.nixosSystem {
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
        ../host/xavier
      ];
    };

    xavier-cross = nixpkgs.lib.nixosSystem {
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
        ../host/xavier
      ];
    };

    empty-aarch64 = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = specialArgs // {
        hostName = "empty-aarch64";
      };
      modules = [
        ../host/empty-aarch64
      ];
    };

    silver = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = specialArgs // {
        hostName = "silver";
      };
      modules = [
        ../host/silver
      ];
    };

    silver-installer = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ../host/silver/broadcom-wifi.nix
      ];
    };
  };
}
