{ ... }:
{
  # user/tealdeer.nix 의 wrapper 버전. (실행 파일 이름은 tldr)
  flake.wrappers.tealdeer =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.tealdeer ];

      settings = {
        display = {
          compact = true;
          show_title = false;
        };
        style = {
          command_name = {
            foreground = "red";
          };
          example_text = {
            foreground = "green";
          };
          example_variable = {
            foreground = "white";
          };
          example_code = {
            foreground = "red";
          };
        };
      };
    };
}
