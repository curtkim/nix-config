{ config, pkgs, inputs, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.curt = {
    isNormalUser = true;
    description = "curt";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "video"
      "render"
      "libvirt"
      "adbusers"
      "kvm"
    ];
    packages = with pkgs; [
    ];
    # wrapper/zsh.nix 로 만든 zsh. 설정이 store 에 묶여 있어 ~/.zshrc 를 읽지 않는다.
    shell = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.zsh;
  };

  # /etc/zshenv (NixOS 환경변수, completion 경로) 를 위해 유지한다.
  programs.zsh.enable = true;
}
