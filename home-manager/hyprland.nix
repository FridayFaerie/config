{
  pkgs,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    plugins = [
      # pkgs.hyprlandPlugins.hypr-dynamic-cursors
      inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprscrolling
    ];
    #extraConfig = "bind = $mainMod, S, submap, resize";
    settings = {
      source = [
        "~/.config/wallust/themes/hypr.conf"
        "~/.config/hypr/hyprland1.conf"
      ];

      xwayland.force_zero_scaling = true;
      "$terminal" = "kitty";
      "$fileManager" = "kitty yazi";
      "$menu" = "rofi -show drun -show-icons";

      "exec-once" = "bash ~/.config/hypr/start.sh";

      # "env" = ["XCURSOR_THEME,hypr_bibata" "XCURSOR_SIZE,20" "HYPRCURSOR_THEME,hypr_bibata" "HYPRCURSOR_SIZE,20"];
      # "env" = ["XCURSOR_THEME,hypr_bibata" "XCURSOR_SIZE,20"];
      # "env" = ["HYPRCURSOR_THEME,hypr_bibata" "HYPRCURSOR_SIZE,20"];

      general = {
        gaps_in = 5;
        gaps_out = 5;

        border_size = 2;
        # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        # "col.inactive_border" = "rgba(595959aa)";

        resize_on_border = true;
        allow_tearing = false;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        focus_on_activate = true;
      };

      #      input = {
      #        kb_layout = "us";
      # kb_options = "ctrl:nocaps";
      #
      # follow_mouse = 1;
      #
      # sensitivity = 0; #-1 to 1, 0 is default
      #
      # touchpad.natural_scroll = true;
      #      };

      gestures.workspace_swipe = true;

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
          "SHIFT, PRINT, exec, hyprshot -m window -o ~/Pictures"
          ", PRINT, exec, hyprshot -m region -o ~/Pictures"
          "$SUPER_SHIFT, L, exec, wlogout -p layer-shell "
          "$mainMod, C, fullscreen, 1"
          "$mainMod SHIFT, C, fullscreen, 0"
          "$mainMod, E, fullscreenstate, 0 3"

          # Move focus with mainMod + arrow keys
          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"

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

        # for shimeji
        "float, class:Shijima-Qt     "
        "noblur, class:Shijima-Qt    "
        # "nofocus, class:Shijima-Qt "
        "noshadow, class:Shijima-Qt  "
        "noborder, class:Shijima-Qt  "

        # for shimeji
        "float, class:com-group_finity-mascot-Main   "
        "noblur, class:com-group_finity-mascot-Main  "
        # "nofocus, class:com-group_finity-mascot-Main "
        "noshadow, class:com-group_finity-mascot-Main"
        "noborder, class:com-group_finity-mascot-Main"
      ];

      "plugin:dynamic-cursors" = {
        # enables the plugin
        enabled = true;

        # sets the cursor behaviour, supports these values:
        # tilt    - tilt the cursor based on x-velocity
        # rotate  - rotate the cursor based on movement direction
        # stretch - stretch the cursor shape based on direction and velocity
        # none    - do not change the cursors behaviour
        mode = ["rotate"];

        # minimum angle difference in degrees after which the shape is changed
        # smaller values are smoother, but more expensive for hw cursors
        threshold = 2;

        # override the mode behaviour per shape
        # this is a keyword and can be repeated many times
        # by default, there are no rules added
        # see the dedicated `shape rules` section below!
        # shaperule = "<shape-name>, <mode> (optional), <property>: <value>, ..."
        # shaperule = "<shape-name>, <mode> (optional), <property>: <value>, ..."
        # ...

        # for mode = rotate
        rotate = {
          # length in px of the simulated stick used to rotate the cursor
          # most realistic if this is your actual cursor size
          length = 20;

          # clockwise offset applied to the angle in degrees
          # this will apply to ALL shapes
          offset = 0.0;
        };

        # for mode = tilt
        tilt = {
          # controls how powerful the tilt is, the lower, the more power
          # this value controls at which speed (px/s) the full tilt is reached
          limit = 5000;

          # relationship between speed and tilt, supports these values:
          # linear             - a linear function is used
          # quadratic          - a quadratic function is used (most realistic to actual air drag)
          # negative_quadratic - negative version of the quadratic one, feels more aggressive
          function = "negative_quadratic";
        };

        # for mode = stretch
        stretch = {
          # controls how much the cursor is stretched
          # this value controls at which speed (px/s) the full stretch is reached
          limit = 3000;

          # relationship between speed and stretch amount, supports these values:
          # linear             - a linear function is used
          # quadratic          - a quadratic function is used
          # negative_quadratic - negative version of the quadratic one, feels more aggressive
          function = "quadratic";
        };

        # configure shake to find
        # magnifies the cursor if its is being shaken
        shake = {
          # enables shake to find
          enabled = true;

          # use nearest-neighbour (pixelated) scaling when shaking
          # may look weird when effects are enabled
          nearest = true;

          # controls how soon a shake is detected
          # lower values mean sooner
          threshold = 6.0;

          # magnification level immediately after shake start
          base = 4.0;
          # magnification increase per second when continuing to shake
          speed = 4.0;
          # how much the speed is influenced by the current shake intensitiy
          influence = 0.0;

          # maximal magnification the cursor can reach
          # values below 1 disable the limit (e.g. 0)
          limit = 0.0;

          # time in millseconds the cursor will stay magnified after a shake has ended
          timeout = 2000;

          # show cursor behaviour `tilt`, `rotate`, etc. while shaking
          effects = false;

          # enable ipc events for shake
          # see the `ipc` section below
          ipc = false;
        };

        # use hyprcursor to get a higher resolution texture when the cursor is magnified
        # see the `hyprcursor` section below
        hyprcursor = {
          # use nearest-neighbour (pixelated) scaling when magnifing beyond texture size
          # this will also have effect without hyprcursor support being enabled
          # 0 / false - never use pixelated scaling
          # 1 / true  - use pixelated when no highres image
          # 2         - always use pixleated scaling
          nearest = true;

          # enable dedicated hyprcursor support
          enabled = true;

          # resolution in pixels to load the magnified shapes at
          # be warned that loading a very high-resolution image will take a long time and might impact memory consumption
          # -1 means we use [normal cursor size] * [shake:base option]
          resolution = -1;

          # shape to use when clientside cursors are being magnified
          # see the shape-name property of shape rules for possible names
          # specifying clientside will use the actual shape, but will be pixelated
          fallback = "clientside";
        };
      };
      debug = {
        disable_logs = false;
      };
    };
  };
}
