{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "curtkim";
    userEmail = "iamteri@gmail.com";
    aliases = {
      st = "status -sb";
      lg = "log --oneline --graph --decorate -20";
      ch = "checkout";
      cm = "commit -m";
      br = "branch";
      pu = "push";
    };
  };
}

