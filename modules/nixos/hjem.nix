# home-manager 대신 hjem 으로 ~ 아래 파일을 관리한다.
# 기능별 모듈이 이 모듈을 import 하고 hjem.users.curt 에 파일을 더한다.
{ inputs, ... }:
{
  flake.modules.nixos.hjem = {
    imports = [ inputs.hjem.nixosModules.default ];

    hjem = {
      users.curt = {
        enable = true;
        user = "curt";
        directory = "/home/curt";
      };

      # 이전에 home-manager 가 만든 심볼릭 링크가 있으면 덮어쓴다.
      clobberByDefault = true;
    };
  };
}
