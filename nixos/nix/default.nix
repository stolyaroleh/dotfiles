{ ... }:
let
  sources = import ./sources.nix;
in
  {
    nix = {
      buildCores = 0; # use all cores

      binaryCaches = [
        "https://cache.nixos.org"
        "https://hie-nix.cachix.org"
      ];
      binaryCachePublicKeys = [
        "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
      ];
      trustedBinaryCaches = [
        "https://cache.nixos.org"
        "https://hie-nix.cachix.org"
      ];
      trustedUsers = [ "root" "oleh" ];

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
