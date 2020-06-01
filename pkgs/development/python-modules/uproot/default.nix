{ lib, fetchPypi, buildPythonPackage, isPy27
, awkward
, backports_lzma
, cachetools
, lz4
, pandas
, pytestrunner
, pytest
, pkgconfig
, mock
, numpy
, requests
, uproot-methods
, xxhash
}:

buildPythonPackage rec {
  pname = "uproot";
  version = "3.11.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05bb55d0576813bb7bf252654cf854fcbabe34e30eb99beb70eff6abc4d3f121";
  };

  nativeBuildInputs = [ pytestrunner ];

  checkInputs = [
    lz4
    mock
    pandas
    pkgconfig
    pytest
    requests
    xxhash
  ] ++ lib.optional isPy27 backports_lzma;

  propagatedBuildInputs = [
    numpy
    cachetools
    uproot-methods
    awkward
  ];

  # skip tests which do network calls
  # test_compression.py is missing zstandard package
  checkPhase = ''
    pytest tests -k 'not hist_in_tree \
      and not branch_auto_interpretation' \
      --ignore=tests/test_compression.py
  '';

  meta = with lib; {
    homepage = "https://github.com/scikit-hep/uproot";
    description = "ROOT I/O in pure Python and Numpy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ktf ];
  };
}
