{
  nixConfig = {
    # current flake에 적용된다.
    extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://graham33.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-amd-ai.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "graham33.cachix.org-1:DqH72VpwSrACa3+L9eqh4bixjWx9IQUaxQtRh4gtkX8="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-amd-ai.cachix.org-1:F4OU4vw/lV2oiG6SBHZ+nqjl4EFJuqI4X9A7pvaBmhQ="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #    hyprland = {
    #      url = "github:hyprwm/Hyprland";
    #      inputs.nixpkgs.follows = "nixpkgs";
    #    };
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #hyprlock.url = "github:hyprwm/Hyprlock";
    #hyprlock.inputs.nixpkgs.follows = "nixpkgs-unstable";
    #hyprland.url = "github:hyprwm/Hyprland";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #nur.url = "github:nix-community/NUR";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jetpack-nixos.url = "github:anduril/jetpack-nixos";
    yt-x = {
      url = "github:Benexl/yt-x";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "github:herdrdev/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # 커널 6.17에 고정한다 (b04c6d090 "kernel: bump NVIDIA NV-Kernels 6.17 -> 7.0"
    # 직전 커밋). NVIDIA 7.0 커널에서는 GB10에서 CUDA가 깨진다: R595는 cuInit이
    # CUDA_ERROR_NOT_INITIALIZED로 실패하고, R615는 cuInit은 되지만 1 MiB
    # host-to-device cudaMemcpy가 무한 대기한다. 6.17.13 + R595에서는 정상이다
    # (ds4-nix의 `nix run .#cuda-probe`로 확인 가능).
    dgx-spark.url = "github:graham33/nixos-dgx-spark/ef595d9edeeb665defb0f8e121b8851542f2bfb9";
    nix-amd-ai.url = "github:noamsto/nix-amd-ai";

    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, wrappers, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [ 
        wrappers.flakeModules.wrappers 
        ./parts
      ];

      flake.wrappers.neovim = ./wrapper/neovim;
      #flake.wrappers.zsh = ./wrapper/zsh.nix;
      #flake.wrappers.tmux = ./wrapper/tmux.nix;
      #flake.wrappers.kitty = ./wrapper/kitty.nix;
      #flake.wrappers.starship = ./wrapper/starship.nix;
      #flake.wrappers.niri = ./wrapper/niri.nix;
    };
}
