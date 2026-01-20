{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    #dotDir = "`\${config.xdg.configHome}/zsh`";
    autosuggestion = {
      enable = true;
    };
    enableCompletion = true;
    defaultKeymap = "emacs";
    shellAliases = {
      ls = "eza";
      l = "eza -l --time-style iso";
      la = "eza -la";
      ip = "ip --color=auto";
      icat = "kitten icat";
      show_path = "echo $PATH | tr ':' '\n'";

      lg = "lazygit";
      gs = "git status -sb";
      ga = "git add";
      gd = "git diff";
      gc = "git commit -m";
      gp = "git pull";
      gP = "git push";
      gl = "git log --oneline --graph --decorate -20";

      #shortcut
      b = "cd ~/brain/ && vi .";
      n = "cd ~/nix-config/ && vi .";
      v = "cd ~/.config/nvim/ && vi .";
      t = "tree";
      x = "exit";
      myip = "curl -s ipinfo.io | jq '.ip'";
      cl = "claude";
      dl = "deepl";
      emby = ''
        podman run --replace \
          --name embyserver \
          --volume /home/curt/emby/config:/config \
          --volume /data/video:/media \
          --net=host \
          --publish 8096:8096 \
          --publish 8920:8920 \
          --env UID=1000 \
          --env GID=100 \
          --env GIDLIST=100 \
          --restart on-failure \
          emby/embyserver:latest
      '';
    };

    #    initExtra = ''
    #      bindkey '^ ' autosuggest-accept
    #      AGKOZAK_CMD_EXEC_TIME=5
    #      AGKOZAK_COLORS_CMD_EXEC_TIME='yellow'
    #      AGKOZAK_COLORS_PROMPT_CHAR='magenta'
    #      AGKOZAK_CUSTOM_SYMBOLS=( '⇣⇡' '⇣' '⇡' '+' 'x' '!' '>' '?' )
    #      AGKOZAK_MULTILINE=0
    #      AGKOZAK_PROMPT_CHAR=( ❯ ❯ ❮ )
    #      eval $(thefuck --alias)
    #      autopair-init
    #                              '';

    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "zsh-syntax-highlighting.zsh";
      }
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Scripts
  #home.file.".config/zsh/scripts".source = ./files/scripts;
  #home.file.".config/zsh/scripts".recursive = true;
}
