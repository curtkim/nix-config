{ config, ... }: {
  home.sessionVariables = {
    STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";
  };
  programs.starship = {
    enable = true;
    settings = {
      character = {
        success_symbol = "[›](bold green)";
        error_symbol = "[›](bold red)";
      };

      directory = {
        truncate_to_repo = true;
        truncation_length = 3;
        #truncation_symbol = "…/";
        repo_root_style = "green";
      };

      username = {
        format = "[$user]($style)";
        style_user = "bold dimmed yellow";
      };

      hostname = {
        format ="[@$hostname]($style): ";
        style = "bold dimmed green";
      };

      localip = {
        disabled = true;
      };

      git_status = {
        deleted = "✗";
        modified = "✶";
        staged = "✓";
        stashed = "≡";
      };

      nix_shell = {
        symbol = " ";
        heuristic = true;
      };

      gcloud = {
        symbol = "🇬️ ";
        detect_env_vars = [];
        disabled = true;
      };
    };
  };
}
