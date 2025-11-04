#!/usr/bin/env bash

set -euo pipefail

current="wallpaper.jpg"
interval=600
wallpaper_dir="$HOME/.config/hypr/wallpaper/"
wallpapers="$(find "${wallpaper_dir}" -not -name "${current}" -type f,l)"

if ! pgrep -x swww-daemon >/dev/null; then
	hyprctl dispatch exec swww-daemon
fi

while true; do
	if ! pgrep -x hyprlock >/dev/null; then
		wallpapers="$(find "${wallpaper_dir}" -not -name "${current}" -type f)"
		selected="$(echo "$wallpapers" | shuf -n1)"
		cp "$selected" "${wallpaper_dir}/${current}"
		swww img \
			--transition-duration 8 \
			--transition-fps 60 \
			"${wallpaper_dir}/${current}"
	fi
	sleep "$interval"
done
