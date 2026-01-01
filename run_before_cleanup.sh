#!/usr/bin/env bash

wallpaper_dir="$HOME/.config/hypr/wallpaper"
current="wallpaper.jpg"

if [[ ! -d "$wallpaper_dir" ]]; then exit 0; fi

unmanaged="$(chezmoi unmanaged "$wallpaper_dir" -p absolute | grep -v "${wallpaper_dir}/${current}")"

[[ -z $unmanaged ]] && exit 0

echo "$unmanaged"
read -r -p "Delete the above files? [y/n]" answer

[[ ! $answer =~ [Yy]$ ]] && exit 0

while IFS= read -r file; do
	rm -rf "$file"
done <<<"$unmanaged"
