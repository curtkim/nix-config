{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "gh-find-code";
  version = "1.0.0";

  # GitHub에서 스크립트를 가져옵니다.
  src = fetchFromGitHub {
    owner = "LangLangBart";
    repo = "gh-find-code";
    rev = "main";  # 특정 커밋이나 브랜치로 고정 가능
    hash = "sha256-3i1wmZnVDr+aK3asaCSMhw0dw0kh2rRAP16d5/yq+tE="; #"sha256-PLACEHOLDER"; # `nix-build` 실행 시 정확한 값을 대체
  };

  # 빌드 단계
  buildPhase = ''
    mkdir -p $out/bin
    cp gh-find-code $out/bin/gh-find-code
    chmod +x $out/bin/gh-find-code
  '';

  # 메타데이터
  meta = with lib; {
    description = "A bash script to find code using the GitHub API";
    homepage = "https://github.com/LangLangBart/gh-find-code";
    license = licenses.mit;
    maintainers = [ maintainers.yourname ];
  };
}
