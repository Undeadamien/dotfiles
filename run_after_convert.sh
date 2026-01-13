#!/usr/bin/env bash

set -euo pipefail

src="hex.toml"
dst="rgb.toml"

cd "$HOME/.local/share/chezmoi/.chezmoidata/" || exit 1
if [[ ! -f "$src" ]]; then exit 1; fi

: >"$dst"
while read -r line; do
	if [[ "$line" =~ ^\[hex\] ]]; then
		echo "[rgb]" >>"$dst"
		continue
	fi
	if [[ "$line" =~ ^(.+?)[[:space:]]*=[[:space:]]*\"#([0-9a-fA-F]{6})\" ]]; then
		key=$(echo "${BASH_REMATCH[1]}" | xargs)
		val="${BASH_REMATCH[2]}"

		r=$((16#${val:0:2}))
		g=$((16#${val:2:2}))
		b=$((16#${val:4:2}))

		echo "$key = \"$r, $g, $b\"" >>"$dst"
	else
		echo "$line" >>"$dst"
	fi
done <"$src"
