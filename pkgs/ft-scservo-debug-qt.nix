{ lib
, stdenv
, fetchFromGitHub
, qt5
}:

stdenv.mkDerivation rec {
  pname = "ft-scservo-debug-qt";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Kotakku";
    repo = "FT_SCServo_Debug_Qt";
    rev = "v${version}";
    hash = "sha256-vsKDAOiec5jN+WTv2/tlarzLI6rt7/w2QMi707tPMHo=";
  };

  nativeBuildInputs = [
    qt5.qmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtserialport
  ];

  # qmake 프로젝트 설정
  qmakeFlags = [
    "CONFIG+=release"
  ];

  # 빌드 단계
  buildPhase = ''
    runHook preBuild
    
    qmake $qmakeFlags .
    make $makeFlags
    
    runHook postBuild
  '';

  # 설치 단계
  installPhase = ''
    runHook preInstall
    
    # 실행 파일 설치
    mkdir -p $out/bin
    cp FT_SCServo_Debug_Qt $out/bin/
    
    # 데스크톱 파일 생성 (선택사항)
    mkdir -p $out/share/applications
    cat > $out/share/applications/ft-scservo-debug-qt.desktop << EOF
[Desktop Entry]
Name=FT SCServo Debug Qt
Comment=Utility for Feetech SCS/STS servo
Exec=$out/bin/FT_SCServo_Debug_Qt
Icon=application-x-executable
Terminal=false
Type=Application
Categories=Development;Electronics;
EOF
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "Utility for Feetech SCS/STS servo";
    homepage = "https://github.com/Kotakku/FT_SCServo_Debug_Qt";
    license = licenses.unfree; # 라이선스 확인 후 적절히 수정
    maintainers = [ ]; # 필요시 메인테이너 추가
    platforms = platforms.linux;
  };
}
