{ config, ... }:
let
  inherit (config.flake) wrappers;
in
{
  # user/hypridle.nix 의 wrapper 버전.
  # nix-wrapper-modules 에 hypridle 모듈이 없어서 설정 파일을 직접 만들어 --config 로 넘긴다.
  flake.wrappers.hypridle =
    {
      config,
      wlib,
      pkgs,
      lib,
      ...
    }:
    let
      # flake 에 등록된 hyprlock wrapper (wrapper/hyprlock.nix)
      hyprlock = lib.getExe (wrappers.hyprlock.wrap { inherit pkgs; });

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${hyprlock}";
          before_sleep_cmd = "loginctl lock-session";
          # mango 의 wakeup_monitor 는 모니터 이름이 필요해서, 이름 없이 모든 출력을 켜는
          # wlopm (wlr-output-power-management, mango 지원) 을 쓴다.
          after_sleep_cmd = "${lib.getExe pkgs.wlopm} --on '*'";
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

      # `name { key = value }` 섹션. 리스트면 같은 이름의 섹션을 여러 개 만든다.
      toHyprconf = lib.concatMapAttrsStringSep "\n" (
        name: value:
        lib.concatMapStringsSep "\n" (section: ''
          ${name} {
          ${lib.concatStrings (lib.mapAttrsToList (k: v: "  ${k} = ${toString v}\n") section)}}
        '') (lib.toList value)
      );
    in
    {
      imports = [ wlib.modules.default ];

      package = pkgs.hypridle;

      constructFiles.generatedConfig = {
        relPath = "${config.binName}.conf";
        content = toHyprconf settings;
      };

      flags."--config" = config.constructFiles.generatedConfig.path;
    };
}
