{pkgs, ...}:

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
      sl = "exa";
      ls = "exa";
      l = "exa -l";
      la = "exa -la";
      ip = "ip --color=auto";
      nix-search = "nix-search-cli";
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

    plugins = with pkgs; [
      {
        name = "zsh-syntax-highlighting";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.6.0";
          sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
        };
        file = "zsh-syntax-highlighting.zsh";
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
