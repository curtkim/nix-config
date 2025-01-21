{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, setuptools
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "kdtree";
  # 실제 버전은 kdtree.py에서 동적으로 읽어오지만, 
  # Nix에서는 명시적인 버전이 필요합니다
  version = "0.16"; # 적절한 버전으로 수정해주세요

  src = fetchFromGitHub {
    owner = "stefankoegl";
    repo = "kdtree";
    rev = "v" + version;
    sha256 = "sha256-hWJK5vk9a7jczhcN7FHRjYhm8pUZFeB5ttqHfnCLFQw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "kdtree" ];

  # Python 2.x 지원이 필요한 경우를 위한 조건부 설정
  disabled = pythonOlder "2.6";
  doCheck = false;

  meta = with lib; {
    description = "A simple implementation of a kdtree for points"; # kdtree.py의 docstring에서 가져온 설명으로 수정하세요
    homepage = "http://github.com/stefankoegl/kdtree";  # WEBSITE 변수 값으로 수정하세요
    license = licenses.isc;  # ISC License
    maintainers = with maintainers; [ ]; # 필요한 경우 메인테이너를 추가하세요
    platforms = platforms.all;
    classifiers = [
      "Development Status :: 5 - Production/Stable"
      "Intended Audience :: Developers"
      "License :: OSI Approved :: ISC License (ISCL)"
      "Operating System :: OS Independent"
      "Programming Language :: Python"
      "Programming Language :: Python :: 2"
      "Programming Language :: Python :: 2.6"
      "Programming Language :: Python :: 2.7"
      "Programming Language :: Python :: 3"
      "Programming Language :: Python :: 3.3"
      "Programming Language :: Python :: 3.4"
      "Programming Language :: Python :: 3.5"
      "Programming Language :: Python :: 3.6"
      "Programming Language :: Python :: Implementation :: CPython"
      "Programming Language :: Python :: Implementation :: PyPy"
      "Topic :: Software Development :: Libraries"
      "Topic :: Utilities"
    ];
  };
}
