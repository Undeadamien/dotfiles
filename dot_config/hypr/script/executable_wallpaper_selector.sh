#!/usr/bin/env bash

set -euo pipefail

current="$HOME/.config/hypr/wallpaper/wallpaper.jpg"
wallpaper_dir="$HOME/.config/hypr/wallpaper/"

wallpapers="$(find "${wallpaper_dir}" -not -name 'wallpaper.jpg' -type f,l)"
interval=600

if ! pgrep -x swww-daemon >/dev/null; then
	hyprctl dispatch exec swww-daemon
fi

while true; do
	if ! pgrep -x hyprlock >/dev/null; then
		wallpapers="$(find "${wallpaper_dir}" -not -name 'wallpaper.jpg' -type f,l)"
		selected="$(echo "$wallpapers" | shuf -n1)"
		cp "$selected" "$current"
		swww img \
			--transition-duration 8 \
			--transition-fps 60 \
			"$current"
	fi
	sleep "$interval"
done
