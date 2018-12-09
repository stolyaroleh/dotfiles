let
  stable = import <nixpkgs> {
    config.allowUnfree = true;
  };
  unstable = import <unstable> {
    config.allowUnfree = true;
  };
in
  (with stable; [
    vlc

    # screenshots
    flameshot

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
    gcc7
    git
    gnumake
    python36
    rustup
    tldr
    vim

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
    google-chrome

    jetbrains.pycharm-community
    jetbrains.clion
    vscode
  ])
