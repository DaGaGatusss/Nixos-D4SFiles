{ config, pkgs, ... }:

let
  i3blocksRs = pkgs.rustPlatform.buildRustPackage {
    pname = "i3blocks-rs";
    version = "0.1.0";
    src = ./scripts/i3blocks-rs;
    cargoLock.lockFile = ./scripts/i3blocks-rs/Cargo.lock;
  };
in

{
  home.file = {
    ".config/i3blocks/config".text = ''
      separator=true
      separator_block_width=15
      align=center
      markup=pango
      border_top=0
      border_bottom=0
      border_left=0
      border_right=0
      color=#eeeeee

      [cpu]
      command=${i3blocksRs}/bin/cpu
      interval=persist
      markup=pango
      color=#dfd932
      min_width=50
      align=right

      [memoria]
      command=${i3blocksRs}/bin/memoria
      interval=30
      color=#52aeff

      [ip]
      command=ip addr | grep 192 | awk '{print $2}' | sed 's/\/.*//g'
      interval=60
      color=#91E78B

      [volume]
      command=$HOME/.config/i3blocks/volume.sh
      LABEL=VOL
      interval=once
      signal=10
      color=#ffa252

      [battery]
      command=${i3blocksRs}
      markup=pango
      interval=30

      [time]
      command=date +'%d/%m/%Y %H:%M'
      interval=1
    '';

    ".config/i3blocks/volume.sh" = {
      executable = true;
      text = ''
        #!/bin/bash
        VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\+%' | head -n1 | tr -d '%')
        MUTE=$(pactl get-sink-mute @DEFAULT_SINK@)

        if [ "$MUTE" = "Mute: yes" ]; then
            echo "MUTED"
            echo "MUTED"
            echo "#FF0000"
        else
            echo "VOL ''${VOLUME}%"
            echo "''${VOLUME}%"
            if [ "$VOLUME" -ge 70 ]; then
                echo "#ffffff"
            elif [ "$VOLUME" -ge 30 ]; then
                echo "#ffa252"
            else
                echo "#FF6600"
            fi
        fi
      '';
    };
  };
}
