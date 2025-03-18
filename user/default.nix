{ config, lib, pkgs, pkgs-unstable, inputs, ... }: 

{
  imports = [
    ./default_minimal.nix
    ./vscode.nix
    ./hyprland
    ./hyprlock.nix
    ./dconf.nix
    #./google-chrome.nix
  ];


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # desktop
    #multimedia
    mpv
    fuse
    termusic
    alsa-utils
    youtube-tui
    yt-dlp
    soco-cli

    #qgis
    #blender
    vulkan-tools
    glxinfo
    epr
    chrpath
    #hashcat

    xclip
    wl-clipboard
    #hyprshot #jq error
    grim
    slurp
    imv     # image viewer

    firefox
    (google-chrome.override {
      commandLineArgs = [
        #"--ozone-platform=wayland"
        "--enable-wayland-ime"
        "--enable-unsafe-webgpu"
        "--enable-webgpu-developer-feature"
        "--force-webgpu-compat"
      ];
    })
    inputs.zen-browser.packages.${pkgs.system}.default

    # gnome
    gnome-session

    obsidian
    #(ollama.override { acceleration = "cuda"; })
    #(openai-whisper-cpp.override { cudaSupport = true;})

    inkscape

    # audio
    pamixer

    # joy
    cmatrix

    # for windows
    spice-gtk
    uv
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "google-chrome.desktop";
      "image/png" = "imv.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 32;
  };

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
      move-to-monitor-left = [ "<shift><super>left" ];
      move-to-monitor-right = [ "<shift><super>right" ];
      move-to-workspace-1 = [ "<shift><super>1" ];
      move-to-workspace-2 = [ "<shift><super>2" ];
      move-to-workspace-3 = [ "<shift><super>3" ];
      move-to-workspace-4 = [ "<shift><super>4" ];
      move-to-workspace-5 = [ "<shift><super>5" ];
      close = [ "<super>q" ];
      toggle-fullscreen = [ "<super>f" ];
    };
  };

  home.file.".xinitrc".text = ''
    gnome-session
  '';

}
