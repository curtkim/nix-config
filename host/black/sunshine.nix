{ config, pkgs, ... }:
{
  # Moonlight(um790) 에서 접속하는 게임/데스크탑 스트리밍 호스트.
  #
  # sunshine 은 systemd *user* service 로 뜨고 graphical-session.target 에
  # 묶여 있다. console 로그인 후 start-hyprland 로 들어가도 home-manager 의
  # hyprland systemd 연동(hyprland-session.target -> graphical-session.target)
  # 이 target 을 올려주므로 세션에 들어가는 순간 자동으로 시작된다.
  # 즉 GUI 세션이 없는 동안은 sunshine 도 없다 (= 접속 불가).
  services.sunshine = {
    enable = true;
    autoStart = true;
    openFirewall = true; # TCP 47984/47989/47990/48010, UDP 47998-48010
    capSysAdmin = true;  # wayland(hyprland) 화면 캡쳐는 DRM/KMS 경로 -> CAP_SYS_ADMIN 필요
  };

  # /dev/uinput (가상 키보드/마우스/패드) 접근.
  # hardware.uinput.enable 은 sunshine 모듈이 켜주지만 group 가입은 직접 해야 한다.
  users.users.curt.extraGroups = [ "uinput" ];
}
