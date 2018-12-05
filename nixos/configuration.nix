{ config, pkgs, ... }:
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
    ];

  nix.nixPath = [
    "nixpkgs=/etc/nixos/nixpkgs"
    "nixos-config=/etc/nixos/configuration.nix"
  ];

  nixpkgs.config.allowUnfree = true;

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };

  # Enable full acceleration in 32-bit programs (Wine)
  hardware.opengl.driSupport32Bit = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "jarvis";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time = {
    hardwareClockInLocalTime = true;
    timeZone = "Europe/London";
  };

  environment.systemPackages = with pkgs; [
    google-chrome
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

    # mate
    mate.mate-themes

    # theorem proving
    lean

    # code
    binutils
    cloc
    emacs
    gcc7
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

    # smarkets and shit
    minikube
    kubectl
    kubernetes-helm

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
    stow
    tree
    udiskie
    wget
    zip unzip
  ];

  users.extraUsers."oleh" = {
    description = "Oleh Stolyar";
    isNormalUser = true;

    shell = pkgs.zsh;

    home = "/home/oleh";
    createHome = true;

    extraGroups = [
      "audio"
      "docker"
      "networkmanager"
      "vboxusers"
      "wheel"
    ];
  };

  programs.zsh = {
    enable = true;
    shellInit = ''
      export PATH=$PATH:~/.local/bin
      export FZF_PATH="${pkgs.fzf.bin}"
    '';
  };

  virtualisation.docker.enable = true;
  virtualisation.virtualbox = {
    guest.enable = true;
    host.enable = true;
    host.enableHardening = false;
  };

  services.openssh.enable = true;

  services.xserver = {
    enable = true;
    layout = "us,ru,ua";

    # caps lock -> ctrl
    xkbOptions = "ctrl:nocaps";

    desktopManager = {
      default = "plasma5";
      plasma5.enable = true;
      xterm.enable = false;
    };

    displayManager = {
      sddm.enable = true;
    };

    windowManager = {
      xmonad.enable = true;
    };

    wacom.enable = true;
  };

  systemd.user.services.xbanish = {
    enable = true;
    description = "xbanish";
    wantedBy = [ "default.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.xbanish}/bin/xbanish";
      Restart = "always";
    };
  };

  system.autoUpgrade.enable = true;
  system.stateVersion = "18.09";
}
