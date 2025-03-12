{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    sensibleOnTop = false;
    shell = "${pkgs.zsh}/bin/zsh";
    prefix = "C-u";
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    historyLimit = 5000;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      yank
      resurrect           # prefix + Ctrl-s, prefix + Ctrlkr
    ];
    # bind -n     # without prefix 
    # bind -r     # 반복가능
    # bind -T     # 키 테이블 지정
    extraConfig = ''
      bind -n C-] copy-mode

      # Cycle window
      bind -n C-H previous-window
      bind -n C-L next-window

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
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Quick Reload
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"


      # Status bar
      set-option -g status-position top
      set-window-option -g window-status-current-style bg=#00FF00

      set -g status-left-length 85
      set -g status-left "[#S]  "
      set -g status-right "#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,}\"#{=21:pane_title}\" %H:%M %Y-%m-%d"
      set -g status-justify left

      # for kitty graphics protocol
      set -gq allow-passthrough on
      set -g visual-activity off
    '';
  };
}
