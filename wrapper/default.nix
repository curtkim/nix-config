# 각 파일이 flake-parts 모듈로 flake.wrappers.<이름> 을 정의한다.
# 다른 wrapper 는 flake-parts 의 config.flake.wrappers.<이름> 으로 참조한다.
{
  imports = [
    ./kitty.nix
    ./mango
    ./neovim
    ./tmux.nix
    ./zsh.nix
  ];
}
