{ mkDerivation, alsa-mixer, base, bytestring, containers, hint
, libmpd, mtl, network, regex-posix, stdenv, X11, xmonad
, xmonad-contrib
}:
mkDerivation {
  pname = "xmonad-extras";
  version = "0.14";
  sha256 = "2eb5b102b000fc389ccdcef880a2c0e773cfaaa1e655ba211cbbe5cc30623ddc";
  configureFlags = [
    "-f-with_hlist" "-fwith_parsec" "-fwith_split"
  ];
  libraryHaskellDepends = [
    alsa-mixer base bytestring containers hint libmpd mtl network
    regex-posix X11 xmonad xmonad-contrib
  ];
  homepage = "https://github.com/xmonad/xmonad-extras";
  description = "Third party extensions for xmonad with wacky dependencies";
  license = stdenv.lib.licenses.bsd3;
}
