# user/ui-theme.nix 의 Qt 부분. (~/nixconf/modules/features/theme/qt.nix 참고)
{
  flake.modules.nixos.ui-theme = {
    qt = {
      enable = true;
      platformTheme = "kde";
      style = "breeze";
    };
  };
}
