{ mkDerivation
, lib
, stdenv

, base
, containers
, xmonad
, xmonad-contrib
, xmonad-extras
, X11
}:
mkDerivation {
  pname = "xmonad-config";
  version = "0.0.0";
  src = lib.sourceFilesBySuffices ./. [
    ".cabal"
    ".hs"
  ];
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base
    containers
    xmonad
    xmonad-contrib
    xmonad-extras
    X11
  ];
  license = stdenv.lib.licenses.mit;
}
