{ pkgs, lib, ... }:
let
  delta = lib.getExe pkgs.delta;
in
{
  # user/git.nix 의 NixOS 버전. /etc/gitconfig 에 쓰이므로
  # home-manager 의 ~/.config/git/config 가 있으면 그쪽이 우선한다.
  programs.git = {
    enable = true;
    lfs.enable = true;
    config = {
      user.name = "curtkim";
      user.email = "iamteri@gmail.com";

      diff.colorMoved = "default";

      alias = {
        st = "status -sb";
        lg = "log --oneline --date=short --format='%h %C(yellow)%ad%Creset %s' --graph --decorate -20";
        ch = "checkout";
        cm = "commit -m";
        br = "branch";
        pu = "push";
      };

      # Enhanced diffs (home-manager programs.delta.enableGitIntegration 과 같은 설정)
      core.pager = delta;
      interactive.diffFilter = "${delta} --color-only";
      delta = {
        line-numbers = true;
        side-by-side = true;
        diff-so-fancy = true;
        navigate = true;
      };
    };
  };

  environment.systemPackages = [ pkgs.delta ];

  programs.lazygit = {
    enable = true;
    settings = {
      git.pagers = [
        { pager = "${delta} --paging=never"; }
      ];
    };
  };
}
