#!/usr/bin/env bash

windows="$(hyprctl clients -j | jq -c '.[]')"
entries="$(echo "${windows}" | jq -c -r '[.class,.title]')"
echo "$entries"

selected="$(echo "${entries}" | rofi -dmenu -i -p "Select window")"

selected_window="$(echo "${windows}" | jq --arg title "$selected" -c 'select(.title == $title)')"
selected_pid="$(echo "${selected_window}" | jq '.pid')"

hyprctl dispatcher focuswindow pid:"${selected_pid}"
