let
  sources = import ./nix/sources.nix;
  stable = import sources.stable {
    config.allowUnfree = true;
  };
  unstable = import sources.unstable {
    config.allowUnfree = true;
  };
  niv = (import sources.niv {}).niv;
in
  # nix-channel replacement
  [ niv ] ++
  (with stable; [
    google-chrome
    vlc

    # screenshots
    spectacle

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

    # code
    binutils
    cloc
    emacs
    git
    gnumake
    jetbrains.pycharm-community
    jetbrains.clion
    python36
    rustup
    tldr
    vim
    vscode

    # fonts
    fira-code
    hasklig
    source-code-pro

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
    zip unzip
  ]) ++
  (with unstable; [
  ])
