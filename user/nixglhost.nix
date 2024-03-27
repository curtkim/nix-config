{
  description = "nix-gl-host flake";

  inputs = {
    nix-gl-host.url = "github:numtide/nix-gl-host";
  };

  outputs = { self, nixpkgs, nix-gl-host }: {
    packages.x86_64-linux.nix-gl-host = nix-gl-host.defaultPackage.x86_64-linux;
  };
}
