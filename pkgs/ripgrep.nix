{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ripgrep";
  version = "14.1.0";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = pname;
    rev = version;
    hash = "sha256-CBU1GzgWMPTVsgaPMy39VRcENw5iWRUrRpjyuGiZpPI=";
  };

  cargoHash = "sha256-8FxN5MhYduMkzym7Xx4dnVbWaBKv9pgbXMIRGiRRQew=";

  #doCheck = false;

  meta = {
    description = "A fast line-oriented regex search tool, similar to ag and ack";
    homepage = "https://github.com/BurntSushi/ripgrep";
    license = lib.licenses.unlicense;
    maintainers = [ ];
  };
}
