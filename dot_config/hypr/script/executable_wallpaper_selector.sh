#!/usr/bin/env bash

set -euo pipefail

current="wallpaper"
wallpaper_dir="$HOME/.config/hypr/wallpaper/"

manual_select() {
    selection="$(
        for img in "$wallpaper_dir"/*; do
            [ "$(basename "$img")" = "$current" ] && continue
            echo -en "$(basename "$img")\0icon\x1f$img\n"
        done | rofi -dmenu -theme wallpaper.rasi -p "wallpapers" || true
    )"
    if [[ -z "$selection" ]] || [[ ! -e "$wallpaper_dir/$selection" ]]; then
        return
    fi
    ln -sf "$wallpaper_dir/$selection" "$wallpaper_dir/$current"
    swww img "$wallpaper_dir/$current" --transition-duration 4 --transition-type center --transition-fps 60
}

if ! pgrep -x swww-daemon >/dev/null; then hyprctl dispatch exec swww-daemon; fi
if ! pgrep -x Hyprland >/dev/null; then exit 1; fi

if [[ "${1:-}" == "select" ]]; then
    manual_select
    exit 0
fi

wallpapers="$(find "${wallpaper_dir}" -not -name "${current}" -type f)"
selected="$(echo "$wallpapers" | shuf -n1)"
if [ -z "$selected" ]; then exit 0; fi
ln -sf "$selected" "${wallpaper_dir}/${current}"
swww img --transition-duration 8 --transition-fps 60 "${wallpaper_dir}/${current}"
