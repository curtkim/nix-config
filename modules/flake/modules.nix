# flake.modules.<class>.<name> 에 모듈을 등록한다. (dendritic 패턴)
#
# flake-parts 의 flakeModules.modules 와 같지만 key 를 붙인다. key 가 없으면 같은 모듈을
# 여러 곳(예: common 과 호스트)에서 import 할 때 중복 제거가 안 돼서 정의가 두 번 들어간다.
{ lib, ... }:
let
  inherit (lib) mkOption types mapAttrs;
in
{
  options.flake = mkOption {
    type = types.submoduleWith {
      modules = [
        {
          options.modules = mkOption {
            type = types.lazyAttrsOf (types.lazyAttrsOf types.deferredModule);
            default = { };
            apply = mapAttrs (
              class:
              mapAttrs (
                name: module: {
                  _class = class;
                  key = "modules.${class}.${name}";
                  _file = "modules.${class}.${name}";
                  imports = [ module ];
                }
              )
            );
            description = "클래스별 모듈. 호스트는 config.flake.modules.nixos.<이름> 으로 참조한다.";
          };
        }
      ];
    };
  };
}
