{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    android-tools
  ];

  # samsung galaxy s26
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", TAG+="uaccess"
  '';
}
