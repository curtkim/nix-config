{ ... }:
{
  flake.modules.nixos.kime =
    { ... }:
    {
      # i18n.inputMethod 는 pkgs.kime 를 쓰므로 overlay 로 고친 kime 로 바꾼다. (pkgs/kime.nix 참고)
      nixpkgs.overlays = [
        (final: prev: { kime = final.callPackage ../../pkgs/kime.nix { inherit (prev) kime; }; })
      ];

      # tail -f /run/user/1000/kime.err
      # cat /etc/xdg/kime/config.yaml
      i18n.inputMethod.enable = true;
      i18n.inputMethod.type = "kime";
      #i18n.inputMethod.kime.daemonModules = [ "Indicator" "Wayland" ];
      i18n.inputMethod.kime.iconColor = "White";
      i18n.inputMethod.kime.extraConfig = ''
        log:
          global_level: DEBUG
        engine:
          translation_layer: null
          default_category: Latin
          global_category_state: true
          global_hotkeys:
            C-Space:
              behavior: !Toggle
              - Hangul
              - Latin
              result: Consume
            AltR:
              behavior: !Toggle
              - Hangul
              - Latin
              result: Consume
            Hangul:
              behavior: !Toggle
              - Hangul
              - Latin
              result: Consume
            # tmux prefix(ctrl+;) 를 누르면 영어로 바꾸고, 키는 그대로 앱(kitty)에 넘긴다.
            C-SemiColon:
              behavior: !Switch Latin
              result: Bypass
          hangul:
            layout: my-dubeolsik
            word_commit: false
            preedit_johab: Needed
            addons:
              all:
              - ComposeChoseongSsang
              my-dubeolsik:
              - TreatJongseongAsChoseong
      '';

      # kime 는 XDG_CONFIG_DIRS (/etc/xdg) 의 kime/layouts/ 에서도 레이아웃을 찾는다.
      environment.etc."xdg/kime/layouts/my-dubeolsik.yaml".source = ./kime-my-dubeolsik.yaml;
      #    enabled = "fcitx5";
      #    fcitx5.addons = with pkgs; [
      #        fcitx5-hangul
      #        fcitx5-gtk
      #    ];
      #  };
    };
}
