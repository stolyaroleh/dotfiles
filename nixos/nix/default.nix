{ ... }:
let
  sources = import ./sources.nix;
in
  {
    nix = {
      buildCores = 0; # use all cores

      binaryCaches = [
        "https://cache.nixos.org"
        "https://all-hies.cachix.org"
        "https://static-haskell-nix.cachix.org"
      ];
      binaryCachePublicKeys = [
        "all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k="
        "static-haskell-nix.cachix.org-1:Q17HawmAwaM1/BfIxaEDKAxwTOyRVhPG5Ji9K3+FvUU="
      ];

      trustedBinaryCaches = [
        "https://cache.nixos.org"
        "https://all-hies.cachix.org"
        "https://static-haskell-nix.cachix.org"
      ];
      trustedUsers = [ "root" "oleh" ];

      sshServe.enable = true;

      extraOptions = ''
        # Start collecting garbage when free space drops below 20GB..
        min-free = 21474836480
        # ..until we have at least 30GB
        max-free = 32212254720
      '';

      nixPath = [
        "nixos=${sources.stable}"
        "nixpkgs=${sources.stable}"
        "unstable=${sources.unstable}"
        "nixos-config=/etc/nixos/configuration.nix"
      ];

      useSandbox = true;
    };

    nixpkgs = {
      config.allowUnfree = true;
    };
  }
