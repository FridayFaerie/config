{ config, pkgs, lib, localflakes, localbuilds, ... }@inputs:

let
  system = "x86_64-linux";
in {

  home.packages = with pkgs; [
    grim
    swww
    theme-sh
    ags
    sassc
    cava
    imagemagick
    gnome-bluetooth
    libdbusmenu-gtk3
    nerd-fonts
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [ 
      pkgs.hyprlandPlugins.hyprbars 
      pkgs.hyprlandPlugins.hypr-dynamic-cursors
    ];
    extraConfig = "source=./flicko.conf";
  };
}
