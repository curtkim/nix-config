{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.modules.nixos.desktop =
    { config, pkgs, ... }:
    {
      imports = [
        nixos.helium
        nixos.input-method
        nixos.mime-apps
      ];

      environment.systemPackages = [
        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.mango
        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.kitty

        pkgs.claude-code
      ];
    };
}
