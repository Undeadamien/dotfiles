#!/usr/bin/env bash

set -euo pipefail

source_dir="${HOME}/.config/hypr/wallpaper"
cache="${XDG_CACHE_HOME:-${HOME}/.cache}/hypr/wallpaper-thumbs"
size=768

mkdir -p "${cache}"

thumb() {
    local input="$1"
    local output="$2"
    local staging="${output}.tmp.jpg"

    if command -v vipsthumbnail &>/dev/null; then
        vipsthumbnail -s "${size}" -o "${staging}" "${input}" 2>/dev/null
    elif command -v magick &>/dev/null; then
        magick "${input}" -resize "${size}x>" -strip -quality 88 "${staging}"
    else
        cp "${input}" "${output}"
        return
    fi

    mv "${staging}" "${output}"
}

for image in "${source_dir}"/*; do
    [ -f "${image}" ] || continue
    cached="${cache}/${image##*/}"
    if [ ! -f "${cached}" ] || [ "${image}" -nt "${cached}" ]; then
        thumb "${image}" "${cached}"
    fi
done
