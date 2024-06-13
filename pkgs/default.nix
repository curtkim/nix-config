# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  ytsub = pkgs.callPackage ./ytsub.nix { };
  ripgrep = pkgs.callPackage ./ripgrep.nix { };
}
