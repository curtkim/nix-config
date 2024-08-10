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
  }: let
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
    in {
    nixosConfigurations.um790 = nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = specialArgs // { hostName = "um790"; };
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
      system = system;
      specialArgs = specialArgs // { hostName = "vostro"; };
      modules = [
        ./host/vostro
        home-manager.nixosModules.home-manager
        {
          home-manager.users.curt = import ./user;
          home-manager.extraSpecialArgs = specialArgs;
        }
      ];
    };

    nixosConfigurations."vostro-console" = nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = specialArgs // { hostName = "vostro"; };
      modules = [
        ./host/vostro-console
        home-manager.nixosModules.home-manager
        {
          home-manager.users.curt = import ./user;
          home-manager.extraSpecialArgs = specialArgs;
        }
      ];
    };

      #    homeConfigurations.curt = let 
      #      system = "x86_64-linux";
      #      pkgs = nixpkgs.legacyPackages.${system};
      #    in home-manager.lib.homeManagerConfiguration {
      #      inherit pkgs;
        #      modules = [
        #        ./user
      #        ./modules/hyprland
      #      ];
      #      extraSpecialArgs = {
      #        userName = "curt";
      #        username = "curt";
      #        hyprland = hyprland;
      #        system = system;
      #      };
      #    };

    nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = specialArgs // { hostName = "workstation"; };
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

    packages = import ./pkgs nixpkgs.legacyPackages.x86_64-linux;

  };
}
