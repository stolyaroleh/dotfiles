{ config
, pkgs
, ...
}:
{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
  };

  nix = import ./nix.nix;

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
    firewall.enable = true;
    firewall.allowedTCPPorts = [
      3000
    ];
    networkmanager.enable = true;
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

  environment.systemPackages = import ./packages.nix;

  users.users.oleh = {
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

  programs = {
    sysdig.enable = true;

    zsh = {
      enable = true;
      shellInit = ''
        export PATH=$PATH:~/.local/bin
        export FZF_PATH="${pkgs.fzf.bin}"
      '';
    };
  };

  virtualisation.docker.enable = true;

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
