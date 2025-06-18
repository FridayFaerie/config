{
  pkgs,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    settings = {
      source = [
        "~/.config/wallust/themes/hypr.conf"
        "~/.config/hypr/extrahyprland.conf"
      ];

      xwayland.force_zero_scaling = true;
      "$terminal" = "kitty";
      "$fileManager" = "kitty yazi";
      "$menu" = "rofi -show drun -show-icons";

      "exec-once" = "bash ~/.config/hypr/start.sh";

      "$mainMod" = "SUPER";
      bind =
        [
          "$mainMod, T, exec, $terminal"
          "$mainMod, Q, killactive,"
          "$mainMod SHIFT, Q, forcekillactive,"
          "$mainMod, M, exit,"
          "$mainMod, F, exec, $fileManager"
          "$mainMod, V, togglefloating,"
          "$mainMod, R, exec, $menu"
          "$mainMod, P, pseudo, # dwindle"
          "$mainMod, W, togglesplit, # dwindle"
          # "$mainMod, B, exec, zen"
          "$mainMod, B, exec, firefox"
          "Control_L&Shift_L, PRINT, exec, hyprshot -m active -m output -o ~/Pictures"
          "SHIFT, PRINT, exec, hyprshot -z -m window -o ~/Pictures"
          ", PRINT, exec, hyprshot -z -m region -o ~/Pictures"
          "$mainMod, C, fullscreen, 1"
          "$mainMod SHIFT, C, fullscreen, 0"
          "$mainMod, E, fullscreenstate, 0 3"

          # Move focus with mainMod + arrow keys
          # "$mainMod, H, movefocus, l"
          # "$mainMod, L, movefocus, r"
          # "$mainMod, K, movefocus, u"
          # "$mainMod, J, movefocus, d"

          # Example special workspace (scratchpad)
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e-1"
          "$mainMod, mouse_up, workspace, e+1"

          "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
        ]
        ++ (
          # workspaces
          # binds $mainMod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mainMod, code:1${toString i}, workspace, ${toString ws}"
                "$mainMod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Move/resize windows with mainMod + LMB?RMB and dragging
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      #requires playerctl
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      windowrule = [
        # Ignore maximize requests from apps. You'll probably like this.
        "suppressevent maximize, class:.*"

        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

        # fakefullscreen for typst previews
        "fullscreenstate:0 3, title:(Typst Preview)(.*)"
      ];
    };
  };
}
