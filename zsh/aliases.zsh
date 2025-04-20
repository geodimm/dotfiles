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
    platform="$(uname | tr '[:upper:]' '[:lower:]')"
    LS_OPTS="--color=auto -l --group-directories-first"
    case "${platform}" in
    "linux")
        alias ls="ls ${LS_OPTS}"
        alias lt="ls -ltrh"
        alias la="ls -A"
        ;;
    "darwin")
        alias ls="gls ${LS_OPTS}"
        alias lt="ls -ltrh"
        alias la="ls -A"
        ;;
    esac
fi
alias ll='ls'

alias grepi="grep -i"
alias up="${HOME}/dotfiles/scripts/update.sh"

# git
alias ggrep="git grep -n -I --break --heading -B0 -A0"
alias ggrepi="ggrep --ignore-case"

# rg
# hyperlinked grep for kitty
alias rg="rg --hyperlink-format=kitty"

# docker
docker-clean() {
    docker container prune -f && docker volume prune -f && docker network prune -f
}
