{
  services.udev.extraRules = ''
    ACTION=="add", ATTR{idVendor}=="0403", ATTR{idProduct}=="6010", MODE:="666"
  '';
}
