{ config
, pkgs
, ...
}:
{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  nix = import ./nix;
  nixpkgs = {
    config.allowUnfree = true;
  };

  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
    opengl.driSupport32Bit = true;
  };

  boot.earlyVconsoleSetup = true;
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
    consoleFont = "ter-132n";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    consolePackages = [ pkgs.terminus_font ];
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
      sddm.enableHidpi = true;
    };

    windowManager = {
      xmonad.enable = true;
    };

    libinput.enable = true;
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
