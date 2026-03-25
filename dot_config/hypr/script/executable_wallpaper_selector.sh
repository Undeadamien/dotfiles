#!/usr/bin/env bash

set -euo pipefail

wallpaper_dir="${HOME}/.config/hypr/wallpaper/"
current="wallpaper"
fps=60
speed=8

manual_select() {
    selection="$(
        for img in "${wallpaper_dir}"/*; do
            [ "$(basename "${img}")" = "${current}" ] && continue
            echo -en "$(basename "${img}")\0icon\x1f${img}\n"
        done | rofi -dmenu -theme wallpaper.rasi -p "wallpapers" || true
    )"
    if [[ -z "${selection}" ]] || [[ ! -e "${wallpaper_dir}/${selection}" ]]; then return; fi
    ln -sf "${wallpaper_dir}/${selection}" "${wallpaper_dir}/${current}"
    awww img "${wallpaper_dir}/${current}" --transition-duration "${speed}" --transition-type fade --transition-fps "${fps}"
}

if ! pgrep -x awww-daemon >/dev/null; then hyprctl dispatch exec awww-daemon; fi
if ! pgrep -x Hyprland >/dev/null; then exit 1; fi

if [[ "${1:-}" == "select" ]]; then
    manual_select
    exit 0
fi

wallpapers="$(find "${wallpaper_dir}" -not -name "${current}" -type f)"
selected="$(echo "${wallpapers}" | shuf -n1)"
if [ -z "${selected}" ]; then exit 0; fi
ln -sf "${selected}" "${wallpaper_dir}/${current}"
awww img --transition-duration "${speed}" --transition-fps "${fps}" "${wallpaper_dir}/${current}"
