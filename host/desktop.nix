{ config, pkgs, inputs, ... }:
{
  imports = [
    ./helium.nix
    ./input-method.nix
  ];

  environment.systemPackages = [
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.mango
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.kitty
  ];
}
