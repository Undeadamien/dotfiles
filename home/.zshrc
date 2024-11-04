#!/usr/bin/env zsh

# Enable vi control
set -o vi

# Neovim Config
export PATH="$PATH:/opt/nvim-linux64/bin"

# Auto-completion
autoload -Uz compinit promptinit
compinit
promptinit

# Terminal Prompt
setopt prompt_subst
function update_prompt {
	PS1=$''

	PS1+=$'%{\e[1m%}'
	PS1+=$'%{\e[38;5;15m%}'
	PS1+=$'%n'
	PS1+=$'%{\e[m%}'

	PS1+=$':'

	PS1+=$'%{\e[2m%}'
	PS1+=$'%{\e[38;5;15m%}'
	PS1+=$'%~'
	PS1+=$'%{\e[m%}'

	PS1+=$'%{\e[1m%}'
	PS1+=$'%{\e[38;5;15m%}'
	PS1+=$'$'
	PS1+=$'%{\e[m%}'

	PS1+=$' '
}
update_prompt

# fzf
function fd {
	local target=$(find . -not -path '*/.*' -type d | fzf)
	if [ -n "$target" ] && [ -d "$target" ]; then cd "$target"; fi
}
function ff {
	local target=$(find . -not -path "*/.*" -type f | fzf)
	if [ -n "$target" ] && [ -f "$target" ]; then nvim "$target"; fi
}

# Nvm setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
