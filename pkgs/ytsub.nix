{ lib
, rustPlatform
, fetchFromGitHub
, sqlite
}:

rustPlatform.buildRustPackage rec {
  pname = "ytsub";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "sarowish";
    repo = "ytsub";
    rev = "v${version}";
    hash = "sha256-Ym1LlqSBuhBxGwGhhQIeWrPKZb2cf5cMfoFamECK4TA=";
  };

  cargoHash = "sha256-TweinTx4/rp8q3Yw2ewe04WWXMuKv2DK7ou3M/Jbdgw=";

  buildInputs = [
    sqlite
  ];

  doCheck = false;

  meta = with lib; {
    description = "A subscriptions only TUI Youtube client that uses the Invidious API";
    homepage = "https://siriusmart.github.io/youtube-tui";
    license = licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "ytsub";
  };
}
