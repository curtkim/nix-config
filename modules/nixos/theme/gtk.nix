# user/ui-theme.nix 의 GTK/커서 부분. (~/nixconf/modules/features/theme/gtk.nix 참고)
#
# 테마는 특정 프로그램이 아니라 모든 GTK/Qt 앱이 읽는 설정이라 wrapper 대신 시스템 전체에 둔다.
# GTK 설정 파일은 hjem 으로 ~/.config 에 두고, 커서 환경 변수와 dconf 를 쓴다.
# theme/ 아래 파일들이 flake.modules.nixos.ui-theme 에 각자 정의를 더한다. (qt 는 qt.nix)
{ config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.modules.nixos.ui-theme =
    { pkgs, lib, ... }:
    let
      # breeze-gtk 의 테마 디렉터리 이름은 "Breeze" 다. (대소문자 구분)
      theme-name = "Breeze";
      theme-package = pkgs.kdePackages.breeze-gtk;

      icon-theme-name = "breeze";
      icon-theme-package = pkgs.kdePackages.breeze-icons;

      cursor-theme-name = "breeze_cursors";
      cursor-theme-package = pkgs.kdePackages.breeze;
      cursor-size = 32;

      font-name = "Noto Sans 10";

      gtksettings = ''
        [Settings]
        gtk-theme-name = ${theme-name}
        gtk-icon-theme-name = ${icon-theme-name}
        gtk-cursor-theme-name = ${cursor-theme-name}
        gtk-cursor-theme-size = ${toString cursor-size}
        gtk-font-name = ${font-name}
      '';

      gtk2rc = ''
        gtk-theme-name = "${theme-name}"
        gtk-icon-theme-name = "${icon-theme-name}"
        gtk-cursor-theme-name = "${cursor-theme-name}"
        gtk-cursor-theme-size = ${toString cursor-size}
        gtk-font-name = "${font-name}"
      '';
    in
    {
      imports = [ nixos.hjem ];

      hjem.users.curt.xdg.config.files = {
        "gtk-2.0/gtkrc".text = gtk2rc;
        "gtk-3.0/settings.ini".text = gtksettings;
        "gtk-4.0/settings.ini".text = gtksettings;
      };

      environment = {
        variables = {
          # GTK2 는 ~/.config/gtk-2.0/gtkrc 를 기본으로 읽지 않는다.
          GTK2_RC_FILES = "/home/curt/.config/gtk-2.0/gtkrc";
          XCURSOR_THEME = cursor-theme-name;
          XCURSOR_SIZE = toString cursor-size;
        };

        systemPackages = [
          theme-package
          icon-theme-package
          cursor-theme-package
        ];
      };

      # GTK4 / portal 을 통하는 앱은 settings.ini 대신 gsettings 를 읽는다.
      programs.dconf = {
        enable = lib.mkDefault true;
        profiles.user.databases = [
          {
            lockAll = false;
            settings."org/gnome/desktop/interface" = {
              gtk-theme = theme-name;
              icon-theme = icon-theme-name;
              cursor-theme = cursor-theme-name;
              cursor-size = lib.gvariant.mkInt32 cursor-size;
              inherit font-name;
            };
          }
        ];
      };
    };
}
