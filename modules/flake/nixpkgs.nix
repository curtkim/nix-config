# nixpkgs 설정 (overlays, unfree 허용 목록 등).
#
# nixpkgs-common 은 common 모듈이 import 하고 (호스트가 직접 import 하지 않아도 된다),
# nixpkgs-cuda 는 그 위에 cuda 설정만 더한다.
# flake 의 packages 출력(pkgs/)도 같은 설정으로 빌드한다.
{ inputs, config, ... }:
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
        "broadcom-sta" # silver 의 Wi-Fi 드라이버
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

  # nixpkgs.config 는 여러 정의를 재귀적으로 합치므로 cuda 설정만 더하면 된다.
  flake.modules.nixos.nixpkgs-cuda = {
    imports = [ config.flake.modules.nixos.nixpkgs-common ];
    nixpkgs.config = cudaPkgsConfig;
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
