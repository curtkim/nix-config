{ config, pkgs, lib, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 15;
    };
    settings = {
      scrollback_lines = 3000;
      enable_audio_bell = false;
      linux_display_server = "wayland";
      wayland_enable_ime = true;
    };
    #    settings = {
    #      window_padding_width = "8.0";
    #      wheel_scroll_multiplier = "32.0";
    #      touch_scroll_multiplier = "32.0";
    #      confirm_os_window_close = 0;
    #    };
    keybindings = {
      #"ctrl+c" = "copy_and_clear_or_interrupt";
      #"ctrl+v" = "paste_from_clipboard";
    };
    theme = "Tokyo Night Storm"; #"Catppuccin-Macchiato"; #"Tomorrow Night"; #"Nord";
  };
}
