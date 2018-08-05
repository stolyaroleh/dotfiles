{ mkDerivation, base, containers, data-default, directory
, extensible-exceptions, filepath, mtl, process, QuickCheck
, semigroups, setlocale, stdenv, unix, utf8-string, X11
}:
mkDerivation {
  pname = "xmonad";
  version = "0.14";
  sha256 = "a456d091373e8d5cd7635917171763b1216814aea4a476b9ceb9cb7315980353";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    base containers data-default directory extensible-exceptions
    filepath mtl process semigroups setlocale unix utf8-string X11
  ];
  executableHaskellDepends = [ base mtl unix X11 ];
  testHaskellDepends = [
    base containers extensible-exceptions QuickCheck X11
  ];
  postInstall = ''
    shopt -s globstar
    mkdir -p $doc/share/man/man1
    mv "$data/"**"/man/"*[0-9] $doc/share/man/man1/
    rm "$data/"**"/man/"*
  '';
  homepage = "http://xmonad.org";
  description = "A tiling window manager";
  license = stdenv.lib.licenses.bsd3;
}
