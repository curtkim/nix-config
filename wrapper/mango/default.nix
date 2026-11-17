{
  config,
  wlib,
  pkgs,
  lib,
  ...
}: let
  mod = "SUPER";
in
{
  imports = [ wlib.wrapperModules.mangowc ];

  env = {
    #XCURSOR_THEME = self.lib.cursor.name;
    #XCURSOR_SIZE = toString self.lib.cursor.size;
  };

  autostart_sh = ''
    
  '';

  settings = {
    repeat_rate = 40;
    repeat_delay = 250;
    numlockon = 0;

    #tag_num = 10;

    #tagrule = map (id: "id:${toString id},layout_name:tile") (lib.range 1 17);

    windowrule = [
    ];

    layerrule = [
    ];

    bind = [
      "${mod},Return,spawn,kitty"
      "${mod},space,spawn,wofi --show drun"

      "${mod},m,quit"
      "${mod},q,killclient"

      "${mod},h,focusdir,left"
      "${mod},l,focusdir,right"
      "${mod},k,focusdir,up"
      "${mod},j,focusdir,down"
    ];

    axisbind = [
      #"SUPER,UP,spawn,${exeOf pkgs.vj.volYtMusic} up"
      #"SUPER,DOWN,spawn,${exeOf pkgs.vj.volYtMusic} down"

      #"SUPER+CTRL,UP,spawn,${exeOf pkgs.vj.vol} up"
      #"SUPER+CTRL,DOWN,spawn,${exeOf pkgs.vj.vol} down"
    ];
  };
}
