{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      #env.TERM = "xterm-256color";
      window.decorations = "none";
      scrolling.history = 3000;
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "ExtraLight";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Light";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        size = 13;
      };
      shell.program = "${pkgs.tmux}/bin/tmux";
    };
  };
}
