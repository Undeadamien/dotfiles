#!/usr/bin/env bash

pgrep -f "$0" | grep -vw "$$" | xargs -r kill

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
		swww img "$current"
	fi
	sleep "$interval"
done
