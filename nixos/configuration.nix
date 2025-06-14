# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
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
    # Terminal things
    btop
    tealdeer
    mpv
    git
    stow
    ripgrep
    wallust
    wl-screenrec
    busybox
    file
    cachix
    dust
    caligula
    pastel
    astroterm

    # Larger terminal things
    discordo

    # just-for-pretty terminal things
    # neo
    # lavat
    # asciiquarium
    # globe-cli
    # clolcat
    # fortune
    # nitch
    # libcaca
    leaf
    sl

    #usefuls
    typst
    clang
    clang-tools
    home-manager
    nix-tree
    ffmpeg
    yt-dlp

    ## Hyprland things
    # hyprpaper
    # hypridle
    # hyprlock
    # hyprsunset
    # hyprshot
    inputs.hyprpaper.packages.${system}.hyprpaper
    inputs.hypridle.packages.${system}.hypridle
    inputs.hyprlock.packages.${system}.hyprlock
    inputs.hyprsunset.packages.${system}.hyprsunset
    (hyprshot.override {
      hyprland = inputs.hyprland.packages.${system}.hyprland;
      hyprpicker = inputs.hyprpicker.packages.${system}.hyprpicker;
    })

    ## DE things
    # waybar
    rofi-wayland
    libnotify
    # swaynotificationcenter
    wl-clipboard
    wlogout
    pamixer
    brightnessctl
    networkmanagerapplet
    yazi
    kitty
    # kando

    nvidia-offload

    # Bigger programs
    firefox
    signal-desktop
    prismlauncher
    legcord
    qutebrowser
    inkscape
    onlyoffice-desktopeditors
    lutris-free
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # # plymouth things - https://wiki.nixos.org/wiki/Plymouth
  # boot = {
  #   plymouth = {
  #     enable = true;
  #     theme = "rings";
  #     themePackages = with pkgs; [
  #       (adi1090x-plymouth-themes.override {
  #         selected_themes = ["rings"];
  #       })
  #     ];
  #   };
  #
  #   # silent boot
  #   consoleLogLevel = 3;
  #   initrd.verbose = false;
  #   kernelParams = [
  #     "quiet"
  #     "splash"
  #     "boot.shell_on_fail"
  #     "udev.log_priority=3"
  #     "rd.systemd.show_status=auto"
  #   ];
  #   # hides OS choice for bootloaders
  #   # loader.timeout = 0
  # };

  # Automatic updating
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  nix.settings.auto-optimise-store = true;

  nix.settings = {
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

  # Flakes
  nix.settings.experimental-features = ["nix-command" "flakes" "ca-derivations"];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

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

  # i18n.inputMethod = {
  #   enable = "fcitx5";
  #   fcitx5.addons = with pkgs; [
  #     fcitx5-rime
  #     fcitx5-chinese-addons
  #     rime-data
  #   ];
  # };

  # programs.command-not-found.dbPath = inputs.programsdb.packages.${system}.programs-sqlite;
  programs.command-not-found.enable = false;

  # for nh
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/friday/config";
    package = inputs.nh.packages.${system}.default;
  };

  programs.ssh.startAgent = true;

  # Hyprland things
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
  };

  programs.niri.enable = true;

  programs.ladybird.enable = true;

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
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
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
        command = "${inputs.hyprland.packages.${system}.hyprland}/bin/Hyprland";
        # command = "${pkgs.hyprland}/bin/Hyprland";
        user = "friday";
      };
      tuigreet_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        user = "greeter";
      };
      # default_session = initial_session;
      default_session = tuigreet_session;
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
    extraGroups = ["networkmanager" "wheel" "libvirtd" "adbusers" "audio" "video"];
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
