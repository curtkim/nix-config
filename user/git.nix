{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "curtkim";
    userEmail = "iamteri@gmail.com";
    aliases = {
      st = "status -sb";
      lg = "log --oneline --date=short --format='%h %C(yellow)%ad%Creset %s' --graph --decorate -20";
      ch = "checkout";
      cm = "commit -m";
      br = "branch";
      pu = "push";
    };
  };
}

