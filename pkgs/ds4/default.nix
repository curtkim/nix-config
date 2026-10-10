# ds4 (DwarfStar, https://github.com/antirez/ds4) for DGX Spark (GB10, sm_121a).
#
# `pkgs` must be its own nixpkgs instance, not the system one: CUDA 13.3 is
# needed for compute_121a/sm_121a, and the CUDA redistributables are unfree.
# parts/shared.nix builds it as ds4For:
#   config = { allowUnfree = true; cudaSupport = true; cudaCapabilities = [ "12.1" ]; };
#
# Both TP peers must run the same commit (upstream docs/DISTRIBUTED.md); src is
# pinned here, so both Sparks get the same store path.
{ pkgs }:
let
  cudaPackages = pkgs.cudaPackages_13_3;

  ds4 = pkgs.callPackage ./ds4.nix {
    inherit cudaPackages;
    version = "0-unstable-2026-10-07";
    # fetchTree, not fetchFromGitHub: same fetcher a `github:` flake input uses,
    # so src is a plain store path and the ds4 store path matches the build
    # already on the Sparks (fetchFromGitHub adds a .drv input and changes it).
    # Bump rev and narHash together.
    src = builtins.fetchTree {
      type = "github";
      owner = "antirez";
      repo = "ds4";
      rev = "fc80bd695da76ee14bcb86820bf900a5cdfda806";
      narHash = "sha256-0e9pONUeb93KDlPbAzUjK7pLgyqGhg0mWkKnvc1Ty5k=";
    };
    # nvcc needs a host compiler it supports; backendStdenv is that one.
    stdenv = cudaPackages.backendStdenv;
  };

  tools = pkgs.callPackage ./spark-tools.nix {
    inherit ds4;
    huggingface-hub = pkgs.python3Packages.huggingface-hub;
  };
in
{
  inherit ds4;
  inherit (tools)
    ds4-driver-libs
    ds4-model-download
    ds4-spark-preflight
    ds4-spark-coordinator
    ds4-spark-worker
    ;
}
