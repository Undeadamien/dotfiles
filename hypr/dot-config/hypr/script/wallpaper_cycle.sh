#!/usr/bin/env bash

wallpaper_dir="${HOME}/.config/hypr/wallpaper"
current=""

while true; do
	selected="$(
		find "${wallpaper_dir}" \
			-not -name "$(basename "${current}")" \
			-name "*.jpg" |
			shuf |
			head -n 1
	)"

	if [ -z "$current" ]; then
		swww img -t none "$(realpath "${selected}")"
	else
		swww img -t fade "$(realpath "${selected}")"
	fi
	current="${selected}"
	sleep 1800
done
