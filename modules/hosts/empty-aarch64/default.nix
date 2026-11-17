{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.nixosConfigurations."empty-aarch64" = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      (
        {
          config,
          pkgs,
          ...
        }:

        {
          imports = [
            nixos.boot
            ./_hardware-configuration.nix
          ];

          environment.systemPackages = with pkgs; [
          ];

          system.stateVersion = "25.11"; # Did you read the comment?
          networking.hostName = "empty-aarch64"; # Define your hostname.
        }
      )
    ];
  };
}
