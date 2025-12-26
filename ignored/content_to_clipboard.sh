#!/usr/bin/env bash

chezmoi cd || exit 0
content="$(
	find . -type f \
		-not -path '*/.git*' \
		-not -path '*/ignored*' \
		-not -name '*.jpg' \
		-not -name '*.png' \
		-not -name '*.webp' \
		-exec cat {} \;
)"
echo "$content" | wl-copy
