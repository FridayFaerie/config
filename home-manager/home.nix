{
  config,
  pkgs,
  lib,
  localflakes,
  localbuilds,
  # altpkgs,
  ...
} @ inputs: let
  system = "x86_64-linux";
in {
  home.username = "friday";
  home.homeDirectory = "/home/friday";

  # check release notes and breaking changes before changing
  home.stateVersion = "24.11";

  home.packages = [
    localflakes.nixCats.packages.${system}.nixCats

    # localflakes.zen-browser.packages.${system}.default

    localflakes.quickshell.packages.${system}.default

    localbuilds.snitch.packages.${system}.default

    pkgs.kdePackages.qtdeclarative
    pkgs.kdePackages.qtmultimedia
    pkgs.kdePackages.qt5compat
    pkgs.kdePackages.kirigami.unwrapped

    # (pkgs.writeShellScriptBin "my-hello" '' echo "Hello, ${config.home.username}!" '')
  ];

  home.sessionPath = [
    "$HOME/.config/scripts/"
  ];

  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    EDITOR = "nixCats";
    MANPAGER = "nixCats +Man!";
    QML2_IMPORT_PATH =
      "${localflakes.quickshell.packages.${system}.default}/lib/qt-6/qml"
      + ":${pkgs.qt6.qtdeclarative}/lib/qt-6/qml"
      + ":${pkgs.kdePackages.qt5compat}/lib/qt-6/qml"
      + ":${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
      + ":${pkgs.kdePackages.qtmultimedia}/lib/qt-6/qml";
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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
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
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
  };

  # programs.fish.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      function fish_greeting
        clear
        leaf
      end
      bind "/" expand-abbr or self-insert
      source ~/.config/scripts/alias.sh
    '';
  };

  home.pointerCursor = {
    enable = true;
    name = "catppuccin-latte-light-cursors";
    size = 20;
    package = pkgs.catppuccin-cursors.latteLight;
    gtk.enable = true;
    hyprcursor.enable = true;
    hyprcursor.size = 20;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "oomox-gruvbox-dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };
    theme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-gtk-theme;
    };
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
}
