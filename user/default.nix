{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./default_minimal.nix
    ./ui-theme.nix
    ./xdg-mimeApps.nix

    ./kitty.nix
    ./firefox.nix

    ./hyprland
    ./hyprlock.nix

    ./i3.nix
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30";
  };


  home.packages = with pkgs; [

    # device
    alsa-utils

    # multimedia
    mpv
    fuse
    termusic
    yt-dlp
    soco-cli
    youtube-tui

    #qgis
    #blender
    vulkan-tools
    mesa-demos
    epr
    chrpath
    #hashcat

    xclip
    wl-clipboard
    grim
    slurp
    imv # image viewer

    #firefox
    #vivaldi
    #floorp
    w3m
    (google-chrome.override {
      commandLineArgs = [
        #"--ozone-platform=wayland"
        "--enable-wayland-ime"
        "--enable-unsafe-webgpu"
        "--enable-webgpu-developer-feature"
        "--force-webgpu-compat"
      ];
    })

    # gnome
    gnome-session

    #obsidian
    #(ollama.override { acceleration = "cuda"; })
    #(openai-whisper-cpp.override { cudaSupport = true;})

    inkscape
    sioyek

    # audio
    pamixer

    # joy
    cmatrix

    # for windows
    spice-gtk

    inputs.yt-x.packages."${system}".default
  ];

  # gnome을 사용할때 사용하는 setting
  dconf.settings = {
    "org/gnome/desktop/peripherals/keyboard" = {
      repeat-interval = 30;
      delay = 250;
    };
    #    "org/gnome/desktop/peripherals/mouse" = {
    #      accel-profile = "flat";
    #      speed = -0.17;
    #    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "terminate:ctrl_alt_bksp" ]; # "caps:swapescape"
    };
    "org/gnome/desktop/wm/keybindings" = {
      move-to-monitor-left = [ "<shift><super>h" ];
      move-to-monitor-right = [ "<shift><super>l" ];
      move-to-workspace-1 = [ "<shift><super>1" ];
      move-to-workspace-2 = [ "<shift><super>2" ];
      move-to-workspace-3 = [ "<shift><super>3" ];
      move-to-workspace-4 = [ "<shift><super>4" ];
      move-to-workspace-5 = [ "<shift><super>5" ];
      close = [ "<super>q" ];
      toggle-fullscreen = [ "<super>f" ];
    };
  };

}
