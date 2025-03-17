{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    userSettings = {
        # This property will be used to generate settings.json:
        # https://code.visualstudio.com/docs/getstarted/settings#_settingsjson
        "editor.formatOnSave" = true;
    };
    keybindings = [
        # See https://code.visualstudio.com/docs/getstarted/keybindings#_advanced-customization
        {
            key = "shift+cmd+j";
            command = "workbench.action.focusActiveEditorGroup";
            when = "terminalFocus";
        }
    ];
    extensions = [
      pkgs.vscode-extensions.ms-python.python
      #pkgs.vscode-extensions.saoudrizwan.claude-dev
    ] ++ (pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "claude-dev";
        publisher = "saoudrizwan";
        version = "3.7.0";
        sha256 = "sha256-RJC4B7p1zu9sPMvVZ4e+fURC8z5fwYgFFpRH45YdZjM=";
      }
    ]);
    package = pkgs.vscode.override (old: {
      # Wayland Fcitx5
      commandLineArgs = (old.commandLineArgs or [ ]) ++ [ "--enable-wayland-ime" ];
    });
  };
}
