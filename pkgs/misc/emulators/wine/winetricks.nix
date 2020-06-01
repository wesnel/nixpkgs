{ stdenv, callPackage, wine, perl, which, coreutils, zenity, curl
, cabextract, unzip, p7zip, gnused, gnugrep, bash } :

stdenv.mkDerivation rec {
  name = "winetricks-${src.version}";

  src = (callPackage ./sources.nix {}).winetricks;

  buildInputs = [ perl which ];

  # coreutils is for sha1sum
  pathAdd = stdenv.lib.concatMapStringsSep ":" (x: x + "/bin")
    [ wine perl which coreutils zenity curl cabextract unzip p7zip gnused gnugrep bash ];

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = false; # requires "bashate"

  postInstall = ''
    sed -i \
      -e '2i PATH="${pathAdd}:$PATH"' \
      "$out/bin/winetricks"
  '';

  meta = {
    description = "A script to install DLLs needed to work around problems in Wine";
    license = stdenv.lib.licenses.lgpl21;
    homepage = "https://github.com/Winetricks/winetricks";
    platforms = with stdenv.lib.platforms; linux;
  };
}
