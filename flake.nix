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
      specialArgs = {inherit inputs;};
      modules = [
        disko.nixosModules.disko
        ./nixos/configuration.nix
        ./nixos/disko-config.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.users.curt = import ./home/home.nix;
        }
      ];
    };

#    homeConfigurations = {
#      "curt@vostro" = home-manager.lib.homeManagerConfiguration {
#        pkgs = nixpkgs.legacyPackages.x86_64-linux;
#        extraSpecialArgs = {inherit inputs;};
#        modules = [
#          ./home/home.nix
#        ];
#      };
#    };

  };
}
