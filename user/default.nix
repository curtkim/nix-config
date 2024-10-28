{ config, lib, pkgs, pkgs-unstable,  ... }: 

{
  imports = [
    ./default_minimal.nix

    ./kitty.nix
    #./alacritty.nix
    #./hypr
    ./hyprland.nix
    ./hyprlock.nix
    #./chromium.nix
    ./google-chrome.nix
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

    firefox
    #google-chrome

    # gnome
    gnome.gnome-session

    obsidian
    #(ollama.override { acceleration = "cuda"; })
    #(openai-whisper-cpp.override { cudaSupport = true;})

    inkscape

    # audio
    pamixer


    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ] ++ lib.optionals pkgs.config.cudaSupport [
    #opensplatWithCuda
    #pkgs-unstable.colmapWithCuda
    #(pkgs.blender.override {
    #cudaSupport = true;
    #})
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "google-chrome.desktop";
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
    size = 64;
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
