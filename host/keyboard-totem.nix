{
  users.users.curt.extraGroups = [ "dialout" ];

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", ATTRS{idVendor}=="id50", ATTRS{idProduct}=="615e", GROUP="dialout", MODE="0660"
  '';
}
