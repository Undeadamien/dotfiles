#!/usr/bin/env bash

option=$(echo -e "screen\nwindow\narea" | rofi -dmenu -p "Screenshot")

case "$option" in
"screen")
	hyprshot -m output -m active --freeze
	;;
"window")
	hyprshot -m window --freeze
	;;
"area")
	hyprshot -m region --freeze
	;;
esac
