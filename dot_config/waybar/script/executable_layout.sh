#!/usr/bin/env bash

info="$(hyprctl devices -j | jq '.keyboards.[] | select(.main==true)')"
index="$(echo $info | jq '.active_layout_index')"
layouts="$(echo $info | jq -r '.layout')"

IFS=', ' read -ra LAYOUTS <<<"$layouts"

echo "⌨ ${LAYOUTS[$index]^^}"
