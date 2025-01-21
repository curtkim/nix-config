{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "gh-find-code";
  version = "2025-01-06";

  # GitHub에서 스크립트를 가져옵니다.
  src = fetchFromGitHub {
    owner = "LangLangBart";
    repo = "gh-find-code";
    rev = "73a61a42dd480f6e051817ea166cfbc1defbd1c1";
    hash = "sha256-3i1wmZnVDr+aK3asaCSMhw0dw0kh2rRAP16d5/yq+tE=";
  };

  patches = [
    ./fix-query-some-bind.patch
  ];

  buildPhase = ''
    mkdir -p $out/bin
    cp gh-find-code $out/bin/gh-find-code
    chmod +x $out/bin/gh-find-code
  '';

  meta = with lib; {
    description = "A bash script to find code using the GitHub API";
    homepage = "https://github.com/LangLangBart/gh-find-code";
    license = licenses.mit;
    maintainers = [ maintainers.yourname ];
  };
}
