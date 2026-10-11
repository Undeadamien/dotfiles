#!/usr/bin/env bash

set -euo pipefail
wallpaper_dir="${HOME}/.config/hypr/wallpaper/"
current="${HOME}/.config/hypr/wallpaper_current"
fps=30
speed=8

set_wallpaper() {
    local target="$1"

    ln -sf "${target}" "${current}"
    awww img "${current}" --transition-duration "${speed}" --transition-type fade --transition-fps "${fps}"
}

if ! pgrep -x awww-daemon >/dev/null; then hyprctl dispatch exec awww-daemon; fi
timeout 10 bash -c 'until awww query >/dev/null 2>&1; do sleep 0.2; done' || true

if [[ "${1:-}" == "set" && -n "${2:-}" ]]; then
    set_wallpaper "$2"
    exit 0
fi

wallpapers="$(find "${wallpaper_dir}" -type f)"
selected="$(echo "${wallpapers}" | shuf -n1)"
if [ -z "${selected}" ]; then exit 0; fi
set_wallpaper "${selected}"
