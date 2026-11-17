{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.self.packages.${pkgs.system}.mango
    inputs.self.packages.${pkgs.system}.kitty
  ];
}
