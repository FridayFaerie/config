{
  config,
  pkgs,
  lib,
  inputs,
  localbuilds,
  # altpkgs,
  ...
} @ inputs: let
  system = "x86_64-linux";
in {
  home.username = "bun";
  home.homeDirectory = "/home/bun";

  # check release notes and breaking changes before changing
  home.stateVersion = "24.11";

  home.packages = [
    inputs.nixCats.packages.${system}.nixCats

    localbuilds.snitch.packages.${system}.default

    pkgs.leaf

    pkgs.nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;

  home.sessionPath = [
    "$HOME/.config/scripts/"
  ];

  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    EDITOR = "nixCats";
    MANPAGER = "nixCats +Man!";
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
    enableBashIntegration = true;
    #enableFishIntegration = true;
    #enableTransience = true;
  };

  # programs.fish = {
  #   enable = true;
  #   interactiveShellInit = ''
  #     function fish_greeting
  #       clear
  #       leaf
  #     end
  #     bind "/" expand-abbr or self-insert
  #     source ~/.config/scripts/alias.sh
  #   '';
  # };

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
    # cursorTheme = {
    #   name = "Bibata-Modern-Ice";
    #   package = pkgs.bibata-cursors;
    #   size = 20;
    # };

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

  programs.home-manager.enable = true;
}
