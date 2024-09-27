{ config, pkgs, ... }:
{
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    logLevel = "debug"; # $ journalctl --follow --unit=cups
    drivers = [
      pkgs.splix
      pkgs.samsung-unified-linux-driver
      (pkgs.writeTextDir "share/cups/model/Samsung_M2020_Series.ppd" (builtins.readFile ./Samsung_M2020_Series.ppd))
    ];

    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
  };

  #  services.avahi = {
  #    enable = true;
  #    nssmdns4 = true;
  #    openFirewall = true;
  #    publish = {
  #      enable = true;
  #      userServices = true;
  #    };
  #  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "M2020";
        location = "Home";
        deviceUri = "usb://Samsung/M2020%20Series?serial=08HUB8GH3B01QVP";
        model = "Samsung_M2020_Series.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
    ensureDefaultPrinter = "M2020";
  };
}
