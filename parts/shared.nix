{ inputs }:
let
  inherit (inputs) nixpkgs rust-overlay;
in
{
  overlays = [
    (import rust-overlay)
    (
      final: prev:
      import ../pkgs { pkgs = prev; }
    )
    inputs.firefox-addons.overlays.default
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

  xavierCudaPkgsConfig = {
    allowUnfree = true;
    nvidia.acceptLicense = true;
    cudaSupport = true;
    cudaCapabiligies = [ "7.2" ];
  };

  # ds4 (pkgs/ds4) 전용 nixpkgs: unstable + CUDA 13.3, GB10(sm_121).
  # 시스템 nixpkgs(26.05)와 분리해서 CUDA 버전과 store path를 고정한다.
  ds4For =
    system:
    import ../pkgs/ds4 {
      pkgs = import inputs.nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
          cudaSupport = true;
          cudaCapabilities = [ "12.1" ];
        };
      };
    };

  specialArgs = {
    hostName = "none";
    userName = "curt";
    nixpkgs = nixpkgs;
    disko = inputs.disko;
    jetpack-nixos = inputs.jetpack-nixos;
    inherit inputs;
  };
}
