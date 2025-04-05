# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      inputs.nix-minecraft.nixosModules.minecraft-servers
    ];

  nixpkgs.overlays = [
    inputs.nix-minecraft.overlay
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Automatic updating
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";
  
  # # Automatic cleanup
  # nix.gc.automatic = true;
  # nix.gc.dates = "daily";
  # nix.gc.options = "--delete-older-than-10d";
  # nix.settings.auto-optimise-store = true;

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes"];


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


  programs.bash = {
    interactiveShellInit = ''
    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    fi
    '';
  };

# for nh
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/friday/config";
  };

# auto-cpufreq
  programs.auto-cpufreq.enable = true;


# Hyprland things
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # programs.ladybird.enable = true;

 
# for dark theme
  programs.dconf.enable = true;
  programs.dconf.profiles.user = {
    databases = [{ settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };};}];
  };
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.recursive
    texlivePackages.fontawesome
    noto-fonts-cjk-sans

    roboto
    source-sans
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    graphics.enable = true;
    nvidia.modesetting.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];




# Greeter things from https://github.com/sjcobb2022/nixos-config/blob/29077cee1fc82c5296908f0594e28276dacbe0b0/hosts/common/optional/greetd.nix

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  services.upower.enable = true;


  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };



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


  services.minecraft-servers = {
    enable = true;
    eula = true;
    servers = {
      craftmine = {
          enable = true;
          package = pkgs.vanillaServers.vanilla-25w14craftmine;

          serverProperties = {
            gamemode = "survival";
            difficulty = "normal";
            simulation-distance = 8;
            level-seed = "4";
          };

          whitelist = {
            AaronKingsley = "hash";
          };
      };
    };
  };


  programs.fish.enable = true;

  users.defaultUserShell = pkgs.bash;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.friday = {
    isNormalUser = true;
    description = "friday";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "adbusers" "audio" "video"];
    packages = with pkgs; [];
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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


    #usefuls
    typst
    clang
    clang-tools


    # Smaller terminal things
    # neo
    # lavat
    # asciiquarium
    # globe-cli
    clolcat
    fortune
    nitch
    leaf


    # Hyprland things
    # waybar
    rofi-wayland
    libnotify
    swaynotificationcenter
    hyprshot
    wl-clipboard
    hyprlock
    hypridle
    hyprpaper
    hyprcursor
    wlogout
    pamixer
    hyprsunset
    brightnessctl
    networkmanagerapplet
    yazi
    kitty


    # Bigger programs
    firefox
    signal-desktop
    prismlauncher
    legcord
    qutebrowser
    inkscape
    onlyoffice-desktopeditors


  ];

  # virtualisation setup from jacinth samuel: https://www.youtube.com/watch?v=BuzjA1ghJsw
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;


  # for clangd to work
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
  ];

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
