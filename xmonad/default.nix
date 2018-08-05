{ compiler ? "ghc822"
}:
let
  config = {
    packageOverrides = pkgs: rec {
      haskell = pkgs.haskell // {
        packages = pkgs.haskell.packages // {
          "${compiler}" = pkgs.haskell.packages.${compiler}.override {
            overrides = self: super: with self; {
              xmonad = callPackage ./xmonad.nix {};
              xmonad-contrib = callPackage ./xmonad-contrib.nix {};
              xmonad-extras = callPackage ./xmonad-extras.nix {};
            };
          };
        };
      };
    };
  };
  nixpkgs = import <nixpkgs> { inherit config; };
in
  nixpkgs.pkgs.haskell.packages.${compiler}.callPackage ./xmonad-config.nix {}
