# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  ytsub = pkgs.callPackage ./ytsub.nix { };
  ripgrep = pkgs.callPackage ./ripgrep.nix { };
  vivado-2022_2 = pkgs.callPackage ./vivado-2022_2.nix { };
}
