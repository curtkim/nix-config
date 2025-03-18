{pkgs, ...}:
{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = false;
    logFile= "/home/curt/.Xorg.log";

    # Enable the GNOME Desktop Environment.
    displayManager.startx.enable = true;
    #displayManager.startx.generateScript = true;

    displayManager.gdm.enable = false;
    #displayManager.gdm.wayland = false;
    desktopManager.gnome.enable = true;

    excludePackages = [
      pkgs.xterm
    ];

    # Configure keymap in X11
    xkb = {
      layout = "kr";
      variant = "";
    };
  };

  environment.systemPackages = with pkgs; [
    gnome.gnome-session
  ];

}
