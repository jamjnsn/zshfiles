#!/usr/bin/env zsh

# ==================================================
# 	App replacements
# ==================================================

# Use exa instead of ls
if command -v exa &> /dev/null; then 
    alias ls="exa --group-directories-first --all --icons --classify"
else
    # Add pretty colors if exa isn't available
    alias ls="ls --color=auto"
fi

alias ll="ls -la"

# Use zoxide instead of cd
[ -x "$(command -v zoxide)" ] && alias cd="z"

alias dig="dog"

# ==================================================
# 	zsh directory history
# ==================================================

alias d="dirs -v"
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# ==================================================
# 	Add default flags
# ==================================================

alias mv="mv -iv"
alias cp="cp -riv"
alias mkdir="mkdir -vp"
alias wget="wget -c" # Resume unfinished download

# Add colors
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias df="df -h"
alias du="du -h"
alias free="free -h"
alias diff="diff --color"
alias ip="ip -color"

# Use grc if present
if (( $+commands[grc] )); then
	alias dig="grc \dig"
	alias netstat="grc \netstat"
	alias ping="grc \ping"
	alias tail="grc \tail"
fi

# ==================================================
# 	Docker
# ==================================================

alias dc="docker-compose"
alias dcupdate="dc pull && dc up -d"

# ==================================================
# 	apt
# ==================================================

alias apt="sudo apt"

# ==================================================
# 	Everything else
# ==================================================

# pueue
alias q=pueue

# Switch to root terminal
alias root="sudo -i"