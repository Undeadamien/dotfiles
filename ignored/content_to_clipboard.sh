#!/usr/bin/env bash

cd "${HOME}/.local/share/chezmoi" || exit 0

if command -v wl-copy >/dev/null; then
	clipboard=(wl-copy)
elif command -v xclip >/dev/null; then
	clipboard=(xclip -selection clipboard)
else
	echo "No clipboard provided"
	exit 0
fi

content="$(
	find . -type f \
		-not -path '*/.git*' \
		-not -path '*/ignored*' \
		-not -name '*.jpg' \
		-not -name '*.png' \
		-not -name '*.webp' \
		-exec echo {} \; \
		-exec cat {} \;
)"
echo "$content" | "${clipboard[@]}"
