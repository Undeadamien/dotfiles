#!/bin/bash

dirs=$(find . -maxdepth 1 ! -name ".*" -type d -exec basename {} \;)

# select and validate the folder to setup
printf "%s\n" "$dirs"
read -p "Which folder do you want to setup: " target
if [[ ! -d "$target" ]] || ! printf "%s\n" "$dirs" | grep -qx "$target"; then
	printf "Invalid option\n"
	exit 1
fi

# semi-automatic setup of the link
for file in $(find "$target" -type f); do
	link="${HOME}/${file#${target}/}"
	mkdir -p "$(dirname "$link")"
	if [[ -e "$link" ]]; then
		if [[ $(diff "$file" "$link") ]]; then
			diff "$file" "$link"
			read -p "Do you want to replace the file (y/n): " res
			if [[ "$res" =~ ^[yY]$ ]]; then
				ln -sf "$PWD/$file" "$link"
				printf "Replaced %s\n" "$link"
			else
				printf "Skipped %s\n" "$link"
			fi
		elif [[ ! -L "$link" ]]; then
			ln -sf "$PWD/$file" "$link"
			printf "Replaced %s\n" "$link"
		else
			printf "Kept %s\n" "$link"
		fi
	else
		ln -sf "$PWD/$file" "$link" # f in case the link is broken
		printf "Created %s\n" "$link"
	fi
done
