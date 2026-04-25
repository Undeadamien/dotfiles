#!/usr/bin/env bash

set -euo pipefail
wallpaper_dir="${HOME}/.config/hypr/wallpaper/"
current="${HOME}/.config/hypr/wallpaper_current"
fps=60
speed=8

set_wallpaper() {
    local target="$1"

    ln -sf "${target}" "${current}"
    awww img "${current}" --transition-duration "${speed}" --transition-type fade --transition-fps "${fps}"
}

manual_select() {
    selection="$(
        for img in "${wallpaper_dir}"/*; do
            echo -en "$(basename "${img}")\0icon\x1f${img}\n"
        done | rofi -dmenu -theme wallpaper.rasi -p "wallpapers" || true
    )"
    if [[ -z "${selection}" ]] || [[ ! -e "${wallpaper_dir}/${selection}" ]]; then return; fi
    set_wallpaper "${wallpaper_dir}/${selection}"
}

if ! pgrep -x awww-daemon >/dev/null; then hyprctl dispatch exec awww-daemon; fi
if ! timeout 2 bash -c 'until awww query >/dev/null 2>&1; do sleep 0.1; done'; then exit 1; fi

if [[ "${1:-}" == "select" ]]; then
    manual_select
    exit 0
fi

wallpapers="$(find "${wallpaper_dir}" -type f)"
selected="$(echo "${wallpapers}" | shuf -n1)"
if [ -z "${selected}" ]; then exit 0; fi
set_wallpaper "${selected}"
