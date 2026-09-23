{ config, pkgs, lib, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      # kitty 는 "패밀리 스타일" 을 한 덩어리로 주면 fontconfig 매칭에 실패한다.
      # (실패 시 조용히 monospace = DejaVu Sans Mono 로 떨어져 nerd icon 이 깨짐)
      # family=/style= 로 분리해서 지정한다.
      name = ''family="JetBrainsMonoNL Nerd Font" style="Thin"'';
      #name = "JetBrainsMonoNL NFM Regular";
      #name = "JetBrainsMonoNL NFM ExtraLight";
      #name = "JetBrainsMonoNL NFM Thin";
      size = 13;
    };

    settings = {
      scrollback_lines = 5000;
      paste_actions = "filter";
      #cursor_trail = 1;
    };
    #    settings = {
    #      scrollback_lines = 3000;
    #      enable_audio_bell = false;
    #      linux_display_server = "wayland";
    #      wayland_enable_ime = true;
    #    };

    #    settings = {
    #      window_padding_width = "8.0";
    #      wheel_scroll_multiplier = "32.0";
    #      touch_scroll_multiplier = "32.0";
    #      confirm_os_window_close = 0;
    #    };
    keybindings = {
      #"ctrl+c" = "copy_and_clear_or_interrupt";
      #"ctrl+v" = "paste_from_clipboard";
      "ctrl+shift+equal" = "change_font_size all +1.0";
      "ctrl+shift+plus"  = "change_font_size all +1.0";
      "ctrl+shift+minus" = "change_font_size all -1.0";
      # bypass to tmux
      "ctrl+shift+h" = "launch --type=background tmux previous-window";
      "ctrl+shift+l" = "launch --type=background tmux next-window";
      # claude code: 줄바꿈만 하고 submit 하지 않기 (Esc + CR)
      "shift+enter" = "send_text all \\x1b\\r";
    };
    # https://github.com/kovidgoyal/kitty-themes/tree/master/themes
    themeFile = "tokyo_night_storm"; #"Catppuccin-Macchiato"; #"Tomorrow Night"; #"Nord";
  };
}
