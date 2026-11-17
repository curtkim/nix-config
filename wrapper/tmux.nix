{ ... }:
{
  # user/tmux.nix 의 wrapper 버전.
  flake.wrappers.tmux =
    {
      config,
      wlib,
      pkgs,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.tmux ];

      sourceSensible = false;
      terminal = "tmux-256color";
      # default-shell 은 지정하지 않는다. tmux 는 $SHELL 을 쓰고, wrapper zsh 가
      # SHELL 을 자기 자신으로 export 한다. (zsh → tmux → zsh 순환 참조를 피하기 위함)
      prefix = "C-u";
      baseIndex = 1;
      paneBaseIndex = 1;
      escapeTime = 0;
      statusKeys = "vi";
      modeKeys = "vi";
      mouse = true;
      historyLimit = 5000;
      clock24 = false;

      # home-manager 에는 없던 wrapper 기본값들을 끈다.
      updateEnvironment = [ ];
      disableConfirmationPrompt = false;

      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        #yank
        resurrect # prefix + Ctrl+s, prefix + Ctrl+r
      ];

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
        bind -T copy-mode-vi 'C-v' send-keys -X rectangle-toggle \; send-keys -X begin-selection
        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        # Quick Reload (설정이 store 에 있으므로 이 빌드의 설정을 다시 읽는다)
        bind r source-file ${config.constructFiles.generatedConfig.path} \; display "Reloaded!"

        # yank to clipboard
        set -g set-clipboard on

        # Status bar
        set-option -g status-position top
        set-window-option -g window-status-current-style bg=#00FF00

        set -g status-left-length 85
        set -g status-left "[#S]  "
        set -g status-right "#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,}\"#{=21:pane_title}\" %H:%M %Y-%m-%d"
        set -g status-justify left

        # for kitty graphics protocol
        set -g allow-passthrough on
        set -g visual-activity off

        # for claude code Shift+Enter
        set -g allow-passthrough on
        set -s extended-keys on
        set -as terminal-features 'xterm*:extkeys'

        # for claude code focus-tracking
        set -g focus-events on
      '';
    };
}
