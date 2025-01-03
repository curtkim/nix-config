# Devshells configuration
{
  pkgs,
  forAllSystems,
  ...
}:
let
  # For every system, merge all devshells and inject system-specific packages
  devShells = forAllSystems (
    system:
    let
      # Define standard packages with overlays
      # Process devshell files
      imports = map (file: import file { inherit pkgs; }) [
        ./egui.nix
        ./iced.nix
        #./node.nix
        ./python-datascience.nix
        #./python.nix
        ./tauri.nix
        ./wgpu.nix
      ];
    in
    # Merge all devshell attribute sets into a single one
    builtins.foldl' (acc: shell: acc // shell) { } imports
  );
in
devShells
