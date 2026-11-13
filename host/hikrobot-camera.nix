{ config, pkgs, inputs, ... }:
{
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="2bdf", MODE="0666"
  '';
  boot.kernelParams = [ "usbcore.usbfs_memory_mb=1000" ];
}
