_: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 570; # 9분 30초
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600; # 10분
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
