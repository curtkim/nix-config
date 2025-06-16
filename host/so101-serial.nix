{
  services.udev.extraRules = ''
ACTION=="add", SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="55d3", ATTRS{serial}=="5A46082021", SYMLINK+="ttyACM_follower", MODE="0666"
ACTION=="add", SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="55d3", ATTRS{serial}=="5A46081661", SYMLINK+="ttyACM_leader", MODE="0666"
'';
}
