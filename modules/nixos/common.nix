{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.modules.nixos.common =
    { config, pkgs, lib, ... }:
    {
      imports = [
        nixos.user-curt
        nixos.nix
        nixos.locale
        nixos.console
        nixos.font
        #nixos.input-method
        #nixos.virtualisation
        nixos.network
        nixos.sound
        nixos.services
        #nixos.keyboard-voyager
        nixos.security
        nixos.dconf
        nixos.git
      ];

      # Enable touchpad support (enabled default in most desktopManager).
      # services.xserver.libinput.enable = true;

      #programs.zsh.enable = true;
      #programs.ssh.startAgent = true;

      users.groups.libvirt = { };


      # wrapper zsh 는 hm-session-vars 를 읽지 않으므로 시스템에서 지정한다.
      environment.variables.EDITOR = "nvim";

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        wget
        gcc

        jq
        tree
        fd
        tokei

        usbutils
        pciutils
        lshw
        nfs-utils
        wakeonlan
        ethtool
        libnotify

        # for incus
        #    distrobuilder
        #    cdrkit
        #    hivex
        #    wimlib

        home-manager

        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.neovim
        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.tmux
        # programs.zsh 의 zsh 와 bin/zsh 가 충돌한다. 로그인 셸
        # (/run/current-system/sw/bin/zsh) 이 확실히 wrapper zsh 를 가리키도록 우선순위를 올린다.
        (lib.hiPrio inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.zsh)


      ];

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "24.05"; # Did you read the comment?
    };
}
