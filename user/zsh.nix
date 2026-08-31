{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion = {
      enable = true;
    };
    enableCompletion = true;
    defaultKeymap = "emacs";
    history = {
      extended = true;
    };
    shellAliases = {
      vi = "nvim";
      ls = "eza";
      l = "eza -l --time-style iso";
      la = "eza -la";
      ip = "ip --color=auto";
      icat = "kitten icat";
      show_path = "echo $PATH | tr ':' '\n'";

      lg = "lazygit";
      gs = "git status -sb";
      ga = "git add";
      gd = "git diff";
      gc = "git commit -m";
      gp = "git pull";
      gP = "git push";
      gl = "git log --oneline --graph --decorate -20";

      #shortcut
      b = "cd ~/brain/ && vi";
      n = "cd ~/nix-config/ && vi";
      v = "cd ~/.config/nvim/ && vi";
      t = "tree";
      x = "exit";
      myip = "curl -s ipinfo.io | jq '.ip'";
      cl = "claude";
      dl = "deepl";
    };

    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "zsh-syntax-highlighting.zsh";
      }
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
