_: {
  wayland.windowManager.hyprland.settings = {

    # See https://wiki.hypr.land/Configuring/Basics/Monitors/
    # um790 : HDMI-A-2
    # silver : Unknown-1
    monitor = [
      {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = 2;
      }
    ];

    # See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
    # env = [ { _args = [ "XCURSOR_SIZE" "64" ]; } ];

    config = {
      # https://wiki.hypr.land/Configuring/Basics/Variables/
      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 3;
        col = {
          active_border = {
            colors = [
              "rgba(33ccffee)"
              "rgba(00ff99ee)"
            ];
            angle = 45;
          };
          inactive_border = "rgba(595959aa)";
        };
        # Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true;
        # Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow.enabled = false;

        blur = {
          enabled = false;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations.enabled = false;

      # See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
      # NOTE: `pseudotile` is no longer a config option in Hyprland 0.55.
      # Pseudotiling is now only the hl.dsp.window.pseudo() dispatcher.
      dwindle = {
        preserve_split = true; # You probably want this
      };

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
    };

    # Kept for when animations are re-enabled above.
    # See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
    curve = [
      {
        _args = [
          "myBezier"
          {
            type = "bezier";
            points = [
              [
                0.05
                0.9
              ]
              [
                0.1
                1.05
              ]
            ];
          }
        ];
      }
    ];

    animation = [
      {
        leaf = "windows";
        enabled = true;
        speed = 7;
        bezier = "myBezier";
      }
      {
        leaf = "windowsOut";
        enabled = true;
        speed = 7;
        bezier = "default";
        style = "popin 80%";
      }
      {
        leaf = "border";
        enabled = true;
        speed = 10;
        bezier = "default";
      }
      {
        leaf = "borderangle";
        enabled = true;
        speed = 8;
        bezier = "default";
      }
      {
        leaf = "fade";
        enabled = true;
        speed = 7;
        bezier = "default";
      }
      {
        leaf = "workspaces";
        enabled = true;
        speed = 6;
        bezier = "default";
      }
    ];

    # Example per-device config
    # See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
    device = [
      {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      }
    ];
  };

  # Autostart. See https://wiki.hypr.land/Configuring/Basics/Autostart/
  # Uses the start hook so these do not respawn on every config reload.
  wayland.windowManager.hyprland.extraConfig = ''
    hl.on("hyprland.start", function()
      hl.exec_cmd("dunst")
      hl.exec_cmd("kime")
    end)
  '';
}
