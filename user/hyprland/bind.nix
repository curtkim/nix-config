{ lib, ... }:
let
  inherit (lib.generators) mkLuaInline;

  mainMod = "SUPER";

  # hl.bind(keys, dispatcher [, opts])
  bind = keys: dispatcher: { _args = [ keys (mkLuaInline dispatcher) ]; };
  bindOpts = keys: dispatcher: opts: {
    _args = [
      keys
      (mkLuaInline dispatcher)
      opts
    ];
  };

  resize = ./resize_windows.sh;
in
{
  wayland.windowManager.hyprland.settings = {

    # Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
    bind = [
      (bind "${mainMod} + return" ''hl.dsp.exec_cmd("kitty")'')
      (bind "${mainMod} + C" "hl.dsp.window.close()")
      # (bind "${mainMod} + M" "hl.dsp.exit()")
      (bind "${mainMod} + E" ''hl.dsp.exec_cmd("dolphin")'')
      (bind "${mainMod} + V" ''hl.dsp.window.float({ action = "toggle" })'')
      (bind "${mainMod} + space" ''hl.dsp.exec_cmd("wofi --show drun")'')
      # (bind "${mainMod} + P" "hl.dsp.window.pseudo()")  # dwindle
      (bind "${mainMod} + F" "hl.dsp.window.fullscreen()")
      (bind "${mainMod} + SHIFT + F" "hl.dsp.window.fullscreen_state({ internal = 2, client = 0 })")
      (bind "${mainMod} + P" ''hl.dsp.exec_cmd("grim -g \"$(slurp)\"")'')
      (bind "${mainMod} + B"
        ''hl.dsp.exec_cmd("vivaldi --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime")''
      )
      # (bind "${mainMod} + J" ''hl.dsp.layout("togglesplit")'')  # dwindle

      # Move focus with mainMod + vim keys
      # (bind "${mainMod} + H" ''hl.dsp.focus({ direction = "left" })'')
      # (bind "${mainMod} + L" ''hl.dsp.focus({ direction = "right" })'')
      # (bind "${mainMod} + K" ''hl.dsp.focus({ direction = "up" })'')
      # (bind "${mainMod} + J" ''hl.dsp.focus({ direction = "down" })'')
      (bind "${mainMod} + Tab" "hl.dsp.window.cycle_next()")
      # for totem
      (bind "${mainMod} + T" "hl.dsp.window.cycle_next()")

      # $mainMod + W -> submap -> q/w/e/r/t for workspace 1/2/3/4/5
      (bind "${mainMod} + W" ''hl.dsp.submap("workspaces")'')

      # Switch workspaces with mainMod + [1-5]
      (bind "${mainMod} + 1" "hl.dsp.focus({ workspace = 1 })")
      (bind "${mainMod} + 2" "hl.dsp.focus({ workspace = 2 })")
      (bind "${mainMod} + 3" "hl.dsp.focus({ workspace = 3 })")
      (bind "${mainMod} + 4" "hl.dsp.focus({ workspace = 4 })")
      (bind "${mainMod} + 5" "hl.dsp.focus({ workspace = 5 })")

      # Split the screen between the two tiled windows
      (bind "${mainMod} + 6" ''hl.dsp.exec_cmd("${resize} 15")'')
      (bind "${mainMod} + 7" ''hl.dsp.exec_cmd("${resize} 30")'')
      (bind "${mainMod} + 8" ''hl.dsp.exec_cmd("${resize} 50")'')
      (bind "${mainMod} + 9" ''hl.dsp.exec_cmd("${resize} 70")'')
      (bind "${mainMod} + 0" ''hl.dsp.exec_cmd("${resize} 85")'')

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      (bind "${mainMod} + SHIFT + 1" "hl.dsp.window.move({ workspace = 1 })")
      (bind "${mainMod} + SHIFT + 2" "hl.dsp.window.move({ workspace = 2 })")
      (bind "${mainMod} + SHIFT + 3" "hl.dsp.window.move({ workspace = 3 })")
      (bind "${mainMod} + SHIFT + 4" "hl.dsp.window.move({ workspace = 4 })")
      (bind "${mainMod} + SHIFT + 5" "hl.dsp.window.move({ workspace = 5 })")
      (bind "${mainMod} + SHIFT + 6" "hl.dsp.window.move({ workspace = 6 })")
      (bind "${mainMod} + SHIFT + 7" "hl.dsp.window.move({ workspace = 7 })")
      (bind "${mainMod} + SHIFT + 8" "hl.dsp.window.move({ workspace = 8 })")
      (bind "${mainMod} + SHIFT + 9" "hl.dsp.window.move({ workspace = 9 })")
      (bind "${mainMod} + SHIFT + 0" "hl.dsp.window.move({ workspace = 10 })")

      # Example special workspace (scratchpad)
      (bind "${mainMod} + S" ''hl.dsp.workspace.toggle_special("magic")'')
      (bind "${mainMod} + SHIFT + S" ''hl.dsp.window.move({ workspace = "special:magic" })'')

      # Scroll through existing workspaces with mainMod + scroll
      (bind "${mainMod} + mouse_down" ''hl.dsp.focus({ workspace = "e+1" })'')
      (bind "${mainMod} + mouse_up" ''hl.dsp.focus({ workspace = "e-1" })'')

      # move window
      (bind "${mainMod} + SHIFT + H" ''hl.dsp.window.move({ direction = "left" })'')
      (bind "${mainMod} + SHIFT + L" ''hl.dsp.window.move({ direction = "right" })'')
      (bind "${mainMod} + SHIFT + K" ''hl.dsp.window.move({ direction = "up" })'')
      (bind "${mainMod} + SHIFT + J" ''hl.dsp.window.move({ direction = "down" })'')

      # resize window
      (bind "${mainMod} + CTRL + H" "hl.dsp.window.resize({ x = 10, y = 0 })")
      (bind "${mainMod} + CTRL + L" "hl.dsp.window.resize({ x = -10, y = 0 })")
      (bind "${mainMod} + CTRL + K" "hl.dsp.window.resize({ x = 0, y = -10 })")
      (bind "${mainMod} + CTRL + J" "hl.dsp.window.resize({ x = 0, y = 10 })")

      # Volume and Media Control
      (bindOpts "XF86AudioRaiseVolume" ''hl.dsp.exec_cmd("pamixer -i 10")'' {
        locked = true;
        repeating = true;
      })
      (bindOpts "XF86AudioLowerVolume" ''hl.dsp.exec_cmd("pamixer -d 10")'' {
        locked = true;
        repeating = true;
      })

      # Move/resize windows with mainMod + LMB/RMB and dragging
      (bindOpts "${mainMod} + mouse:272" "hl.dsp.window.drag()" { mouse = true; })
      (bindOpts "${mainMod} + mouse:273" "hl.dsp.window.resize()" { mouse = true; })
    ];
  };

  # $mainMod + W then q/w/e/r/t jumps to workspace 1..5.
  # onDispatch = "reset" leaves the submap automatically after any bind fires.
  wayland.windowManager.hyprland.submaps.workspaces = {
    onDispatch = "reset";
    settings.bind = [
      (bind "Q" "hl.dsp.focus({ workspace = 1 })")
      (bind "W" "hl.dsp.focus({ workspace = 2 })")
      (bind "E" "hl.dsp.focus({ workspace = 3 })")
      (bind "R" "hl.dsp.focus({ workspace = 4 })")
      (bind "T" "hl.dsp.focus({ workspace = 5 })")
      (bind "escape" ''hl.dsp.submap("reset")'')
    ];
  };
}
