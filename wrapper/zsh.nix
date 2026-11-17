{ ... }:
{
  # user/zsh.nix 의 wrapper 버전.
  # zoxide, yazi, starship, lazygit, direnv, fzf, kitty 연동과 hm-session-vars 는 넣지 않는다.
  flake.wrappers.zsh =
    {
      wlib,
      pkgs,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.zsh ];

      # ~/.nix-profile/etc/profile.d/hm-session-vars.sh 를 읽지 않는다.
      hmSessionVariables = null;

      zshAliases = {
        vi = "nvim";
        ls = "eza";
        l = "eza -l --time-style iso";
        la = "eza -la";
        ip = "ip --color=auto";
        icat = "kitten icat";
        show_path = "echo $PATH | tr ':' '\\n'";

        lg = "lazygit";
        gs = "git status -sb";
        ga = "git add";
        gd = "git diff";
        gc = "git commit -m";
        gp = "git pull";
        gP = "git push";
        gl = "git log --oneline --graph --decorate -20";

        #shortcut
        b = "cd ~/brain/ && vi";
        n = "cd ~/nix-config/ && vi";
        v = "cd ~/.config/nvim/ && vi";
        t = "tree";
        x = "exit";
        myip = "curl -s ipinfo.io | jq '.ip'";
        cl = "claude";
        dl = "deepl";
      };

      zshrc.content = ''
        typeset -U path cdpath fpath manpath

        # defaultKeymap = "emacs"
        bindkey -e

        # ZDOTDIR 가 읽기 전용 store 라서 덤프 파일은 캐시 디렉터리에 둔다.
        mkdir -p "''${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
        autoload -U compinit && compinit -d "''${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"

        # autosuggestion
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        ZSH_AUTOSUGGEST_STRATEGY=(history)

        # plugins
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

        # history (HISTFILE 을 지정하지 않으면 저장되지 않는다)
        HISTSIZE="10000"
        SAVEHIST="10000"
        HISTFILE="$HOME/.zsh_history"
        setopt HIST_FCNTL_LOCK EXTENDED_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
        unsetopt APPEND_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS

        setopt autocd
      '';
    };
}
