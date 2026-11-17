{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.12.69"
  ];
  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ pkgs.linuxPackages.broadcom_sta ];
  boot.blacklistedKernelModules = [
    "b43"
    "bcma"
    "ssb"
    "brcmsmac"
  ];
}
