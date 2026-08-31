{
  pkgs,
  lib,
  wlib,
  ...
}:

{
  imports = [ wlib.wrapperModules.starship ];

  # HM 은 home.sessionVariables 로 전역 설정했지만, wrapper 에서는
  # starship 을 실행할 때만 잡아주면 된다.
  # env 는 리터럴 문자열이라 $HOME 확장이 안 되므로 runShell 로 처리한다.
  runShell = [ ''export STARSHIP_CACHE="''${XDG_CACHE_HOME:-$HOME/.cache}/starship"'' ];

  # STARSHIP_CONFIG 는 모듈이 자동으로 생성된 starship.toml 로 설정한다.
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
}
