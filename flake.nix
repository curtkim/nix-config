{
  nixConfig = {
    extra-experimental-features = [ "nix-command" "flakes"];
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
    #hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    hyprland,
    home-manager,
    disko,
    ...
  }: {
    nixosConfigurations.um790 = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = {
        userName = "curt";
	hostName = "um790";
	disko = disko;
        hyprland = hyprland;
        pkgs-unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      	inherit inputs;
      };
      modules = [
        ./host/um790
        home-manager.nixosModules.home-manager
        {
          home-manager.users.curt = import ./user;
          home-manager.extraSpecialArgs = specialArgs;
        }
      ];
    };

    nixosConfigurations.vostro = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        userName = "curt";
	hostName = "vostro";
	disko = disko;
      	inherit inputs;
      };
      modules = [
        ./host/vostro
        home-manager.nixosModules.home-manager
        {
          home-manager.users.curt = import ./user;
        }
      ];
    };

    nixosConfigurations."vostro-console" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        userName = "curt";
	hostName = "vostro";
	disko = disko;
        hyprland = hyprland;
      	inherit inputs;
      };
      modules = [
        ./host/vostro-console
        home-manager.nixosModules.home-manager
        {
          home-manager.users.curt = import ./user;
        }
      ];
    };

    homeConfigurations.curt = let 
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./user
        ./modules/hyprland
      ];
      extraSpecialArgs = {
        userName = "curt";
        username = "curt";
        hyprland = hyprland;
        system = system;
      };
    };

    nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        userName = "curt";
	hostName = "workstation";
	disko = disko;
        hyprland = hyprland;
      	inherit inputs;
      };
      modules = [
        ./host/workstation
        #hyprland.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.users.curt = import ./user;
        }
      ];
    };

    packages = import ./pkgs nixpkgs.legacyPackages.x86_64-linux;

  };
}
