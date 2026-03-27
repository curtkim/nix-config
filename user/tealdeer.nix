{ config, ... }:
{
  programs.tealdeer = {
    enable = true;
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
