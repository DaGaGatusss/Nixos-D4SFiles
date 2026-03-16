{ config, pkgs, ... }:
{
  xsession.windowManager.i3 = {
    enable = true;
    extraConfig = ''
      for_window [class="^.*"] border pixel 3
      client.focused #444444 #bf7500 #444444 #ffff70

      for_window [title="^zoom\s?$"] floating enable
      for_window [title="Zoom Meeting"] floating enable
      for_window [title="Zoom Cloud Meetings"] floating enable
      for_window [class="^zoom$"] floating enable
      for_window [class="zoom" title="Annotation"] floating enable
    '';
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      fonts = {
        names = [ "monospace" ];
        size = 8.0;
      };

      floating.modifier = "Mod4";

      startup = [
        { command = "dex --autostart --environment i3"; notification = false; }
        { command = "xss-lock --transfer-sleep-lock -- i3lock --nofork"; notification = false; }
        { command = "nmtui"; notification = false; }
        { command = "dunst"; notification = false; }
        { command = "pulseaudio --start"; notification = false; }
        { command = "picom -b"; always = true; notification = false; }
        { command = "copyq"; notification = false; }
        { command = "blueman-applet"; notification = false; }
        { command = "sh -c 'sleep 1 && setxkbmap -layout us,latam'"; notification = false; }
      ];

      keybindings = let
        mod = "Mod4";
        alt = "Mod1";
        refresh = "killall -SIGUSR1 i3status";
      in {
        # Volumen
        "XF86AudioMicMute"     = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && ${refresh}";
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5% && ~/.config/i3/scripts/volume-notify.sh";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5% && ~/.config/i3/scripts/volume-notify.sh";
        "XF86AudioMute"        = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && ~/.config/i3/scripts/volume-notify.sh";

        # Brillo
        "XF86MonBrightnessUp"   = "exec --no-startup-id brightnessctl set +8% && ~/.config/i3/scripts/brightness-notify.sh";
        "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 8%- && ~/.config/i3/scripts/brightness-notify.sh";

        # Apps
        "Print"         = "exec flameshot gui";
        "${alt}+d"      = "exec --no-startup-id gromit-mpx";
        "${mod}+Return" = "exec kitty";
        "${mod}+d"      = "exec rofi -show drun";

        # Redshift
        "${alt}+e" = "exec redshift -O 3500";
        "${alt}+r" = "exec redshift -x";

        # Teclado layout
        "${alt}+Shift+space" = "exec setxkbmap -query | grep -q 'layout:.*us' && setxkbmap latam || setxkbmap us";

        # Sistema
        "${alt}+p" = "exec systemctl poweroff";
        "${alt}+o" = "exec systemctl reboot";

        # Ventanas
        "${mod}+Shift+q" = "kill";
        "${mod}+f"       = "fullscreen toggle";
        "${mod}+h"       = "split h";
        "${mod}+v"       = "split v";

        # Layouts
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        # Floating
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space"       = "focus mode_toggle";

        # Foco con teclas personalizadas (j=left k=down l=up ;=right)
        "${mod}+j"         = "focus left";
        "${mod}+k"         = "focus down";
        "${mod}+l"         = "focus up";
        "${mod}+semicolon" = "focus right";

        # Foco con flechas
        "${mod}+Left"  = "focus left";
        "${mod}+Down"  = "focus down";
        "${mod}+Up"    = "focus up";
        "${mod}+Right" = "focus right";

        # Mover con teclas personalizadas
        "${mod}+Shift+j"         = "move left";
        "${mod}+Shift+k"         = "move down";
        "${mod}+Shift+l"         = "move up";
        "${mod}+Shift+semicolon" = "move right";

        # Mover con flechas
        "${mod}+Shift+Left"  = "move left";
        "${mod}+Shift+Down"  = "move down";
        "${mod}+Shift+Up"    = "move up";
        "${mod}+Shift+Right" = "move right";

        # Foco parent
        "${mod}+a" = "focus parent";

        # Scratchpad
        "${mod}+Shift+minus" = "move scratchpad";
        "${mod}+minus"       = "scratchpad show";

        # Workspaces - cambiar
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        # Workspaces - mover ventana
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        # i3 control
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "${mod}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you really want to exit i3?' -B 'Yes, exit i3' 'i3-msg exit'";

        # Modo resize
        "${mod}+r" = "mode resize";
      };

      modes = {
        resize = {
          "j"         = "resize shrink width 3 px or 3 ppt";
          "k"         = "resize grow height 3 px or 3 ppt";
          "l"         = "resize shrink height 3 px or 3 ppt";
          "semicolon" = "resize grow width 3 px or 3 ppt";
          "Left"      = "resize shrink width 3 px or 3 ppt";
          "Down"      = "resize grow height 3 px or 3 ppt";
          "Up"        = "resize shrink height 3 px or 3 ppt";
          "Right"     = "resize grow width 3 px or 3 ppt";
          "Return"    = "mode default";
          "Escape"    = "mode default";
          "Mod4+r"    = "mode default";
        };
      };

      bars = [
        {
          statusCommand = "i3blocks -c ~/.config/i3blocks/config";
          position = "top";
          colors = {
            background        = "#222222";
            statusline        = "#eeeeee";
            separator         = "#666666";
            focusedWorkspace  = { border = "#444444"; background = "#444444"; text = "#ffb52a"; };
            activeWorkspace   = { border = "#333333"; background = "#5f676a"; text = "#ffffff"; };
            inactiveWorkspace = { border = "#333333"; background = "#222222"; text = "#888888"; };
            urgentWorkspace   = { border = "#2f343a"; background = "#900000"; text = "#ffffff"; };
          };
        }
      ];
    };
  };

  # Scripts de i3
  home.file = {
    ".config/i3/scripts/volume-notify.sh" = {
      executable = true;
      text = ''
        #!/bin/bash
        VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\+%' | head -n1 | tr -d '%')
        MUTE=$(pactl get-sink-mute @DEFAULT_SINK@)

        if [ "$MUTE" = "Mute: yes" ]; then
            ICON="audio-volume-muted"
            BAR="[Muted]"
        else
            if [ "$VOLUME" -ge 70 ]; then
                ICON="audio-volume-high"
            elif [ "$VOLUME" -ge 30 ]; then
                ICON="audio-volume-medium"
            else
                ICON="audio-volume-low"
            fi
            FILLED=$(($VOLUME / 10))
            EMPTY=$((10 - $FILLED))
            BAR="["
            for i in $(seq 1 $FILLED); do BAR="''${BAR}■"; done
            for i in $(seq 1 $EMPTY);  do BAR="''${BAR}□"; done
            BAR="''${BAR}]"
        fi

        notify-send -r 5555 -t 700 -i "$ICON" "Volumen ''${VOLUME}%" "$BAR"
      '';
    };

    ".config/i3/scripts/brightness-notify.sh" = {
      executable = true;
      text = ''
        #!/bin/bash
        BRIGHTNESS=$(brightnessctl get)
        MAX_BRIGHTNESS=$(brightnessctl max)
        PERCENT=$(( BRIGHTNESS * 100 / MAX_BRIGHTNESS ))

        FILLED=$(($PERCENT / 10))
        EMPTY=$((10 - $FILLED))
        BAR="["
        for i in $(seq 1 $FILLED); do BAR="''${BAR}■"; done
        for i in $(seq 1 $EMPTY);  do BAR="''${BAR}□"; done
        BAR="''${BAR}]"

        notify-send -r 5556 -t 700 -i "display-brightness" "Brillo ''${PERCENT}%" "$BAR"
      '';
    };
  };
}
