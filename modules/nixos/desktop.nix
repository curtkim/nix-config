{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.modules.nixos.desktop =
    { config, pkgs, ... }:
    {
      imports = [
        nixos.network
        nixos.helium-browser
        nixos.kime
        nixos.mime-apps
        nixos.sdcv
        nixos.ui-theme
      ];

      environment.systemPackages = [
        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.mango
        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.kitty

        pkgs.claude-code
      ];
    };
}
