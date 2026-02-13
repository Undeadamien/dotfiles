#!/usr/bin/env bash

set -euo pipefail

current="wallpaper"
wallpaper_dir="$HOME/.config/hypr/wallpaper/"
interval=1800
manual=false

change_wallpaper() {
    wallpapers="$(find "${wallpaper_dir}" -not -name "${current}" -type f)"
    selected="$(echo "$wallpapers" | shuf -n1)"
    if [ -z "$selected" ]; then return; fi
    ln -sf "$selected" "${wallpaper_dir}/${current}"
    swww img --transition-duration 8 --transition-fps 60 "${wallpaper_dir}/${current}"
}

manual_select() {
    selection="$(
        for img in "$wallpaper_dir"/*; do
            [ "$(basename "$img")" = "$current" ] && continue
            echo -en "$(basename "$img")\0icon\x1f$img\n"
        done | rofi -dmenu -theme wallpaper.rasi -p "wallpapers" || true
    )"

    if [[ -z "$selection" ]] || [[ ! -e "$wallpaper_dir/$selection" ]]; then
        manual=false
        notify-send "wallpaper: auto"
        return
    fi

    ln -sf "$wallpaper_dir/$selection" "$wallpaper_dir/$current"
    swww img "$wallpaper_dir/$current" --transition-duration 4 --transition-type center --transition-fps 60
    notify-send "wallpaper: manual"
    manual=true
}

if ! pgrep -x swww-daemon >/dev/null; then hyprctl dispatch exec swww-daemon; fi
if ! pgrep -x Hyprland >/dev/null; then exit 1; fi

trap 'manual_select' SIGUSR1

change_wallpaper
last_change=$(date +%s)

while true; do
    if ! pgrep -x Hyprland >/dev/null; then break; fi
    if $manual; then
        sleep 1
        continue
    fi
    if pgrep -x hyprlock >/dev/null; then
        sleep 5
        last_change=$((last_change + 5))
        continue
    fi

    now=$(date +%s)
    elapsed=$((now - last_change))
    if [ "$elapsed" -ge "$interval" ]; then
        change_wallpaper
        last_change=$now
    fi
    sleep 1
done
