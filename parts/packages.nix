{ inputs, ... }:
let
  shared = import ./shared.nix { inherit inputs; };
  inherit (shared) overlays commonPkgsConfig;
in
{
  # `nix flake show` / `nix build .#<name>` 으로 pkgs/ 의 커스텀 패키지를 노출한다.
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system overlays;
        config = commonPkgsConfig;
      };
    in
    {
      packages = import ../pkgs { inherit pkgs; };
    };
}
