#!/usr/bin/env bash

entries="$(
	hyprctl clients -j |
		jq -c '. | sort_by(.workspace.name) | .[] | [.class,.title,.address,.workspace.name]'
)"
echo "$entries"
formatted="$(
	echo "$entries" |
		jq -cr '"\(.[3])\t\(.[0])\t\"\(.[1])\""' |
		column -t -o $'\t| ' -s $'\t'
)"
echo "$formatted"
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
