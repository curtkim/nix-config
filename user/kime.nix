{

  # tail -f /run/user/1000/kime.err
  # cat ~/.config/kime/config.yaml
  i18n.inputMethod.enable = true;
  i18n.inputMethod.type = "kime";
  #i18n.inputMethod.kime.iconColor = "White";
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

  xdg.configFile."kime/layouts/my-dubeolsik.yaml".source = ./kime-my-dubeolsik.yaml;

}
