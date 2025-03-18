{ config, lib, pkgs, pkgs-unstable, inputs, ... }: 

{
  imports = [
    ./default_minimal.nix
    ./vscode.nix
    ./hyprland
    ./hyprlock.nix
    #./google-chrome.nix
  ];

  #nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.permittedInsecurePackages = [
  #  "freeimage-unstable-2021-11-01"
  #];


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
    hashcat

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
  };
}
