{ lib, pkgs, fetchFromGitHub }:

pkgs.buildGoModule {
  pname = "mcphost";
  version = "0.4.2";

  # 레포지토리 소스 가져오기
  src = fetchFromGitHub {
    owner = "mark3labs";
    repo = "mcphost";
    rev = "v0.4.2"; # 또는 특정 커밋 해시
    sha256 ="sha256-0kLgv9odLl1L6Tg2Ly7BvOpaLuMeRPMmclXjl68Qfeo=";
  };

  # 빌드에 필요한 모듈 활성화
  #modSha256 = lib.fakeSha256;
  vendorHash = "sha256-fl/i1MS4pK/U+7n9fqmP0qmF8QOldZsZ/wB5r8VWgVg="; #lib.fakeHash;

  # 실행 파일 설치
  installPhase = ''
    mkdir -p $out/bin
    mv $GOPATH/bin/* $out/bin/
  '';

  # 실행 가능한 바이너리 생성
  doInstallCheck = false;
  doCheck = false; # 테스트가 있으면 true로 변경 가능
}
