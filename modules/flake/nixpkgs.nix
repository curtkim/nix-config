# nixpkgs 설정 (overlays, unfree 허용 목록 등).
#
# 호스트는 flake.modules.nixos.nixpkgs-common / nixpkgs-cuda 를 import 하고,
# flake 의 packages 출력(pkgs/)도 같은 설정으로 빌드한다.
{ inputs, ... }:
let
  inherit (inputs) nixpkgs rust-overlay;

  overlays = [
    (import rust-overlay)
    (
      final: prev:
      import ../../pkgs { pkgs = prev; }
    )
    inputs.firefox-addons.overlays.default
    inputs.helium-flake.overlays.default
  ];

  commonPkgsConfig = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (nixpkgs.lib.getName pkg) [
        "immersive-translate"
        "samsung-unified-linux-driver"
        "amp-cli"
        "google-chrome"
        "claude-code"
        "fastflowlm"
      ];
    permittedInsecurePackages = [
      "freeimage-unstable-2021-11-01"
      "immersive-translate-1.33.3"
    ];
  };

  cudaPkgsConfig = {
    allowUnfree = true;
    nvidia.acceptLicense = true;
    cudaSupport = true;
    cudaCapabilities = [ "8.6" ];
  };
in
{
  flake.modules.nixos.nixpkgs-common = {
    nixpkgs.config = commonPkgsConfig;
    nixpkgs.overlays = overlays;
  };

  flake.modules.nixos.nixpkgs-cuda = {
    nixpkgs.config = commonPkgsConfig // cudaPkgsConfig;
    nixpkgs.overlays = overlays;
  };

  # `nix build .#<name>` 으로 pkgs/ 의 커스텀 패키지를 노출한다.
  perSystem =
    { system, ... }:
    let
      pkgs = import nixpkgs {
        inherit system overlays;
        config = commonPkgsConfig;
      };
    in
    {
      packages = import ../../pkgs { inherit pkgs; };
    };
}
