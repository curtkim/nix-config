{ ... }:
{
  # user/starship.nix 의 wrapper 버전.
  # STARSHIP_CACHE 는 기본값(~/.cache/starship) 과 같아서 따로 지정하지 않는다.
  flake.wrappers.starship =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.starship ];

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
          format = "[@$hostname]($style): ";
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
          symbol = " ";
          heuristic = false;
        };

        gcloud = {
          symbol = "🇬️ ";
          detect_env_vars = [ ];
          disabled = true;
        };

        battery = {
          disabled = true;
        };
      };
    };
}
