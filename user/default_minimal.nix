{ config, lib, pkgs, pkgs-unstable,  ... }: 

{
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./starship.nix
    ./zoxide.nix
    ./nvim.nix
    ./git.nix

    ./kitty.nix
    ./ssh.nix
    ./yazi.nix
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
    #EDITOR = "${lib.getExe pkgs.neovim}";
    #BROWSER = "${lib.getExe pkgs-unstable.google-chrome }";
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  fonts.fontconfig.enable = true;


  home.packages = with pkgs; [

    # font
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Hack" ]; })

    gnumake
    file

    neofetch
    #buildah
    #skopeo
    virt-manager
    quickemu

    #util
    lazygit
    serie       # A rich git commit graph in your terminal
    bat
    fzf
    ripgrep     
    ripgrep-all
    repgrep     # Interactive replacer
    jq
    tree
    eza
    fd          # alternative to find
    tokei
    erdtree     # File-tree visualizer and disk usage analyzer
    du-dust
    glow
    unzip
    unixtools.xxd   # 16진수
    #litecli    # cli for SQLite
    tldr
    fx            # json viewer

    # network
    #speedtest-cli
    #iperf3
    #nmap

    # for printing
    enscript

    #nethogs
    hwinfo
    htop
    btop
    gtop
    #cpufrequtils
    nvtopPackages.nvidia
    zenith-nvidia
    pstree

    nix-search-cli
    #cachix
    nix-init
    nix-diff
    nix-tree
    nix-visualize
    nix-index
    nixpkgs-fmt

    cargo
    rust-analyzer
    nodejs_22
    yarn

    #python311
    #python3Packages.debugpy
    #python3Packages.isort
    #python3Packages.pipdeptree

    #sops
    age
    age-plugin-yubikey
    yubikey-manager
    passage

    gh
    gh-find-code

    # for neovim
    markdownlint-cli
    stylua

    # lsp
    nil
    pyright
    lua-language-server
    bash-language-server

    # dap
    gdb

    # cloud
    google-cloud-sdk
    rclone

    # AI
    pkgs-unstable.aider-chat
    pkgs-unstable.claude-code
    code2prompt
    aichat
    ra-aid

  ] ++ [
    (pkgs-unstable.python3.withPackages (ps: [
      ps.llm
      ps.llm-ollama
    ]))
  ];
}
