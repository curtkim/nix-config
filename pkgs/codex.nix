{ nodejs_22, pnpm, stdenv, nodePackages, fetchFromGitHub, buildNpmPackage, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname   = "codex-cli";
  version = "unstable";

  src = fetchFromGitHub {
    owner  = "openai";
    repo   = "codex";
    rev    = "693bd59eccec671d0eef7ce53f53a753a71d9828";
    sha256 = "sha256-bdKmoWaomnlU/GyoonSfRdgWXPEn0boJjsrDJKkzaRs=";
  };

  nativeBuildInputs = [
    nodejs_22
    pnpm.configHook
  ];

  #pnpmRoot = "codex-cli";

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ja0/WO+IXd6I4yll0/5OBcFLVUijMtsx2xQ0puovOJk=";
  };

  buildPhase = ''
    pnpm install
    pnpm --filter @openai/codex run build
  '';
  
  installPhase = ''
    mkdir -p $out/bin
    cp -r codex-cli/dist/cli.js $out/bin/codex
  '';

})
