{
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="fee3", ATTR{idProduct}=="0000", MODE="0666"
  '';
}
