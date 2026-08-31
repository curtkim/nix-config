{
  pkgs,
  lib,
  wlib,
  ...
}:

{
  imports = [ wlib.wrapperModules.kitty ];

  # 옵션 이름은 home-manager 의 programs.kitty 와 그대로 대응된다.
  # (settings / themeFile / font / keybindings / mouseBindings / actionAliases /
  #  environment / extraConfig)

  font = {
    name = "JetBrainsMonoNL Nerd Font Thin";
    #name = "JetBrainsMonoNL NFM Regular";
    #name = "JetBrainsMonoNL NFM ExtraLight";
    #name = "JetBrainsMonoNL NFM Thin";
    size = 13;
  };

  settings = {
    scrollback_lines = 5000;
    paste_actions = "filter";
    #cursor_trail = 1;

    # HM 의 programs.kitty.shellIntegration.mode 기본값이 "no-rc" 라서
    # 여기서 직접 넣어준다. wrapper 모듈에는 shellIntegration 옵션이 없다.
    # 셸 쪽 절반은 wrapper/zsh.nix 에 있다.
    shell_integration = "no-rc";
  };

  keybindings = {
    #"ctrl+c" = "copy_and_clear_or_interrupt";
    #"ctrl+v" = "paste_from_clipboard";
    "ctrl+shift+equal" = "change_font_size all +1.0";
    "ctrl+shift+plus" = "change_font_size all +1.0";
    "ctrl+shift+minus" = "change_font_size all -1.0";
    # bypass to tmux
    "ctrl+shift+h" = "launch --type=background tmux previous-window";
    "ctrl+shift+l" = "launch --type=background tmux next-window";
  };

  # https://github.com/kovidgoyal/kitty-themes/tree/master/themes
  themeFile = "tokyo_night_storm"; #"Catppuccin-Macchiato"; #"Tomorrow Night"; #"Nord";
}
