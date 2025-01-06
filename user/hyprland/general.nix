_: {
  wayland.windowManager.hyprland.settings = {

    # See https://wiki.hyprland.org/Configuring/Monitors/
    monitor= [
      "HDMI-A-1,preferred,auto,1.6"
    ];

    exec-once = [
      "dunst"
      "waybar"
      "kime"
    ];

    env = [
      # See https://wiki.hyprland.org/Configuring/Environment-variables/
      "XCURSOR_SIZE,64"
      "HYPRCURSOR_SIZE,64"
    ];

    general = {
      gaps_in = 1;
      gaps_out = 0;
      border_size = 3;
      # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";
      # Set to true enable resizing windows by clicking and dragging on borders and gaps
      resize_on_border = true;
      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      allow_tearing = false;
      layout = "dwindle";
    };
    decoration = {
      rounding = 8;

      # Change transparency of focused and unfocused windows
      active_opacity = 1.0;
      inactive_opacity = 1.0;

      #drop_shadow = true;
      #shadow_range = 4;
      #shadow_render_power = 3;
      #"col.shadow" = "rgba(1a1a1aee)";

      # https://wiki.hyprland.org/Configuring/Variables/#blur
      blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
      };
    };

    # https://wiki.hyprland.org/Configuring/Variables/#animations
    animations = {
      enabled = false;

      # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
      bezier = [
        "myBezier, 0.05, 0.9, 0.1, 1.05"
      ];
      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };

    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    dwindle = {
      pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = true; # You probably want this
    };

    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    master = {
      #new_status = master
    };

    # https://wiki.hyprland.org/Configuring/Variables/#misc
    misc = { 
      force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
      disable_hyprland_logo = true; # If true disables the random hyprland logo / anime girl background. :(
    };

    input = {
      kb_layout = "us,kr";
      repeat_delay = 250;
      repeat_rate = 25;
      follow_mouse = 1;
      sensitivity = -0.5; # -1.0 - 1.0, 0 means no modification.
      touchpad = {
        natural_scroll = false;
      };
    };

    # https://wiki.hyprland.org/Configuring/Variables/#gestures
    gestures = {
        workspace_swipe = false;
    };

    # Example per-device config
    # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
    device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
    };

  };
}
