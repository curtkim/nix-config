{
  config,
  pkgs,
  lib,
  wlib,
  ...
}:

{
  imports = [ wlib.wrapperModules.tmux ];

  # home-manager 의 programs.tmux 와 옵션이 거의 1:1 이지만
  # 기본값이 다른 것들이 있어서 명시적으로 적어둔다 (아래 주석 참고)

  sourceSensible = false; # HM: sensibleOnTop = false
  secureSocket = true; # HM 기본값(linux) = true. TMUX_TMPDIR 를 /run/user/$UID 로

  # HM 에서 관리하던 ~/.zshrc 를 쓰는 일반 zsh.
  # zsh 도 wrapper 로 옮기고 나면 아래 줄로 바꾼다:
  #   shell = lib.getExe' (wlib.evalPackage [ { inherit pkgs; } ./zsh.nix ]) "zsh";
  shell = "${pkgs.zsh}/bin/zsh";

  prefix = "C-u";
  baseIndex = 1;
  paneBaseIndex = 1; # HM 은 baseIndex 하나로 둘 다 설정한다
  escapeTime = 0;
  mouse = true;
  historyLimit = 5000;

  # HM: keyMode = "vi" 는 status-keys 와 mode-keys 를 함께 설정한다
  statusKeys = "vi";
  modeKeys = "vi";

  # 아래 두 개는 wrapper 기본값이 HM 기본값과 달라서 명시 (동작 유지용)
  clock24 = false; # wrapper 기본 true / HM 기본 false
  disableConfirmationPrompt = false; # wrapper 기본 true / HM 기본 false

  # extraConfig 에 있던 set 들을 옵션으로 승격
  allowPassthrough = true; # set -gq allow-passthrough on (kitty graphics protocol)
  visualActivity = false; # set -g visual-activity off
  vimVisualKeys = true; # copy-mode-vi 의 v / y 바인딩

  # HM 의 plugins 와 동일. 패키지를 그대로 넣으면 { plugin = ...; } 로 정규화된다.
  # 세밀한 제어가 필요하면 { plugin = ...; configBefore = ""; configAfter = ""; before/after = [ ]; } 형태로.
  plugins = with pkgs.tmuxPlugins; [
    vim-tmux-navigator
    yank
    resurrect # prefix + Ctrl+s, prefix + Ctrl+r
  ];

  # HM 의 extraConfig 는 플러그인 이후에 붙으므로 configAfter 에 해당한다
  # bind -n     # without prefix
  # bind -r     # 반복가능
  # bind -T     # 키 테이블 지정
  configAfter = ''
    # without prefix '-n'
    bind -n C-] copy-mode

    # Cycle window(by kitty)
    #bind -n S-C-H previous-window
    #bind -n S-C-L next-window

    # More Intuitive Split Commands
    bind "|" split-window -h -c "#{pane_current_path}"
    bind "\\" split-window -fh -c "#{pane_current_path}"
    bind "-" split-window -v -c "#{pane_current_path}"
    bind "_" split-window -fv -c "#{pane_current_path}"

    # Swapping Windows
    bind -r "<" swap-window -d -t -1
    bind -r ">" swap-window -d -t +1

    # Resizing Pane
    bind -r C-j resize-pane -D 10
    bind -r C-k resize-pane -U 10
    bind -r C-h resize-pane -L 10
    bind -r C-l resize-pane -R 10

    # Copy mode
    # v / y 는 vimVisualKeys 옵션이 대신한다
    bind -T copy-mode-vi 'C-v' send-keys -X rectangle-toggle \; send-keys -X begin-selection

    # Quick Reload
    # 설정 파일은 이제 nix store 안에 있고 -f 로 전달되므로 그 경로를 다시 읽는다
    bind r source-file ${config.constructFiles.generatedConfig.path} \; display "Reloaded!"


    # Status bar
    set-option -g status-position top
    set-window-option -g window-status-current-style bg=#00FF00

    set -g status-left-length 85
    set -g status-left "[#S]  "
    set -g status-right "#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,}\"#{=21:pane_title}\" %H:%M %Y-%m-%d"
    set -g status-justify left
  '';
}
