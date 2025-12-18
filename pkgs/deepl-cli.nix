{ lib, stdenv, fetchFromGitHub, crystal, shards, openssl, pkg-config, git, cacert, readline }:

let
  version = "0.4.12";

  src = fetchFromGitHub {
    owner = "kojix2";
    repo = "deepl-cli";
    rev = "v${version}";
    hash = "sha256-4ME0d8vczSS1N2FIoOy4DdDIf5G2PkvGMkdK4TIBaGQ=";
  };

  # Fetch shards dependencies as a fixed-output derivation
  shardsDeps = stdenv.mkDerivation {
    name = "deepl-cli-shards-${version}";
    inherit src;

    nativeBuildInputs = [ crystal shards git cacert ];

    buildPhase = ''
      export HOME=$TMPDIR
      shards install --production
    '';

    installPhase = ''
      mkdir -p $out
      cp -r lib $out/
      cp shard.lock $out/
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-lI/tkOGodXDo+wUBpDI8ZolpaMIIFkH5LUC8cpSwsYk=";
  };
in
stdenv.mkDerivation rec {
  pname = "deepl-cli";
  inherit version src;

  nativeBuildInputs = [ crystal shards pkg-config ];
  buildInputs = [ openssl readline ];

  buildPhase = ''
    runHook preBuild

    # Copy pre-fetched dependencies
    cp -r ${shardsDeps}/lib .
    cp ${shardsDeps}/shard.lock .

    shards build --release --no-debug

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/deepl $out/bin/deepl

    runHook postInstall
  '';

  meta = with lib; {
    description = "DeepL CLI - command line tool for DeepL translation API";
    homepage = "https://github.com/kojix2/deepl-cli";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.linux;
  };
}
