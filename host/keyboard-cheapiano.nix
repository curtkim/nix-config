{
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="fee3", ATTRS{idProduct}=="0000", MODE="0666"
  '';
}
