# herdr (AI agent 용 terminal multiplexer). wrapper/tmux.nix 의 키 설정을 옮겼다.
# 설정 파일은 hjem 으로 ~/.config/herdr/config.toml 에 링크한다.
# 기본값과 전체 키 목록: `herdr --default-config`
#
# 주의: 링크된 파일은 읽기 전용이라 herdr 의 settings 화면(prefix+s)에서 바꾼 값은
# 저장되지 않는다. 설정은 이 파일에서 바꾼다.
{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.modules.nixos.herdr =
    { pkgs, ... }:
    let
      toml = pkgs.formats.toml { };
    in
    {
      imports = [ nixos.hjem ];

      environment.systemPackages = [
        inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.herdr
      ];

      hjem.users.curt.xdg.config.files."herdr/config.toml".source = toml.generate "herdr-config.toml" {
        # 첫 실행 안내(onboarding)는 config.toml 에 값을 쓰려 하므로 끈다.
        onboarding = false;

        update.version_check = false; # nix 로 업데이트한다.

        keys = {
          # tmux 와 같은 ctrl+; (kitty 가 CSI u 로 보낸다. wrapper/kitty.nix)
          # kime 도 이 키에서 영어로 바꾼다. (nixos/kime.nix)
          prefix = "ctrl+semicolon";

          #focus_pane_left  = "ctrl+h";
          #focus_pane_down  = "ctrl+j";
          #focus_pane_up    = "ctrl+k";
          #focus_pane_right = "ctrl+l";

          # tmux: bind -n C-] copy-mode
          copy_mode = [
            "prefix+["
            "ctrl+]"
          ];

          # tmux: | \ 는 좌우, - _ 는 위아래 분할
          split_vertical = [
            "prefix+v"
            "prefix+|"
            "prefix+backslash"
          ];
          split_horizontal = [
            "prefix+minus"
            "prefix+_"
          ];

          # tmux: < > swap-window
          move_tab_previous = "prefix+<";
          move_tab_next = "prefix+>";

          # tmux: prefix+r 로 설정 다시 읽기. resize 모드는 shift+r 로 옮긴다.
          # (resize 모드 안에서 h/j/k/l 로 반복 조절한다. tmux 의 bind -r C-h.. 대신)
          reload_config = "prefix+r";
          resize_mode = "prefix+shift+r";
        };

        ui = {
          pane_gaps = false;
          tab_bar_position = "top";
          hide_tab_bar_when_single_tab = true;
          tab_bar_right = [
            { type = "zoom"; }
            {
              type = "datetime";
              format = "%H:%M %Y-%m-%d";
            }
          ];
        };
      };
    };
}
