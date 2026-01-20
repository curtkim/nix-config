{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "curtkim";
      user.email = "iamteri@gmail.com";
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
}
