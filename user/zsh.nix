{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    autosuggestion = {
      enable = true;
    };
    enableCompletion = true;
    defaultKeymap = "emacs";
    shellAliases = {
      ls = "exa";
      l = "exa -l --time-style iso";
      la = "exa -la";
      ip = "ip --color=auto";
      icat = "kitten icat";
      show_path = "echo $PATH | tr ':' '\n'";

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
      x = "exit";
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
