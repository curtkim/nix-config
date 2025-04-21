_: {
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    bind = [
      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      "$mainMod, return, exec, kitty"
      "$mainMod, C, killactive,"
      # $mainMod, M, exit,
      "$mainMod, E, exec, dolphine"
      "$mainMod, V, togglefloating,"
      "$mainMod, space, exec, wofi --show drun"
      #$mainMod, P, pseudo, # dwindle
      "$mainMod, F, fullscreen"
      "$mainMod SHIFT, F, fullscreenstate, 2 0"
      "$mainMod, P, exec, grim -g \"$(slurp)\""
      "$mainMod, B, exec, vivaldi --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime"
      #$mainMod, J, togglesplit, # dwindle

      # Move focus with mainMod + arrow keys
      #$mainMod, H, movefocus, l
      #$mainMod, L, movefocus, r
      #$mainMod, K, movefocus, u
      #$mainMod, J, movefocus, d
      "$mainMod, Tab, cyclenext"

      # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"

      #"$mainMod, 6, resizeactive, exact 15% 85%"
      #"$mainMod, 7, resizeactive, exact 25% 75%"
      #"$mainMod, 8, resizeactive, exact 50% 50%"
      #"$mainMod, 9, resizeactive, exact 75% 25%"
      #"$mainMod, 0, resizeactive, exact 85% 15%"
      "$mainMod, 6, exec, ${./resize_windows.sh} 15"
      "$mainMod, 7, exec, ${./resize_windows.sh} 30"
      "$mainMod, 8, exec, ${./resize_windows.sh} 50"
      "$mainMod, 9, exec, ${./resize_windows.sh} 70"
      "$mainMod, 0, exec, ${./resize_windows.sh} 85"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      # Example special workspace (scratchpad)
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"

      # move winodw
      "$mainMod SHIFT, H, movewindow, l"
      "$mainMod SHIFT, L, movewindow, r"
      "$mainMod SHIFT, K, movewindow, u"
      "$mainMod SHIFT, J, movewindow, d"

      # resize winodw
      "$mainMod CTRL, H, resizeactive, 10 0"
      "$mainMod CTRL, L, resizeactive, -10 0"
      "$mainMod CTRL, K, resizeactive, 0 -10"
      "$mainMod CTRL, J, resizeactive, 0 10"


      # Volume and Media Control
      ", XF86AudioRaiseVolume, exec, pamixer -i 10"
      ", XF86AudioLowerVolume, exec, pamixer -d 10"
    ];

    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
  };
}
