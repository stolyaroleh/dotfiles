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
in
[
  direnv
  lorri
  niv
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
    gnumake
    python36
    rustup
    tldr
    vim

    # kde
    kdeApplications.ark # archive
    kdeApplications.gwenview # image viewer
    kdeApplications.kdialog
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
    bat
    jetbrains.pycharm-community
    jetbrains.clion
    vscode
  ]
)
