{ config, pkgs, ... }:
{
  imports =
    [
       ./hardware-configuration.nix
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
  boot.kernelParams = [
    "nomodeset"
    "quiet"
  ];

  networking = {
    hostName = "1700X-nixos";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time = {
    hardwareClockInLocalTime = true;
    timeZone = "Europe/Sofia";
  };

  environment.systemPackages = with pkgs; [
    google-chrome
    gimp
    vlc

    # shell
    fasd
    termite
    thefuck
    zsh

    # notifications
    dunst

    # mate
    mate.mate-themes

    # code
    binutils
    cloc
    emacs
    gcc7
    git
    gnumake
    python36
    stack
    tldr
    vim
    vscode

    # fonts
    hasklig
    source-code-pro

    # automation
    xdotool
    xorg.xev

    # system
    coreutils
    curl
    findutils
    file
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

  users.extraUsers.stolyaroleh = {
    description = "Oleh Stolyar";
    isNormalUser = true;

    shell = pkgs.zsh;

    home = "/home/stolyaroleh";
    createHome = true;

    extraGroups = ["audio" "networkmanager" "wheel"];
  };

  programs.zsh = {
    enable = true;
    shellInit = ''
      export PATH=$PATH:~/.local/bin
    '';
  };

  services.openssh.enable = true;

  services.xserver = {
    enable = true;
    layout = "us,ru,ua";
    videoDrivers = [ "nvidia" ];

    # caps lock -> ctrl
    xkbOptions = "ctrl:nocaps";

    desktopManager = {
      default = "gnome3";
      gnome3.enable = true;
      mate.enable = true;
      xterm.enable = false;
    };

    displayManager = {
      gdm.enable = true;
    };

    windowManager = {
      xmonad.enable = true;
      xmonad.enableContribAndExtras = true;
    };
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

  systemd.user.services.dunst = {
    enable = true;
    description = "dunst daemon";
    wantedBy = [ "default.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.dunst}/bin/dunst";
      Restart = "always";
    };
  };

  environment.shellAliases = {
    lsa = "ls -lahF";
  };

  system.stateVersion = "17.09";
}
