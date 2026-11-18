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

      # flake 에 등록된 hypridle wrapper (wrapper/hypridle.nix). 잠금은 wrapper hyprlock 을 쓴다.
      hypridle = wrappers.hypridle.wrap { inherit pkgs; };

      # 두 점을 찍어 영역 스크린샷 (user/hyprland/grim-by-two-point.sh 에서 복사)
      grimByTwoPoint = pkgs.writeShellApplication {
        name = "grim-by-two-point";
        runtimeInputs = [ pkgs.grim pkgs.slurp ];
        text = builtins.readFile ./grim-by-two-point.sh;
      };
    in
    {
      imports = [ wlib.wrapperModules.mangowc ];

      env = {
        #XCURSOR_THEME = self.lib.cursor.name;
        #XCURSOR_SIZE = toString self.lib.cursor.size;
      };

      #autostart_sh = ''
      #'';

      settings = {
        repeat_rate = 40;
        repeat_delay = 250;
        numlock_on = 0;

        exec_once = [
          # 이전 세션의 kime 가 pid 락을 쥐고 있으면 새 kime 가 뜨지 못하므로 먼저 죽인다.
          # 항목을 나누면 순서가 보장되지 않으니 한 줄로 묶는다.
          "${pkgs.callPackage ../../../pkgs/kime.nix { }}/bin/kime"
          "${lib.getExe hypridle}"
        ];

        default_master_factor = 0.5;

        monitor_rule = [
          "name:HDMI-A-1,scale:2.0"
        ];

        #tag_num = 10;

        #tagrule = map (id: "id:${toString id},layout_name:tile") (lib.range 1 17);

        window_rule = [
        ];

        layer_rule = [
        ];

        bind = [
          "${mod},Return,spawn,${lib.getExe kitty}"
          "${mod},space,spawn,${lib.getExe pkgs.wofi} --show drun"

          # 영역 선택 스크린샷 (user/hyprland/bind.nix 의 SUPER+P 와 동일). $(...) 때문에 spawn_shell.
          "${mod},p,spawn_shell,${lib.getExe pkgs.grim} -g \"$(${lib.getExe pkgs.slurp})\""
          "${mod}+SHIFT,p,spawn,${lib.getExe grimByTwoPoint}"

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
          "${mod}+SHIFT,f,togglemaximizescreen"

          "${mod},1,view,1"
          "${mod},2,view,2"
          "${mod},3,view,3"
          "${mod},4,view,4"
          "${mod},5,view,5"

          # 왼쪽(master) 영역 비율을 15/30/50/70/85% 로 (hyprland 의 resize_windows.sh 대응)
          # setmfact 는 인자 < 1.0 이면 상대값, >= 1.0 이면 (인자 - 1.0) 절대값이다.
          "${mod},6,setmfact,1.15"
          "${mod},7,setmfact,1.30"
          "${mod},8,setmfact,1.50"
          "${mod},9,setmfact,1.70"
          "${mod},0,setmfact,1.85"
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
