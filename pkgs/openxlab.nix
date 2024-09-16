{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "openxlab";
  version = "0.1.1";
  #format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZZyYbtUeEu6xRaTEm9338GYIZ3dpc7/ZMfg0P0qGTnU=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
  ];

  pythonImportsCheck = [ "openxlab" ];

  meta = with lib; {
    description = "";
    homepage = "";
    license = lib.licenses.unlicense;
    maintainers = with maintainers; [ ];
    mainProgram = "openxlab";
  };
}
