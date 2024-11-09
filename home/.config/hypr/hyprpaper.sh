#!/bin/bash
image_dir=~/.config/hypr/wallpaper/
delay=300

sleep "$delay"
while true; do
	images=$(find "$image_dir" -name "*.jpg")
	image=$(echo "$images" | shuf -n 1)
	if ! hyprctl hyprpaper preload "${image}" &>/dev/null; then exit; fi
	hyprctl hyprpaper unload all
	hyprctl hyprpaper preload ${image}
	hyprctl hyprpaper wallpaper ,${image}
	sleep "$delay"
done
