{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, pytest
}:

buildPythonPackage rec {
  pname = "pglast";
  version = "5.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WHFc8rXzdcRrp1U6tAuepQYagFYo8+0WQr8783w/Ql8=";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=pglast --cov-report term-missing" ""
  '';

  nativeCheckInputs = [
    pytest
  ];

  # pytestCheckHook doesn't work
  # ImportError: cannot import name 'parse_sql' from 'pglast'
  checkPhase = ''
    pytest
  '';

  pythonImportsCheck = [
    "pglast"
    "pglast.parser"
  ];

  meta = with lib; {
    homepage = "https://github.com/lelit/pglast";
    description = "PostgreSQL Languages AST and statements prettifier";
    changelog = "https://github.com/lelit/pglast/blob/v${version}/CHANGES.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ marsam ];
    mainProgram = "pgpp";
  };
}
