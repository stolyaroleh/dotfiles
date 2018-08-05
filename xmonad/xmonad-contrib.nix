{ mkDerivation, base, bytestring, containers, directory
, extensible-exceptions, filepath, mtl, old-locale, old-time
, process, random, semigroups, stdenv, unix, utf8-string, X11
, X11-xft, xmonad
}:
mkDerivation {
  pname = "xmonad-contrib";
  version = "0.14";
  sha256 = "deccbc44f19977fc860024d2eb2ff63b5856058e3b078d16c234bb05fbe0c098";
  libraryHaskellDepends = [
    base bytestring containers directory extensible-exceptions filepath
    mtl old-locale old-time process random semigroups unix utf8-string
    X11 X11-xft xmonad
  ];
  homepage = "http://xmonad.org/";
  description = "Third party extensions for xmonad";
  license = stdenv.lib.licenses.bsd3;
}
