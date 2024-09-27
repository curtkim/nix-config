{ config, pkgs, pkgs-unstable, cudaSupport, ... }:

{
  imports = [
    ./kitty.nix
    #./alacritty.nix
    ./zsh.nix
    ./tmux.nix
    ./starship.nix
    ./zoxide.nix
    ./nvim.nix
    ./git.nix
    #./hypr
    ./hyprland.nix
    #./chromium.nix
    ./google-chrome.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-unstable-2021-11-01"
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "curt";
  home.homeDirectory = "/home/curt";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    gnumake

    neofetch
    #podman
    #podman-compose
    buildah
    skopeo
    virt-manager
    quickemu

    yazi
    bat
    fzf
    ripgrep
    ripgrep-all
    jq
    tree
    eza
    fd
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Hack" ]; })
    tokei
    erdtree
    du-dust
    nodejs_20
    yarn
    nix-search-cli
    glow
    unzip
    unixtools.xxd

    # for printing
    enscript

    nethogs
    hwinfo
    htop
    gtop
    cpufrequtils
    nvtopPackages.nvidia
    zenith-nvidia

    mpv
    fuse
    termusic
    alsa-utils
    youtube-tui
    yt-dlp

    #qgis
    tldr
    nix-init
    cachix

    cargo
    nixpkgs-fmt

    #blender
    vulkan-tools
    glxinfo
    epr
    chrpath
    hashcat

    xclip
    wl-clipboard
    hyprshot

    python311
    python311Packages.debugpy
    python311Packages.isort
    python311Packages.pipdeptree

    sops
    age

    gh
    pstree

    # desktop
    firefox
    #google-chrome

    # gnome
    gnome.gnome-session

    obsidian
    #(ollama.override { acceleration = "cuda"; })
    #(openai-whisper-cpp.override { cudaSupport = true;})

    # for neovim
    markdownlint-cli
    stylua

    # lsp
    nil
    lua-language-server
    pyright

    # dap
    gdb

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
  ] ++ lib.optional cudaSupport [
    opensplatWithCuda
    pkgs-unstable.colmapWithCuda
    (blender.override {
      cudaSupport = true;
    })
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/curt/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 64;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  fonts.fontconfig.enable = true;

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
