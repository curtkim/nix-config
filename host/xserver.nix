{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = false;

    # Enable the GNOME Desktop Environment.
    displayManager.startx = false;
    #displayManager.gdm.enable = true;
    #displayManager.gdm.wayland = false;
    desktopManager.gnome.enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "kr";
      variant = "";
    };
  };
}
