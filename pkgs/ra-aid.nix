{ lib, pkgs, fetchFromGitHub, uv2nix, pyproject-nix, pyproject-build-systems }:
let 
  src = fetchFromGitHub {
    owner = "ai-christianson";
    repo = "RA.Aid";
    rev = "v0.19.1";
    sha256 = "sha256-fgEm1OqLiFDdU7mdtNBtiNbbMWttGaZDiJMUUmHAD5I=";
  };

  workspace = uv2nix.lib.workspace.loadWorkspace { 
    workspaceRoot = "${src}"; 
  };

  overlay = workspace.mkPyprojectOverlay { 
    sourcePreference = "wheel";
  };
  python = pkgs.python312;

  hacks = pkgs.callPackage pyproject-nix.build.hacks {};
  pyprojectOverrides = (_final: _prev: {
    peewee = _prev.peewee.overrideAttrs (attrs: ({
      buildInputs = attrs.buildInputs or [ ] ++ [ _final.setuptools ];
    }));

    httpx-sse = hacks.nixpkgsPrebuilt {
      from = python.pkgs.httpx-sse;
      prev = {
        passthru = {};
      };
    };
    pillow = hacks.nixpkgsPrebuilt {
      from = python.pkgs.pillow;
      prev = {
        passthru = {};
      };
    };

    fireworks-ai = python.pkgs.buildPythonPackage {
      pname = "fireworks-ai";
      version = "0.15.12";  # Use the appropriate version

      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/0d/47/db86fba6ef53da08488917a18cbe55b913c8b60275a7f20484ffc73a969c/fireworks_ai-0.15.12-py3-none-any.whl";
        hash = "sha256-P78/ieZcz8RsiLcSRrnU/fMwGVWsQFAZPY9LQFjLGTo=";
      };
      format = "wheel";
      #propagatedBuildInputs = with _final; [ ];
    };

    langchain-fireworks = python.pkgs.buildPythonPackage {
      pname = "langchian-fireworks";
      version = "0.2.8";  # Use the appropriate version

      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/09/84/313229d0425acf1bd81eb3bc219d1812eb624ca452f7e65b2ad3a1c8c283/langchain_fireworks-0.2.8-py3-none-any.whl";
        hash = "sha256-WLfLuqHjXYpZ79N6RhweVMIPVj8vjs98I8r32Z5xMu4=";
      };
      format = "wheel";
    };

    langchain-groq = python.pkgs.buildPythonPackage {
      pname = "langchian-groq";
      version = "0.3.1";  # Use the appropriate version

      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ca/d8/7166413d50ad06c84a5f59e5fe097cc1c3e05f5aed594d8e42d247b07aa6/langchain_groq-0.3.1-py3-none-any.whl";
        hash = "sha256-VzzPOb1O0oIKjPwHplzWer3IPQF6QDNSaSduSG5Ilpc=";
      };
      format = "wheel";
    };

    ra-aid = _prev.ra-aid.overrideAttrs (attrs: ({
      passthru = attrs.passthru // {
        dependencies = attrs.passthru.dependencies // {
          fireworks-ai = [];
          langchain-fireworks = [];
          langchain-groq = [];
          httpx-sse = [];
          pillow = [];
        };
      };
      #propagatedBuildInputs = attrs.propagatedBuildInputs or [ ] ++ [ _final.fireworks-ai ];
    }));
  });

  pythonSet =
    (pkgs.callPackage pyproject-nix.build.packages {
      inherit python;
    }).overrideScope
      (
        lib.composeManyExtensions [
          pyproject-build-systems.overlays.default
          overlay
          pyprojectOverrides 
        ]
      );

  inherit (pkgs.callPackage pyproject-nix.build.util { }) mkApplication;
in 
  mkApplication {
    venv = pythonSet.mkVirtualEnv "ra-aid-env" workspace.deps.default;
    package = pythonSet.ra-aid;
  }

