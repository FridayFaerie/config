# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';

  # hyprlandpkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  system = pkgs.system;
in {
  imports = [
    # Include the results of the hardware scan.
    # moved to flake
    # ./hardware-configuration.nix
  ];

  services.kanata = {
    enable = true;
    keyboards.default.configFile = ./kanata.cfg;
  };

  nixpkgs.overlays = [
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # small terminal things
    eza
    git
    btop
    dust
    file
    stow
    p7zip
    cachix
    ripgrep
    busybox
    tealdeer
    caligula
    nix-output-monitor

    # Larger terminal things
    discordo

    # just-for-pretty terminal things
    # neo
    # nitch
    # lavat
    # libcaca
    # clolcat
    # fortune
    # globe-cli
    # asciiquarium
    sl
    leaf
    pastel
    astroterm

    # usefuls
    mpv
    typst
    clang
    ffmpeg
    yt-dlp
    wallust
    nix-tree
    clang-tools
    home-manager
    wl-screenrec
    grim
    npins

    ## Hyprland things
    # hyprpaper
    # hypridle
    # hyprlock
    # hyprsunset
    # hyprshot
    inputs.hypridle.packages.${system}.hypridle
    inputs.hyprlock.packages.${system}.hyprlock
    inputs.hyprpaper.packages.${system}.hyprpaper
    inputs.hyprsunset.packages.${system}.hyprsunset
    (hyprshot.override {
      hyprland = inputs.hyprland.packages.${system}.hyprland;
      hyprpicker = inputs.hyprpicker.packages.${system}.hyprpicker;
    })

    ## DE things
    yazi
    kitty
    pamixer
    wlogout
    libnotify
    rofi-wayland
    wl-clipboard
    brightnessctl
    nvidia-offload
    networkmanagerapplet

    # QT theming
    # quickshell
    # kdePackages.breeze
    # kdePackages.breeze-icons
    # kdePackages.qtstyleplugin-kvantum
    qt6.qtsvg
    kdePackages.qt6ct
    kdePackages.qt5compat
    kdePackages.qtmultimedia
    kdePackages.qtdeclarative
    kdePackages.qtpositioning
    kdePackages.kirigami.unwrapped
    kdePackages.qqc2-desktop-style
    kdePackages.syntax-highlighting
    kdePackages.kirigami.passthru.unwrapped

    # Bigger programs
    firefox
    legcord
    inkscape
    lutris-free
    qutebrowser
    prismlauncher
    signal-desktop
    onlyoffice-desktopeditors
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # # Automatic updating
  # system.autoUpgrade.enable = true;
  # system.autoUpgrade.dates = "weekly";

  nix.package = pkgs.nixVersions.nix_2_30;

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
      # "ca-derivations"
    ];

    substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Etc/UTC";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # programs.command-not-found.dbPath = inputs.programsdb.packages.${system}.programs-sqlite;
  programs.command-not-found.enable = false;

  programs.direnv.enable = true;

  # for nh
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/friday/config";
    # package = inputs.nh.packages.${system}.default;
  };

  # TODO: why is gcr-ssh-agent enabled... :(
  programs.ssh.startAgent = true;
  services.gnome.gcr-ssh-agent.enable = false;

  # Hyprland things
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  };

  programs.niri.enable = true;

  # programs.ladybird.enable = true;

  # for dark theme
  programs.dconf.enable = true;
  programs.dconf.profiles.user = {
    databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
          "org/gnome/desktop/wm/preferences" = {
            button-layout = "";
            # button-layout = ":minimize,maximize,close";
          };
        };
      }
    ];
  };

  fonts.packages = with pkgs; [
    material-symbols
    nerd-fonts.jetbrains-mono
    nerd-fonts.recursive-mono
    cantarell-fonts
    noto-fonts-cjk-sans
    font-awesome
    roboto
    source-sans
    source-sans-pro
  ];

  # QT theming
  qt = {
    enable = true;
    style = "adwaita-dark";
    # platformTheme = "qt5ct";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    HYPR_PLUGIN_DIR =
      pkgs.symlinkJoin {
        name = "hyprplugins";
        paths = [
          inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
          inputs.hyprland-plugins.packages.${pkgs.system}.hyprscrolling
          inputs.hyprland-plugins.packages.${pkgs.system}.hyprfocus
          inputs.hypr-darkwindow.packages.${pkgs.system}.Hypr-DarkWindow
          inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
          inputs.hyprgreen.packages.${pkgs.system}.hyprgreen
        ];
      }
      + "/lib";
  };

  environment.variables = {
    EDITOR = "nixCats";
  };

  # nvidia things
  # NOTE: I'm using NVIDIA GeForce MX550
  # https://nixos.wiki/wiki/Nvidia
  services.xserver.videoDrivers = ["nvidia"];
  hardware = {
    graphics = {
      # package = hyprlandpkgs.mesa;
      #
      # # # if you also want 32-bit support (e.g for Steam)
      # # enable32Bit = true;
      # # package32 = hyprlandpkgs.pkgsi686Linux.mesa;

      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
      ];
    };

    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+ ( I can)
      open = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.latest;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        # instead of offload, you can do sync.enable = true;

        # Make sure to use the correct Bus ID values for your system!
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  xdg.mime.defaultApplications = {
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/chrome" = "firefox.desktop";
    "text/html" = "firefox.desktop";
    "application/x-extension-htm" = "firefox.desktop";
    "application/x-extension-html" = "firefox.desktop";
    "application/x-extension-shtml" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
    "application/x-extension-xhtml" = "firefox.desktop";
    "application/x-extension-xht" = "firefox.desktop";
    "application/pdf" = "firefox.desktop";
  };

  security.rtkit.enable = true;

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd uwsm start default";
        user = "friday";
      };
      default_session = {
        # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd uwsm start default";

        # from https://ryjelsum.me/homelab/greetd-session-choose/
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session";
        user = "greeter";
      };
    };
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "friday";

  programs.fish.enable = true;

  users.defaultUserShell = pkgs.fish;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.friday = {
    isNormalUser = true;
    description = "friday";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "adbusers"
      "audio"
      "video"
      "kvm"
    ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # virtualisation setup from jacinth samuel: https://www.youtube.com/watch?v=BuzjA1ghJsw
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # for clangd to work
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
  ];

  # documentation.man.generateCaches = false;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.gpm.enable = true;

  # performance
  services.thermald.enable = true;
  services.auto-cpufreq.enable = true;

  services.upower.enable = true;

  zramSwap.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
