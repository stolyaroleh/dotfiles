{ config
, lib
, pkgs
, ...
}:
{
  imports = [
    ./nix
    /etc/nixos/hardware-configuration.nix
  ] ++ lib.optional (builtins.pathExists ./work.nix) ./work.nix;

  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages32 = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    };
    trackpoint = {
      enable = true;
      emulateWheel = true;
    };
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
    networkmanager.wifi.powersave = true;
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

  fonts.fonts = with pkgs; [
    fira-code
    google-fonts
    hasklig
    source-code-pro
  ];

  environment.systemPackages = import ./packages.nix;
  services.dbus.socketActivated = true;

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
    bash.interactiveShellInit = ''
      eval "$(direnv hook bash)"
    '';

    ssh.startAgent = true;

    sysdig.enable = true;

    zsh = {
      enable = true;
      shellInit = ''
        export PATH=$PATH:~/.local/bin
        export FZF_PATH="${pkgs.fzf}"
      '';
      interactiveShellInit = ''
        eval "$(direnv hook zsh)"
      '';
    };
  };

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };

  location.provider = "geoclue2";

  services.teamviewer.enable = true;
  services.openssh.enable = true;
  services.redshift = {
    enable = true;
  };

  services.xserver = {
    enable = true;
    layout = "us,ru,ua";

    # caps lock -> super
    xkbOptions = "caps:super";

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

  systemd.user.sockets.lorri = {
    enable = true;
    description = "lorri daemon";
    socketConfig = {
      ListenStream = "%t/lorri/daemon.socket";
    };
    wantedBy = [ "sockets.target" ];
  };

  systemd.user.services.lorri = {
    enable = true;
    description = "lorri daemon";
    requires = [ "lorri.socket" ];
    after = [ "lorri.socket" ];
    environment = {
      RUST_BACKTRACE = "1";
    };
    serviceConfig = {
      ExecStart =
        let
          sources = import ./nix/sources.nix;
          lorri = import sources.lorri {};
        in
          "${lorri}/bin/lorri daemon";
      PrivateTmp = true;
      ProtectSystem = "strict";
      WorkingDirectory = "%h";
      Restart = "on-failure";
    };
  };

  system.autoUpgrade.enable = true;
  system.stateVersion = "19.03";
}
