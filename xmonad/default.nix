let
  sources = import ../nixos/nix/sources.nix;
in
  with import sources.stable {};
  haskellPackages.developPackage {
    root = ./.;
  }
