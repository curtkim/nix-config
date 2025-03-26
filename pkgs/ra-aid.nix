{ lib, pkgs, fetchFromGitHub, uv2nix, pyproject-nix, pyproject-build-systems }:
let 
  src = fetchFromGitHub {
    owner = "ai-christianson";
    repo = "RA.Aid";
    rev = "v0.19.1";
    sha256 = lib.fakeHash;
  };

  workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = src; };

  python = pkgs.python312;

  pythonSet =
    (pkgs.callPackage pyproject-nix.build.packages {
      inherit python;
    }).overrideScope
      (
        lib.composeManyExtensions [
          pyproject-build-systems.overlays.default
        ]
      );

  inherit (pkgs.callPackage pyproject-nix.build.util { }) mkApplication;
in 
  mkApplication {
    venv = pythonSet.mkVirtualEnv "ra-aid-env" workspace.deps.default;
    package = pythonSet.ra-aid;
  }

