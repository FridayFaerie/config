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
in {
  imports = [
    # Include the results of the hardware scan.
    # moved to flake
    # ./hardware-configuration.nix
  ];

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
    wf-recorder
    busybox
    cachix

    # Smaller terminal things
    # neo
    # lavat
    # asciiquarium
    # globe-cli
    # clolcat
    # fortune
    # nitch
    leaf

    #usefuls
    typst
    clang
    clang-tools
    home-manager
    nix-tree

    ## Hyprland things
    # waybar
    rofi-wayland
    libnotify
    # swaynotificationcenter
    hyprshot
    wl-clipboard
    hyprlock
    hypridle
    hyprpaper
    wlogout
    pamixer
    hyprsunset
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

  # TODO: remove this
  boot.kernel.sysctl."kernel.perf_event_mlock_kb" = 516;

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # Automatic updating
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  # # Automatic cleanup
  # nix.gc.automatic = true;
  # nix.gc.dates = "daily";
  # nix.gc.options = "--delete-older-than-10d";

  nix.settings.auto-optimise-store = true;

  nix.settings.trusted-users = ["root" "friday"];

  nix.settings.trusted-public-keys = [
    "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
  nix.settings = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

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

  programs.command-not-found.dbPath = inputs.programsdb.packages.${pkgs.stdenv.hostPlatform.system}.programs-sqlite;

  # for nh
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/friday/config";
  };

  programs.ssh.startAgent = true;

  # performance
  services.thermald.enable = true;
  services.auto-cpufreq.enable = true;

  # Hyprland things
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

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
    nerd-fonts.fira-code
    nerd-fonts.recursive-mono
    cantarell-fonts
    texlivePackages.fontawesome
    noto-fonts-cjk-sans

    roboto
    source-sans
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # nvidia things
  # note: I'm using NVIDIA GeForce MX550
  # https://nixos.wiki/wiki/Nvidia
  services.xserver.videoDrivers = ["nvidia"];
  hardware = {
    graphics.enable = true;

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
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland];

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "friday";
      };
      tuigreet_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        user = "greeter";
      };
      default_session = initial_session;
      # default_session = tuigreet_session;
    };
  };

  services.upower.enable = true;

  security.rtkit.enable = true;
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

  # Enable automatic login for the user.
  services.getty.autologinUser = "friday";

  # services.flatpak.enable = true;

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

  documentation.man.generateCaches = false;

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
