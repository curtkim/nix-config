{ config, ... }:
let
  inherit (config.flake) wrappers;
in
{
  flake.wrappers.mango =
    {
      config,
      wlib,
      pkgs,
      lib,
      ...
    }: let
      mod = "SUPER";

      # flake 에 등록된 kitty wrapper (wrapper/kitty.nix)
      kitty = wrappers.kitty.wrap { inherit pkgs; };
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

        exec-once = [
          # 이전 세션의 kime 가 pid 락을 쥐고 있으면 새 kime 가 뜨지 못하므로 먼저 죽인다.
          # 항목을 나누면 순서가 보장되지 않으니 한 줄로 묶는다.
          "${pkgs.kime}/bin/kime -k; ${pkgs.kime}/bin/kime"
        ];

        default_mfact = 0.5;

        monitorrule = [
          "name:HDMI-A-1,scale:2.0"
        ];

        #tag_num = 10;

        #tagrule = map (id: "id:${toString id},layout_name:tile") (lib.range 1 17);

        windowrule = [
        ];

        layerrule = [
        ];

        bind = [
          "${mod},Return,spawn,${lib.getExe kitty}"
          "${mod},space,spawn,${lib.getExe pkgs.wofi} --show drun"

          "${mod},m,quit"
          "${mod},q,killclient"

          "${mod},h,focusdir,left"
          "${mod},l,focusdir,right"
          "${mod},k,focusdir,up"
          "${mod},j,focusdir,down"

          "${mod}+SHIFT,k,exchange_client,up"
          "${mod}+SHIFT,j,exchange_client,down"
          "${mod}+SHIFT,h,exchange_client,left"
          "${mod}+SHIFT,l,exchange_client,right"


          "${mod},f,togglefullscreen"
          "${mod}+SHIFT,f,togglefakefullscreen"

          "${mod},1,view,1"
          "${mod},2,view,2"
          "${mod},3,view,3"
          "${mod},4,view,4"
          "${mod},5,view,5"
          "${mod},6,view,6"
          "${mod},7,view,7"
          "${mod},8,view,8"
          "${mod},9,view,9"
          "${mod},0,view,10"
        ];

        axisbind = [
          #"SUPER,UP,spawn,${exeOf pkgs.vj.volYtMusic} up"
          #"SUPER,DOWN,spawn,${exeOf pkgs.vj.volYtMusic} down"

          #"SUPER+CTRL,UP,spawn,${exeOf pkgs.vj.vol} up"
          #"SUPER+CTRL,DOWN,spawn,${exeOf pkgs.vj.vol} down"
        ];
      };
    };
}
