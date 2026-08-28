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
      "immersive-translate-1.30.2"
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

  specialArgs = {
    hostName = "none";
    userName = "curt";
    nixpkgs = nixpkgs;
    disko = inputs.disko;
    jetpack-nixos = inputs.jetpack-nixos;
    inherit inputs;
  };
}
