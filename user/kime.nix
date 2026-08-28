{ pkgs, lib, ... }: {

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

  # home-manager 기본 유닛은 Type=oneshot + kime 자체 daemonize라 systemd가
  # 실제 데몬 프로세스를 추적하지 못한다. 그 결과 컴포지터가 재시작돼도 낡은
  # 데몬이 남아 pid 락으로 새 기동을 막고, Wayland 모듈이 죽은 채로 방치된다.
  systemd.user.services.kime-daemon.Service = {
    Type = lib.mkForce "simple";
    RemainAfterExit = lib.mkForce false;
    ExecStart = lib.mkForce "${pkgs.kime}/bin/kime -D";
    Restart = "on-failure";
  };

}
