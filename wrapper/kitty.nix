{
  config,
  pkgs,
  lib,
  wlib,
  ...
}:

{
  imports = [ wlib.wrapperModules.kitty ];

  # 합성용 주입 지점. parts/wrappers.nix 의 packages.terminal 이
  # packages.environment (zsh wrapper) 를 여기에 꽂는다.
  # null 이면 kitty 가 사용자의 로그인 셸을 쓴다 (kitty 기본 동작).
  options.shell = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "kitty 가 띄울 셸의 실행 파일 경로 (kitty.conf 의 shell).";
  };

  # 옵션 이름은 home-manager 의 programs.kitty 와 그대로 대응된다.
  # (settings / themeFile / font / keybindings / mouseBindings / actionAliases /
  #  environment / extraConfig)

  config.font = {
    name = "JetBrainsMonoNL Nerd Font Thin";
    #name = "JetBrainsMonoNL NFM Regular";
    #name = "JetBrainsMonoNL NFM ExtraLight";
    #name = "JetBrainsMonoNL NFM Thin";
    size = 13;
  };

  config.settings = {
    shell = lib.mkIf (config.shell != null) config.shell;

    scrollback_lines = 5000;
    paste_actions = "filter";
    #cursor_trail = 1;

    # HM 의 programs.kitty.shellIntegration.mode 기본값이 "no-rc" 라서
    # 여기서 직접 넣어준다. wrapper 모듈에는 shellIntegration 옵션이 없다.
    # 셸 쪽 절반은 wrapper/zsh.nix 에 있다.
    shell_integration = "no-rc";
  };

  config.keybindings = {
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
  config.themeFile = "tokyo_night_storm"; #"Catppuccin-Macchiato"; #"Tomorrow Night"; #"Nord";
}
