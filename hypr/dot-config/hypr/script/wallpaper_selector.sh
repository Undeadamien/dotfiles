#!/usr/bin/env bash

current="$HOME/.config/hypr/wallpaper/wallpaper.jpg"
wallpaper_dir="$HOME/.config/hypr/wallpaper/"

wallpapers="$(find "${wallpaper_dir}" -not -name 'wallpaper.jpg' -type f,l)"
selected="$(echo "$wallpapers" | shuf -n1)"

cp "$selected" "$current"
