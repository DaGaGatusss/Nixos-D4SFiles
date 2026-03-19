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
    for i in $(seq 1 $FILLED); do BAR="${BAR}■"; done
    for i in $(seq 1 $EMPTY);  do BAR="${BAR}□"; done
    BAR="${BAR}]"
fi

notify-send -r 5555 -t 700 -i "$ICON" "Volumen ${VOLUME}%" "$BAR"
