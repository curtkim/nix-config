_: {
  wayland.windowManager.hyprland.settings = {
    # See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
    window_rule = [
      {
        # Ignore maximize requests from all apps. You'll probably like this.
        name = "suppress-maximize-events";
        match = {
          class = ".*";
        };
        suppress_event = "maximize";
      }
    ];
  };
}
