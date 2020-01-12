let
  sources = import ./nix/sources.nix;
  stable = import sources.stable {
    config.allowUnfree = true;
  };
  unstable = import sources.unstable {
    config.allowUnfree = true;
  };
  direnv = import sources.direnv { pkgs = stable; };
  lorri = import sources.lorri {};
  # nix-channel replacement
  niv = (import sources.niv {}).niv;
  wine = unstable.wineWowPackages.staging;
  winetricks = unstable.winetricks.override {
    inherit wine;
  };
in
[
  direnv
  lorri
  niv
  wine
  winetricks
] ++ (
  with stable; [
    google-chrome
    vlc

    # drawing
    gimp
    krita
    libwacom

    # shell
    bash
    bat
    fasd
    fzf
    kitty
    zsh

    # theorem proving
    lean

    # bazel
    bazel
    buildifier
    buildozer

    # code
    cloc
    emacs
    git
    gitAndTools.hub
    gnumake
    neovim
    python36
    rustup
    tldr
    vim

    # games
    vulkan-loader

    # kde
    kdeApplications.ark # archive
    kdeApplications.gwenview # image viewer
    kdeApplications.kdialog
    konversation # IRC client
    ktorrent
    kdeApplications.okular # pdf viewer
    kdeApplications.spectacle # screenshots

    # automation
    xdotool
    xorg.xev

    # utilities
    # Open application launcher using Super
    ksuperkey

    # system
    coreutils
    curl
    findutils
    file
    fuse
    exfat
    ffmpeg
    htop
    libnotify
    ntfs3g
    psmisc
    tree
    udiskie
    wget
    zip
    unzip
  ]
) ++ (
  with unstable; [
    jetbrains.pycharm-community
    jetbrains.clion
    vscode
  ]
)
