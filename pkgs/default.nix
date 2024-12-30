# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  ytsub = pkgs.callPackage ./ytsub.nix { };
  ripgrep = pkgs.callPackage ./ripgrep.nix { };
  vivado-2022_2 = pkgs.callPackage ./vivado-2022_2.nix { };
  claude-engineer = pkgs.callPackage ./claude-engineer.nix { };
  openxlab = pkgs.callPackage ./openxlab.nix { };
  gh-find-code = pkgs.callPackage ./gh-find-code.nix { };
  mcphost = pkgs.callPackage ./mcphost.nix {};
}
