{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
  shared = import ../../../parts/shared.nix { inherit inputs; };
in
{
  flake.nixosConfigurations.um790 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      {
        nixpkgs.config = shared.commonPkgsConfig;
        nixpkgs.overlays = shared.overlays;
      }
      (
        # Edit this configuration file to define what should be installed on
        # your system.  Help is available in the configuration.nix(5) man page
        # and in the NixOS manual (accessible by running ‘nixos-help’).

        {
          config,
          pkgs,
          ...
        }:

        {
          imports = [
            nixos.boot
            inputs.disko.nixosModules.disko
            ./_disko-config.nix
            ./_hardware-configuration.nix
            nixos.amd
            nixos.common
            nixos.desktop
            nixos.minidlna
            nixos.jellyfin
            nixos.xserver
            nixos.printing
            nixos.upower
            #../printing-client.nix
            ./_nfs-client.nix
            nixos.so101-serial
            nixos.nix-distributed-build-machine
            nixos.android-dev
            nixos.keyboard-totem
            nixos.keyboard-cheapiano
            nixos.platformio-udev
            nixos.helium
            nixos.hikrobot-camera
          ];

          networking.hostName = "um790"; # Define your hostname.

          # 스왑 없이는 메모리 압박 시 systemd-oomd가 프로세스를 못 죽이고
          # 시스템 전체가 멈춘다(2026-10-18 무응답 재부팅 재발 방지).
          # 루트(990 PRO NVMe, ext4)에 스왑파일 생성 — 부팅 시 자동 생성됨.
          swapDevices = [ { device = "/swapfile"; size = 16384; } ]; # MiB = 16 GiB

          # black(sunshine) 에 접속하는 moonlight 클라이언트
          # environment.systemPackages = [ pkgs.moonlight-qt ];

          # bluetooth
          hardware.bluetooth.enable = true;
          hardware.bluetooth.powerOnBoot = true;

          services.blueman.enable = true;


          services.harmonia.cache = {
            enable = true;
            signKeyPaths = [ ./nix-serve-priv-key.pem ];
            settings.bind = "0.0.0.0:5000";
          };
          networking.firewall.allowedTCPPorts = [ 5000 ];

          # services.nix-serve = {
          #   enable = true;
          #   openFirewall = true;
          #   secretKeyFile = "${./nix-serve-priv-key.pem}";
          # };

          boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

          # Enable QEMU user-mode emulation for cross-architecture builds
          # too slow
          #boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

          # xlnx-utils 을 위해
          nix.settings.extra-sandbox-paths = [ "/dev/fuse" ];
        }
      )
    ];
  };
}
