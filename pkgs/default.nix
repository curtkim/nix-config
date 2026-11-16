{
  pkgs,
}:
{
  #ytsub = pkgs.callPackage ./ytsub.nix { };
  gh-find-code = pkgs.callPackage ./gh-find-code.nix { };
  deepl-cli = pkgs.callPackage ./deepl-cli.nix { };
}
