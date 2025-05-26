#!/usr/bin/env bash

windows="$(hyprctl clients -j | jq -c '.[]')"
classes="$(echo "${windows}" | jq -cr '.class')"
titles="$(echo "${windows}" | jq -cr '.title')"
addresses="$(echo "${windows}" | jq -cr '.address')"

echo "$classes"
echo "$titles"
echo "$addresses"

exit

selected="$(echo "${entries}" | rofi -dmenu -i -p "Select window")"

selected_title="$(echo "${selected}" | awk -F'|' '{print $2}' | sed 's@\(^\s*\|\s*$\)@@g')"
selected_window="$(echo "${windows}" | jq --arg title "$selected_title" -c 'select(.title == $title)')"
selected_pid="$(echo "${selected_window}" | jq '.pid')"

hyprctl dispatcher focuswindow pid:"${selected_pid}"
