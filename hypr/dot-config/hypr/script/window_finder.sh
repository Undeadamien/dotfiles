#!/usr/bin/env bash

entries="$(
	hyprctl clients -j |
		jq -c '.[] | [.class,.title,.address]'
)"
formatted="$(
	echo "$entries" |
		jq -cr '"\(.[0])\t\"\(.[1])\""' |
		column -t -o ' | ' -s $'\t'
)"
selected="$(
	echo "${formatted}" |
		rofi -dmenu -i -p "Select window" -format d -show-icons=false
)"
target="$(
	echo "$entries" |
		sed -n "${selected}p" |
		jq -cr '.[2]'
)"

hyprctl dispatcher focuswindow address:"${target}"
