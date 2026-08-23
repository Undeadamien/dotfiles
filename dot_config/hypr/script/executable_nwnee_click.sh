#!/usr/bin/env bash

set -euo pipefail

is_nwnee() {
    [[ $(hyprctl activewindow -j | jq -r '.initialTitle') =~ "Neverwinter Nights" ]]
}

is_nwnee || exit 0

cursor=$(hyprctl cursorpos)
X=${cursor%%,*}
Y=${cursor##*,}

MONITOR="$(hyprctl activewindow -j | jq -r '.monitor')"
RES_W=$(hyprctl monitors -j | jq -r --argjson m "$MONITOR" '.[$m] | (.width / .scale | floor)')
RES_H=$(hyprctl monitors -j | jq -r --argjson m "$MONITOR" '.[$m] | (.height / .scale | floor)')

case "${RES_W}x${RES_H}" in
2560x1440)
    BTN_X=1215
    BTN_Y=781
    ;;
1920x1080)
    BTN_X=911
    BTN_Y=586
    ;;
*)
    BTN_X=$((RES_W / 2))
    BTN_Y=$((RES_H / 2))
    ;;
esac

for _ in $(seq 5); do
    is_nwnee || exit 0
    ydotool click 0xC0
    ydotool mousemove -a -x "$BTN_X" -y "$BTN_Y"
    ydotool click 0xC0
    ydotool mousemove -a -x "$X" -y "$Y"
    sleep 0.1
done
