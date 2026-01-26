{
  config,
  pkgs,
  disko,
  hostName,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
  ];

  system.stateVersion = "25.11"; # Did you read the comment?
  networking.hostName = hostName; # Define your hostname.
}
