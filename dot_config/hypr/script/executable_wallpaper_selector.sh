#!/usr/bin/env bash
set -euo pipefail

current="wallpaper.jpg"
interval=600
wallpaper_dir="$HOME/.config/hypr/wallpaper/"

if ! pgrep -x swww-daemon >/dev/null; then
	hyprctl dispatch exec swww-daemon
fi

last_change=$(date +%s)

while true; do
	if ! pgrep -x Hyprland >/dev/null; then
		break
	fi
	if pgrep -x hyprlock >/dev/null; then
		sleep 1
		continue
	fi

	now=$(date +%s)
	elapsed=$((now - last_change))
	if [ "$elapsed" -ge "$interval" ]; then
		wallpapers="$(find "${wallpaper_dir}" -not -name "${current}" -type f)"
		selected="$(echo "$wallpapers" | shuf -n1)"
		cp "$selected" "${wallpaper_dir}/${current}"
		swww img \
			--transition-duration 8 \
			--transition-fps 60 \
			"${wallpaper_dir}/${current}"
		last_change=$now
	fi
	sleep 1
done
