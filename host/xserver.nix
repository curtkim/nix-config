{ pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = false;
    logFile = "/home/curt/.Xorg.log";

    # Enable the GNOME Desktop Environment.
    displayManager.startx.enable = true;
    #displayManager.lightdm.enable = true;
    #displayManager.startx.generateScript = true;

    windowManager.i3.enable = true;

    excludePackages = [
      pkgs.xterm
    ];

    # Configure keymap in X11
    xkb = {
      layout = "kr";
      variant = "";
    };
  };

  services.desktopManager.gnome.enable = false;
  services.displayManager.gdm.enable = false;

  environment.systemPackages = with pkgs; [
    #gnome-session
  ];

  # home.file.".xinitrc".text = ''
  #   gnome-session
  # '';

}
