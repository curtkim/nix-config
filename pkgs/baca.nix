{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, poetry-core
# runtime dependencies
, textual
, beautifulsoup4
, markdownify
, appdirs
, peewee
, fuzzywuzzy
, climage
# dev dependencies
, black
, isort
, ipython
, pytest
, ipdb
}:

buildPythonPackage rec {
  pname = "baca";
  version = "0.1.17";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "wustho";
    repo = "baca";
    rev = "v${version}";  # 적절한 git tag를 사용하세요
    sha256 = "sha256-uiMzXqA52atees5tHC5Vqk3ALojkJZ8ouivo+omBnlM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    textual
    beautifulsoup4
    markdownify
    appdirs
    peewee
    fuzzywuzzy
    climage
    setuptools
  ];

  checkInputs = [
    black
    isort
    ipython
    pytest
    ipdb
  ];

  pythonImportsCheck = [ "baca" ];

  # src/baca 디렉토리의 패키지 구조를 위한 설정
  #sourceRoot = "source/src";

  pythonRelaxDeps = [
    "textual"
    "markdownify"
  ];

  meta = with lib; {
    description = "TUI Ebook Reader";
    homepage = "https://github.com/benawad/baca";  # 실제 GitHub 저장소 URL로 수정하세요
    license = licenses.gpl3;
    maintainers = with maintainers; [ ]; # 필요한 경우 메인테이너를 추가하세요
    platforms = platforms.all;
  };
}
