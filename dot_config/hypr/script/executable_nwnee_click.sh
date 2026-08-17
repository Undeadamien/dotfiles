#!/usr/bin/env bash
ACTIVE="$(hyprctl activewindow -j | jq -r '.initialTitle')"
if [[ ! "$ACTIVE" =~ "Neverwinter Nights" ]]; then exit; fi

X="$(hyprctl cursorpos | cut -d, -f1)"
Y="$(hyprctl cursorpos | cut -d, -f2)"

MONITOR="$(hyprctl activewindow -j | jq -r '.monitor')"
RES_W=$(hyprctl monitors -j | jq -r --argjson m "$MONITOR" '.[$m] | (.width / .scale | floor)')
RES_H=$(hyprctl monitors -j | jq -r --argjson m "$MONITOR" '.[$m] | (.height / .scale | floor)')

case "${RES_W}x${RES_H}" in
    2560x1440) BTN_X=1215; BTN_Y=781 ;;
    1920x1080) BTN_X=911;  BTN_Y=586 ;;
    *)         BTN_X=$((RES_W / 2)); BTN_Y=$((RES_H / 2)) ;;
esac

ydotool click 0xC0
ydotool mousemove -a -x "$BTN_X" -y "$BTN_Y"
ydotool click 0xC0
ydotool mousemove -a -x "$X" -y "$Y"
