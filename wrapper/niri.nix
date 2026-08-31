{
  config,
  pkgs,
  lib,
  wlib,
  ...
}:

# user/hyprland/ 를 niri 로 옮긴 것.
# niri 는 scrolling tiling WM 이라 hyprland 의 dwindle 모델과 다르다.
# 1:1 로 안 넘어가는 것들은 각 항목에 주석으로 적어뒀다.
#
#   user/hyprland/general.nix -> 아래 "general" 섹션
#   user/hyprland/bind.nix    -> 아래 "binds" 섹션
#   user/hyprland/rules.nix   -> 아래 "window rules" 섹션
#   user/hyprland/default.nix -> runtimePkgs + spawn-at-startup + environment

let
  # hyprland 의 `bindOpts ... { locked = true; repeating = true; }` 대응.
  # niri 는 bind 가 기본으로 repeat 되므로 allow-when-locked 만 주면 된다.
  spawnWhenLocked = cmd: _: {
    props.allow-when-locked = true;
    content.spawn-sh = cmd;
  };
in
{
  imports = [ wlib.wrapperModules.niri ];

  # 합성용 주입 지점. parts/wrappers.nix 의 packages.desktop 이
  # packages.terminal (kitty wrapper) 를 여기에 꽂는다.
  # 기본값은 이 저장소의 kitty wrapper 라서 `nix build .#niri` 도 그대로 동작한다.
  options.terminal = lib.mkOption {
    type = lib.types.str;
    default = lib.getExe (wlib.evalPackage [
      { inherit pkgs; }
      ./kitty.nix
    ]);
    description = "Mod+Return 으로 띄울 터미널의 실행 파일 경로.";
  };

  # user/hyprland/default.nix 의 home.packages.
  # niri 가 spawn 하는 명령들이 PATH 에서 잡히도록 wrapper 에 붙인다.
  config.runtimePkgs = with pkgs; [
    dunst
    wofi
    grim
    slurp
    waybar
    wlogout
    notify-desktop
    pamixer
  ];

  config.settings = {
    # ---------------------------------------------------------------------
    # general  (user/hyprland/general.nix)
    # ---------------------------------------------------------------------

    # hyprland 의 home.sessionVariables.NIXOS_OZONE_WL.
    # niri 의 environment 는 자식 프로세스에 전달된다.
    environment = {
      NIXOS_OZONE_WL = "1";
    };

    # hyprland 의 xwayland.enable = true 대응.
    # niri 는 xwayland 를 내장하지 않고 xwayland-satellite 를 띄운다.
    # DISPLAY 는 niri 가 알아서 설정한다.
    xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

    input = {
      keyboard = {
        xkb.layout = "us,kr";
        repeat-delay = 250;
        repeat-rate = 25;
      };
      # hyprland: sensitivity = -0.5
      mouse.accel-speed = -0.5;
      # hyprland: touchpad.natural_scroll = false -> niri 기본값이 off 라 생략
      touchpad = _: { };
      # hyprland: follow_mouse = 1
      focus-follows-mouse = _: { };
    };

    # hyprland 의 monitor 는 output = "" 로 전체 매칭이 됐지만
    # niri 는 와일드카드 output 이 없어서 이름을 적어야 한다.
    # (general.nix 주석 기준: um790 = HDMI-A-2, silver = Unknown-1)
    outputs = {
      "HDMI-A-2".scale = 2;
      "Unknown-1".scale = 2;
    };

    layout = {
      # hyprland: gaps_in = 0, gaps_out = 0
      gaps = 0;

      # hyprland 의 general.col.active_border / inactive_border 대응.
      # niri 는 focus-ring 이 기본이라 끄고 border 를 쓴다.
      focus-ring.off = _: { };
      border = {
        width = 3;
        active-gradient = _: {
          props = {
            from = "#33ccff";
            to = "#00ff99";
            angle = 45;
          };
        };
        inactive-color = "#595959";
      };

      # hyprland: decoration.shadow.enabled = false
      shadow.off = _: { };

      # SUPER + 6/7/8/9/0 이 고르는 폭. hyprland 에서는 resize_windows.sh 가
      # 하던 일인데 niri 는 set-column-width 가 내장이라 스크립트가 필요 없다.
      preset-column-widths = [
        { proportion = 0.15; }
        { proportion = 0.30; }
        { proportion = 0.50; }
        { proportion = 0.70; }
        { proportion = 0.85; }
      ];
      default-column-width.proportion = 0.5;
    };

    # hyprland: animations.enabled = false
    animations.off = _: { };

    # hyprland: cursor.no_hardware_cursors = true
    # amdgpu 의 하드웨어 커서 plane 이 s2idle 복귀 후 되살아나지 않아
    # 커서가 보이지 않는 문제 회피 (동작은 하지만 그려지지 않음).
    # 2026-08-29 max1 (Strix Halo) 에서 확인.
    debug.disable-cursor-plane = _: { };

    prefer-no-csd = _: { };

    # hyprland: hl.on("hyprland.start", ...) 의 dunst
    spawn-at-startup = [ "dunst" ];

    # ---------------------------------------------------------------------
    # binds  (user/hyprland/bind.nix)
    # ---------------------------------------------------------------------
    binds = {
      "Mod+Return".spawn = config.terminal;
      "Mod+C".close-window = _: { };
      # "Mod+M".quit = _: { };
      "Mod+E".spawn = "dolphin";
      "Mod+V".toggle-window-floating = _: { };
      "Mod+Space".spawn-sh = "wofi --show drun";
      "Mod+F".fullscreen-window = _: { };
      # hyprland 의 fullscreen_state { internal = 2 } (maximize) 대응
      "Mod+Shift+F".maximize-column = _: { };
      "Mod+P".spawn-sh = ''grim -g "$(slurp)"'';
      "Mod+B".spawn-sh = "vivaldi --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime";

      # hyprland 의 cycle_next. niri 는 컬럼 단위라 오른쪽 컬럼으로 이동한다.
      "Mod+Tab".focus-column-right = _: { };
      "Mod+T".focus-column-right = _: { }; # for totem

      # NOTE: hyprland 의 `Mod+W -> submap workspaces` 는 niri 에 submap 개념이
      # 없어서 옮기지 못했다. Mod+1..5 를 그대로 쓰면 된다.

      # Switch workspaces
      "Mod+1".focus-workspace = 1;
      "Mod+2".focus-workspace = 2;
      "Mod+3".focus-workspace = 3;
      "Mod+4".focus-workspace = 4;
      "Mod+5".focus-workspace = 5;

      # 컬럼 폭. hyprland 의 resize_windows.sh 15/30/50/70/85 와 같은 비율.
      "Mod+6".set-column-width = "15%";
      "Mod+7".set-column-width = "30%";
      "Mod+8".set-column-width = "50%";
      "Mod+9".set-column-width = "70%";
      "Mod+0".set-column-width = "85%";

      # Move active window to a workspace
      "Mod+Shift+1".move-column-to-workspace = 1;
      "Mod+Shift+2".move-column-to-workspace = 2;
      "Mod+Shift+3".move-column-to-workspace = 3;
      "Mod+Shift+4".move-column-to-workspace = 4;
      "Mod+Shift+5".move-column-to-workspace = 5;
      "Mod+Shift+6".move-column-to-workspace = 6;
      "Mod+Shift+7".move-column-to-workspace = 7;
      "Mod+Shift+8".move-column-to-workspace = 8;
      "Mod+Shift+9".move-column-to-workspace = 9;
      "Mod+Shift+0".move-column-to-workspace = 10;

      # NOTE: hyprland 의 special workspace(scratchpad, Mod+S / Mod+Shift+S) 는
      # niri 에 대응이 없다. overview 로 대체해 둔다.
      "Mod+S".toggle-overview = _: { };

      # Scroll through existing workspaces
      "Mod+WheelScrollDown".focus-workspace-down = _: { };
      "Mod+WheelScrollUp".focus-workspace-up = _: { };

      # move window
      "Mod+Shift+H".move-column-left = _: { };
      "Mod+Shift+L".move-column-right = _: { };
      "Mod+Shift+K".move-window-up = _: { };
      "Mod+Shift+J".move-window-down = _: { };

      # resize window
      "Mod+Ctrl+H".set-column-width = "+10%";
      "Mod+Ctrl+L".set-column-width = "-10%";
      "Mod+Ctrl+K".set-window-height = "-10%";
      "Mod+Ctrl+J".set-window-height = "+10%";

      # Volume Control
      "XF86AudioRaiseVolume" = spawnWhenLocked "pamixer -i 10";
      "XF86AudioLowerVolume" = spawnWhenLocked "pamixer -d 10";

      # NOTE: hyprland 의 Mod+LMB drag / Mod+RMB resize 는 니리에서 기본 동작이라
      # 따로 bind 하지 않는다.
    };

    # ---------------------------------------------------------------------
    # window rules  (user/hyprland/rules.nix)
    # ---------------------------------------------------------------------
    # hyprland 의 suppress_event = "maximize" 는 niri 에 대응이 없다.
    # niri 는 클라이언트의 maximize 요청을 애초에 레이아웃에 반영하지 않는다.
    window-rules = [ ];
  };
}
