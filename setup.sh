#!/bin/bash

for file in $(find "home" -type f); do
	link="${HOME}/${file#home/}"
	mkdir -p "$(dirname "$link")"

	if [[ -e "$link" ]] && [[ $(diff "$file" "$link") ]]; then
		diff "$file" "$link"
		read -p "Do you want to replace the file (y/n): " res
		if [[ "$res" =~ ^[yY]$ ]]; then
			printf "Replacing the file %s\n" $link
			ln -sf "$PWD/$file" "$link"
		else
			printf "Skipping the file %s\n" $link
		fi
	elif [[ -e "$link" ]]; then
		printf "Replacing the file %s\n" $link
		ln -sf "$PWD/$file" "$link"
	else
		printf "Creating the file %s\n" $link
		ln -s "$PWD/$file" "$link"
	fi
done
