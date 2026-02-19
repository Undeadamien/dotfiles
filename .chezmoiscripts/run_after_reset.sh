#!/usr/bin/env bash

set -euo pipefail

programs=(waybar swaync)
wallpaper_script="$HOME/.config/hypr/script/wallpaper_selector.sh"

if ! command -v hyprctl >/dev/null; then exit 1; fi

for program in "${programs[@]}"; do
    pkill -x "$program" 2>/dev/null || true
    hyprctl dispatch exec "$program" >/dev/null
done

if pgrep -f 'wallpaper_selector.sh' >/dev/null; then
    pkill -f 'wallpaper_selector.sh' 2>/dev/null || true
fi
if [[ -f "$wallpaper_script" ]]; then
    hyprctl dispatch exec "$wallpaper_script" >/dev/null || true
fi
hyprctl reload --quiet
