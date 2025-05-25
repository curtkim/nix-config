{pkgs, uv2nix, pyproject-nix, pyproject-build-systems}:
let
  kdtree = pkgs.python3Packages.callPackage ./kdtree.nix {};
  climage = pkgs.python3Packages.callPackage ./climage.nix {
    kdtree = kdtree;
  };
in {
  ytsub = pkgs.callPackage ./ytsub.nix { };
  #ripgrep = pkgs.callPackage ./ripgrep.nix { };
  #vivado-2022_2 = pkgs.callPackage ./vivado-2022_2.nix { };
  #claude-engineer = pkgs.callPackage ./claude-engineer.nix { };
  #openxlab = pkgs.callPackage ./openxlab.nix { };
  gh-find-code = pkgs.callPackage ./gh-find-code.nix { };
  mcphost = pkgs.callPackage ./mcphost.nix {};
  #shader-slang = pkgs.callPackage ./shader-slang.nix {};
  #luisa-compute = pkgs.callPackage ./luisa-compute.nix {};
  #luisa-render = pkgs.callPackage ./luisa-render.nix {};
  #taichi = pkgs.callPackage ./taichi.nix {};

  baca = pkgs.python3Packages.callPackage ./baca.nix {
    climage = climage;
  };
  #pdfposter = pkgs.python3Packages.callPackage ./pdfposter.nix {};
  #ra-aid = pkgs.callPackage ./ra-aid.nix {
    #uv2nix = uv2nix;
    #pyproject-nix = pyproject-nix;
    #pyproject-build-systems = pyproject-build-systems;
  #};
  codex = pkgs.callPackage ./codex.nix {};
}

