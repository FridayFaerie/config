{
  config,
  pkgs,
  lib,
  inputs,
  localbuilds,
  # altpkgs,
  ...
}: let
  system = pkgs.system;
in {
  home.username = "friday";
  home.homeDirectory = "/home/friday";

  # check release notes and breaking changes before changing
  home.stateVersion = "24.11";

  home.packages = [
    inputs.nixCats.packages.${system}.nixCats

    # (inputs.quickshell.packages.${system}.default.override {
    #   withJemalloc = true;
    #   withQtSvg = true;
    #   withWayland = true;
    #   withX11 = false;
    #   withPipewire = true;
    #   withPam = true;
    #   withHyprland = true;
    #   withI3 = false;
    # })
    pkgs.quickshell

    # TODO: try using qt.enable instead
    pkgs.kdePackages.qtdeclarative

    # inputs.zen-browser.packages.${system}.default
    # inputs.wl_shimeji.packages.${system}.default

    localbuilds.snitch.packages.${system}.default
  ];

  home.sessionPath = [
    "$HOME/.config/scripts/"
  ];

  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    EDITOR = "nixCats";
    MANPAGER = "nixCats +Man!";
    CARGO_HOME = "$HOME/.config/cargo/";
  };

  xdg.desktopEntries = {
    quickshell = {
      name = "Quickshell";
      genericName = "QtQuick Shell";
      exec = "quickshell";
      terminal = false;
      categories = ["Application"];
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      function fish_greeting
        clear
        leaf
      end
      bind "/" expand-abbr or self-insert
      source ~/.config/scripts/alias.sh
      function starship_transient_prompt_func
        starship module character
      end

    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  home.pointerCursor = {
    enable = true;
    name = "catppuccin-latte-light-cursors";
    size = 24;
    package = pkgs.catppuccin-cursors.latteLight;
    gtk.enable = true;
    hyprcursor.enable = true;
    hyprcursor.size = 24;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    # iconTheme = {
    #   name = "oomox-gruvbox-dark";
    #   package = pkgs.gruvbox-dark-icons-gtk;
    # };
    # theme = {
    #   name = "Colloid-Dark";
    #   package = pkgs.colloid-gtk-theme;
    # };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  services.batsignal = {
    enable = true;
    extraArgs = [
      "-i"
      "-w"
      "30"
      "-c"
      "15"
      "-d"
      "5"
    ];
  };

  # textfox = {
  #   enable = true;
  #   profile = "textfox";
  #   config = {
  #     # extraConfig = ''
  #     #   #tabbrowser-tabbox::before {
  #     #     margin: -1.3rem 0rem;
  #     #   }
  #     # '';
  #     # font.family = "Courier20, Courier13, Courier, monospace";
  #   };
  # };

  news.display = "silent";
}
