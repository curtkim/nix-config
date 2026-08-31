{
  pkgs,
  lib,
  wlib,
  ...
}:
let
  # home-manager의 programs.zsh.plugins 대체.
  # zsh wrapper 모듈에는 plugins 옵션이 없으므로 zshrc에서 직접 fpath + source 한다.
  #
  # 순서가 중요하다:
  #   1. fpath 등록 -> compinit  (플러그인이 제공하는 _completion 을 쓰려면 compinit 이전이어야 함)
  #   2. vi-mode    (widget/keybinding 을 갈아엎으므로 먼저)
  #   3. autosuggestions
  #   4. syntax-highlighting (반드시 마지막. 이후에 정의된 widget 은 하이라이팅되지 않음)
  plugins = [
    {
      name = "zsh-vi-mode";
      src = pkgs.zsh-vi-mode;
      file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
    }
    {
      name = "zsh-autosuggestions";
      src = pkgs.zsh-autosuggestions;
      file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
    }
    {
      name = "zsh-syntax-highlighting";
      src = pkgs.zsh-syntax-highlighting;
      file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
    }
  ];

  pluginFpath = lib.concatMapStringsSep "\n" (
    p: ''fpath+=("${p.src}/${builtins.dirOf p.file}")''
  ) plugins;

  # starship wrapper. init 스크립트가 STARSHIP_CONFIG 를 들고 있는 wrapper 를
  # 가리키게 하려면 구체적인 경로가 필요하다. (아래 zshrc 주석 참고)
  starship = wlib.evalPackage [
    { inherit pkgs; }
    ./starship.nix
  ];

  pluginSource = lib.concatMapStringsSep "\n" (p: ''
    # ${p.name}
    source "${p.src}/${p.file}"
  '') plugins;
in
{
  imports = [ wlib.wrapperModules.zsh ];

  # home-manager 없이 이 wrapper 만 써도 alias 들이 동작하도록.
  # suffixVar 라서 사용자 PATH 가 우선한다.
  runtimePkgs = with pkgs; [
    eza
    fzf
    jq
    tree
    git
    lazygit
    zoxide
  ];

  # programs.zsh.shellAliases 와 1:1 대응
  zshAliases = {
    vi = "nvim";
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
    # --- options (autocd) ---------------------------------------------------
    setopt autocd

    # --- history (history.extended = true + home-manager 기본값) -------------
    HISTFILE="$HOME/.zsh_history"
    HISTSIZE=10000
    SAVEHIST=10000
    mkdir -p "$(dirname "$HISTFILE")"

    setopt EXTENDED_HISTORY
    setopt HIST_FCNTL_LOCK
    setopt HIST_IGNORE_DUPS
    setopt HIST_IGNORE_SPACE
    setopt SHARE_HISTORY
    unsetopt HIST_IGNORE_ALL_DUPS
    unsetopt HIST_EXPIRE_DUPS_FIRST

    # --- completion (enableCompletion = true) -------------------------------
    # 플러그인이 제공하는 completion 을 잡으려면 compinit 전에 fpath 를 채운다
    ${pluginFpath}

    autoload -U compinit
    _zcompdir="''${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
    mkdir -p "$_zcompdir"
    compinit -d "$_zcompdir/zcompdump-$ZSH_VERSION"
    unset _zcompdir

    # --- keymap (defaultKeymap = "emacs") -----------------------------------
    # 주의: 아래 zsh-vi-mode 가 초기화되면서 결국 vi 모드가 이긴다.
    #       emacs 키맵만 원하면 plugins 목록에서 zsh-vi-mode 를 빼야 한다.
    bindkey -e

    # --- plugins ------------------------------------------------------------
    ${pluginSource}

    # --- kitty shell integration --------------------------------------------
    # home-manager 의 programs.kitty.shellIntegration.enableZshIntegration(기본 true)가
    # ~/.zshrc 에 넣어주던 것. kitty 밖에서는 KITTY_INSTALLATION_DIR 이 없어서 아무 일도 안 한다.
    # kitty.conf 쪽 절반(shell_integration no-rc)은 wrapper/kitty.nix 에 있다.
    if test -n "$KITTY_INSTALLATION_DIR"; then
      export KITTY_SHELL_INTEGRATION="no-rc"
      autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
      kitty-integration
      unfunction kitty-integration
    fi

    # --- fzf (programs.fzf.enableZshIntegration = true) ---------------------
    source "${pkgs.fzf}/share/fzf/completion.zsh"
    # zsh-vi-mode 가 init 시점에 keybinding 을 되돌리므로
    # fzf key-binding 은 zvm 초기화 이후에 다시 걸어준다 (Ctrl-R, Ctrl-T, Alt-C)
    zvm_after_init_commands+=('source "${pkgs.fzf}/share/fzf/key-bindings.zsh"')

    # --- starship (programs.starship.enableZshIntegration = true) -----------
    # zsh-vi-mode 뒤에 와야 starship 이 기존 zle-keymap-select widget 을 보존한다.
    # starship 은 init 스크립트에 박아넣을 자기 경로를 PATH 에서 찾고,
    # 못 찾으면 wrapping 되지 않은 원본 바이너리로 폴백해서 STARSHIP_CONFIG 를 잃는다.
    # 그래서 init 을 부르는 동안만 PATH 앞에 wrapper 를 붙인다.
    if [[ $TERM != "dumb" ]]; then
      eval "$(PATH="${starship}/bin:$PATH" "${starship}/bin/starship" init zsh)"
    fi
  '';
}
