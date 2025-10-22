#!/usr/bin/env bash

cd "$(dirname "$0")" || exit

DIRS="$(find . -mindepth 1 -maxdepth 1 -not -path './.git*' -type d | sed 's@^./@@')"

for dir in $DIRS; do
	echo "stowing: '${dir}'"
	stow --restow --dotfiles --no-folding "$dir"
done
