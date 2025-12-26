#!/usr/bin/env bash

wallpaper_dir="$HOME/.config/hypr/wallpaper"
current="wallpaper.jpg"

if [[ ! -d "$wallpaper_dir" ]]; then exit 0; fi

find "$wallpaper_dir" -mindepth 1 -type f,d -not -path "${wallpaper_dir}/${current}" -delete
