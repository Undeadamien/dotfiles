#!/usr/bin/env bash

option=$(echo -e "screen\nwindow\narea" | rofi -dmenu -p "Screenshot")

case "$option" in
"screen")
	hyprshot -m output -m active
	;;
"window")
	hyprshot -m window
	;;
"area")
	hyprshot -m region
	;;
esac
