{ lib
, buildPythonPackage
, fetchFromGitHub
, pillow
, kdtree
, setuptools
}:

buildPythonPackage rec {
  pname = "climage";
  version = "0.2.0"; # 실제 버전은 dynamic하게 가져오도록 되어있으나, Nix에서는 명시적인 버전이 필요합니다

  src = fetchFromGitHub {
    owner = "pnappa";
    repo = "CLImage";
    rev = version;
    sha256 = "sha256-XPcJFm9RG4aoofgbQUurxtFet5H24FAgLq83NDG4YPQ=";
  };

  propagatedBuildInputs = [
    pillow
    kdtree
  ];

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [ "climage" ];

  meta = with lib; {
    description = "Convert images to beautiful ANSI escape codes";
    homepage = "https://github.com/pnappa/CLImage";
    license = licenses.mit;
    maintainers = with maintainers; [ ]; # 필요한 경우 메인테이너를 추가하세요
    platforms = platforms.all;
    pythonPackages = [ # 파이썬 버전 호환성 명시
      "python3"
    ];
  };
}
