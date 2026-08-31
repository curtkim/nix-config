{ config, lib, ... }:
let
  inherit (config.flake) wrappers;
in
{
  # wrapper 들을 겹쳐 쌓아서 하나로 만든다.
  #
  #   desktop (niri)
  #     └ terminal (kitty)
  #         └ environment (zsh + 개발 도구 전부)
  #
  # flake.wrappers.* 는 이미 packages.<이름> 으로 나오므로 (parts.nix)
  # 여기 있는 것들은 "합성된" 변형이다.
  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    {
      # 데스크탑 전체가 하나의 패키지. 터미널까지 포함한다.
      packages.desktop = wrappers.niri.wrap {
        inherit pkgs;
        terminal = lib.getExe self'.packages.terminal;
        env.EDITOR = lib.getExe self'.packages.neovim;
      };

      # 기본 터미널. 셸로 packages.environment 를 띄운다.
      packages.terminal = wrappers.kitty.wrap {
        inherit pkgs;
        shell = lib.getExe self'.packages.environment;
      };

      # 기본 셸 + 개발 도구 전부.
      packages.environment = wrappers.zsh.wrap {
        inherit pkgs;
        runtimePkgs = [
          # nix
          pkgs.nh

          # other
          pkgs.file
          pkgs.unzip
          pkgs.zip
          pkgs.p7zip
          pkgs.wget
          pkgs.killall
          pkgs.sshfs
          pkgs.fzf
          pkgs.htop
          pkgs.btop
          pkgs.eza
          pkgs.fd
          pkgs.zoxide
          pkgs.dust
          pkgs.ripgrep
          pkgs.fastfetch # neofetch 는 nixpkgs 에서 제거됨
          pkgs.tree-sitter
          pkgs.imagemagick
          pkgs.imv
          pkgs.ffmpeg-full
          pkgs.yt-dlp
          pkgs.lazygit
          pkgs.yazi # 원본의 lf 자리. 이 저장소는 yazi 를 쓴다
          pkgs.git

          # wrapped
          self'.packages.neovim
          self'.packages.tmux
          self'.packages.starship
          self'.packages.nix-check-bin
        ];
        env.EDITOR = lib.getExe self'.packages.neovim;
      };

      packages.nix-check-bin = pkgs.writeShellApplication {
        name = "nix-check-bin";
        text = ''
          $EDITOR "$(nix build "$1" --no-link --print-out-paths)/bin"
        '';
      };
    };
}
