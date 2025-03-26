{ config, lib, pkgs, pkgs-unstable, inputs, ... }: 

{
  imports = [
    ./default_minimal.nix
    ./ui-theme.nix
    ./mimeApps.nix
    ./vscode.nix
    ./hyprland
    ./hyprlock.nix
  ];


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [

    # device
    alsa-utils

    # multimedia
    mpv
    fuse
    termusic
    yt-dlp
    soco-cli
    #youtube-tui

    #qgis
    #blender
    vulkan-tools
    glxinfo
    epr
    chrpath
    #hashcat

    xclip
    wl-clipboard
    grim
    slurp
    imv     # image viewer

    #firefox
    floorp
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

    # audio
    pamixer

    # joy
    cmatrix

    # for windows
    spice-gtk

    inputs.claude-desktop.packages.${system}.claude-desktop-with-fhs
    #    (inputs.claude-desktop.packages.${system}.claude-desktop.overrideAttrs (oldAttrs: {
    #      installPhase = oldAttrs.installPhase + ''
    #      rm $out/bin/$pname
    #      makeWrapper ${pkgs.electron}/bin/electron $out/bin/$pname \
    #        --add-flags "$out/lib/$pname/app.asar" \
    #        --add-flags "--openDevTools" \
    #        --add-flags "--enable-wayland-ime" \
    #        --add-flags "--ozone-platform=wayland" \
    #        --add-flags "--enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer"
    #    '';
    #    }))
  ];

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

  home.file.".xinitrc".text = ''
    gnome-session
  '';

}
