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
        
