#!/usr/bin/env zsh
# vim: set filetype=zsh

function cmd_path () {
    if [[ ${ZSH_VERSION} ]]; then
        whence -cp "$1" > /dev/null 2>&1
    else  # bash
        type -P "$1" > /dev/null 2>&1
    fi
}

# misc
if cmd_path lsd; then
    LS_OPTS="--color=always --long --group-dirs first"
    alias ls="lsd ${LS_OPTS}"
    alias lt="ls -t --reverse"
    alias la="ls -a"
else
    LS_OPTS="--color=auto --group-directories-first"
    alias ls="ls ${LS_OPTS}"
    alias lt="ls -ltrh"
    alias la="ls -A"
fi
alias ll='ls'

alias grepi="grep -i"
alias up="${HOME}/dotfiles/scripts/update.sh"

# git
alias ggrep="git grep -n -I --break --heading -B0 -A0"
alias ggrepi="ggrep --ignore-case"
alias gu="git stash && git pull && git stash pop || true"

# docker
docker-clean() {
    docker container prune -f && docker volume prune -f && docker network prune -f
}

# tldr
alias tldr="tldr --theme=base16"

# convert minutes {0..60} to {red..green} in hex
function _minutes_to_hex() {
    local num=$1
    local min=0
    local max=60
    local middle=$(((min + max) / 2))
    local scale=$((255.0 / (middle - min)))
    if [[ $num -le $min ]]; then local num=$min; fi
    if [[ $num -ge $max ]]; then local num=$max; fi
    if [[ $num -le $middle ]]; then
        printf "#ff%02x00\n" $(((num - min) * scale))
    else
        printf "#%02xff00\n" $((255 - ((num - middle) * scale)))
    fi
}
