{
  nixConfig = {
    extra-experimental-features = [ "nix-command" "flakes"];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    hyprland,
    hyprlock,
    hyprpicker,
    home-manager,
    disko,
    ...
  }: {
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
        hyprlock = hyprlock;
        hyprpicker = hyprpicker;
        system = system;
      };
    };

    nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        userName = "curt";
	hostName = "workstation";
	disko = disko;
      	inherit inputs;
      };
      modules = [
        ./host/workstation
        home-manager.nixosModules.home-manager
        {
          home-manager.users.curt = import ./user;
        }
      ];
    };

    packages = import ./pkgs nixpkgs.legacyPackages.x86_64-linux;

  };
}
