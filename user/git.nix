{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
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
    };
  };

  # Enhanced diffs
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      side-by-side = true;
      diff-so-fancy = true;
      navigate = true;
    };
  };

  programs.lazygit.enable = true;
  programs.lazygit.settings = {
    git.pagers = [
      { pager = "delta --paging=never"; }
    ];
  };
}
