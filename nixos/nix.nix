{
  buildCores = 0; # use all cores

  binaryCaches = [
    "https://cache.nixos.org"
    "https://hie-nix.cachix.org"
  ];
  binaryCachePublicKeys = [
    "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
  ];

  nixPath = [
    "nixpkgs=/home/oleh/.nix-defexpr/channels/nixpkgs"
    "unstable=/home/oleh/.nix-defexpr/channels/unstable"
    "nixos-config=/etc/nixos/configuration.nix"
  ];

  trustedUsers = [ "root" "oleh" ];
}
