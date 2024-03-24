{pkgs, ...}:

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
    ];
    extraConfig = ''
      # More Intuitive Split Commands
      bind-key "|" split-window -h -c "#{pane_current_path}"
      bind-key "\\" split-window -fh -c "#{pane_current_path}"
      bind-key "-" split-window -v -c "#{pane_current_path}"
      bind-key "_" split-window -fv -c "#{pane_current_path}"

      # Swapping Windows
      bind -r "<" swap-window -d -t -1
      bind -r ">" swap-window -d -t +1

      # Resizing Pane
      bind -r C-j resize-pane -D 10
      bind -r C-k resize-pane -U 10
      bind -r C-h resize-pane -L 10
      bind -r C-l resize-pane -R 10

      # Copy mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Status bar
      set-option -g status-position top

      # Quick Reload
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      set -g status-left-length 85
      set -g status-left "[#S]"
      set -g status-right "#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,}\"#{=21:pane_title}\" %H:%M %Y-%m-%d"
      set -g status-justify centre
    '';
  };
}
