{

  # tail -f /run/user/1000/kime.err
  # cat /etc/xdg/kime/config.yaml
  i18n.inputMethod.enabled = "kime";
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
        # tmux move pane hotkeys(Ctrl+ jkhl)
        C-j:
          behavior: Ignore
          result: Bypass
        C-k:
          behavior: Ignore
          result: Bypass
        C-h:
          behavior: Ignore
          result: Bypass
        C-l:
          behavior: Ignore
          result: Bypass
  '';

  #  i18n.inputMethod = {
  #    enabled = "fcitx5";
  #    fcitx5.addons = with pkgs; [
  #        fcitx5-hangul
  #        fcitx5-gtk
  #    ];
  #  };
}
