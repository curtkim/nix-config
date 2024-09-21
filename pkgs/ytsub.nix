{ lib
, rustPlatform
, fetchFromGitHub
, sqlite
}:

rustPlatform.buildRustPackage rec {
  pname = "ytsub";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "sarowish";
    repo = "ytsub";
    rev = "v${version}";
    hash = "sha256-juYxzRlQ8U1qnO0YzVcWcQu/1exjoDSSaAcUkYurRIQ=";
  };

  cargoHash = "sha256-pv4eKD2XgaDAJqSf3JzfnsayofmOSy4XRzZ8rkZrHAo=";

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
