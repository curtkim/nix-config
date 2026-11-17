{ config, ... }:
let
  inherit (config.flake) wrappers;
in
{
  flake.wrappers.kitty =
    {
      config,
      wlib,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.kitty ];

      font = {
        # kitty 는 "패밀리 스타일" 을 한 덩어리로 주면 fontconfig 매칭에 실패한다.
        # (실패 시 조용히 monospace = DejaVu Sans Mono 로 떨어져 nerd icon 이 깨짐)
        # family=/style= 로 분리해서 지정한다.
        name = ''family="JetBrainsMonoNL Nerd Font" style="Thin"'';
        size = 13;
      };

      settings = {
        # flake 에 등록된 zsh wrapper (wrapper/zsh.nix)
        shell = "${wrappers.zsh.wrap { inherit pkgs; }}/bin/zsh";
        scrollback_lines = 5000;
        paste_actions = "filter";
        # 기본값은 read-*-ask 라서 OSC 52 클립보드 읽기(tmux, nvim 등)마다
        # "A program running in this window wants to read from system clipboard" 를 묻는다.
        clipboard_control = "write-clipboard write-primary read-clipboard read-primary no-append";
        #cursor_trail = 1;
      };

      keybindings = {
        "ctrl+shift+equal" = "change_font_size all +1.0";
        "ctrl+shift+plus" = "change_font_size all +1.0";
        "ctrl+shift+minus" = "change_font_size all -1.0";
        # bypass to tmux
        "ctrl+shift+h" = "launch --type=background tmux previous-window";
        "ctrl+shift+l" = "launch --type=background tmux next-window";
        # claude code: 줄바꿈만 하고 submit 하지 않기 (Esc + CR)
        "shift+enter" = "send_text all \\x1b\\r";
      };

      # https://github.com/kovidgoyal/kitty-themes/tree/master/themes
      themeFile = "tokyo_night_storm";
    };
}
