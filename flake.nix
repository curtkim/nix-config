{
  inputs = {
    hyprland.url = "github:hyprwm/Hyprland";
    nixpkgs.url = "github:NixOS/nixpkgs/23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    hyprland,
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
        ./nixos/vostro
        home-manager.nixosModules.home-manager
        {
          home-manager.users.curt = import ./home/home.nix;
        }
      ];
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
        ./nixos/workstation
        home-manager.nixosModules.home-manager
        {
          home-manager.users.curt = import ./home/home.nix;
        }
      ];
    };

  };
}
