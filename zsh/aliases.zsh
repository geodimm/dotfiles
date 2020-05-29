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
if cmd_path colorls ; then
    LS_OPTS="--color=always --long --sort-dirs --git-status"
    alias ls="colorls ${LS_OPTS}"
    alias lt="ls -t --reverse"
    alias la="ls --almost-all"
else
    LS_OPTS="--color=auto --group-directories-first"
    alias ls="ls ${LS_OPTS}"
    alias lt="ls -ltrh"
    alias la="ls -A"
fi
alias ll='ls'

alias bat="bat --color=always --theme=Nord"
alias grepi="grep -i"
alias vim="vim -O"

# git
alias ggrep="git grep -n -I --break --heading -B0 -A0"
alias ggrepi="ggrep --ignore-case"
alias gu="git stash && git pull && git stash pop || true"

# docker
docker-clean() {
    docker rm -f $(docker ps -qa) && docker volume rm $(docker volume ls -q)
}

# k8s
jqp () {
    jq -rR '
def colours: {
    "CYAN": "\u001b[36m",
    "MAGENTA": "\u001b[35m",
    "GREEN": "\u001b[32m",
    "RED": "\u001b[31m",
    "BLUE": "\u001b[34m",
    "RESET": "\u001b[0m",
};
def fieldColour: "BLUE";
def fieldPriority: {
    "@timestamp": 1,
    "level": 2,
    "message": 3,
    "DEFAULT": 9999,
};
def valueColour: {
    "@timestamp": "CYAN",
    "level": "MAGENTA",
    "message": "GREEN",
    "error": "RED",
    "DEFAULT": "DEFAULT",
};
def coloured($text; $colour): if $colour == "DEFAULT" then $text else colours[$colour] + $text + colours.RESET end;
def enrich_log_entries: map(.priority = (fieldPriority[.key] // fieldPriority.DEFAULT) | .colour = (valueColour[.key] // valueColour.DEFAULT));
def build_log_lines: map([if .priority < fieldPriority.DEFAULT then empty else coloured(.key; fieldColour) end, coloured(.value; .colour)] | join("=")) | join(" ");

. as $in | try (fromjson | to_entries | enrich_log_entries | sort_by(.priority) | build_log_lines) catch $in'
}

# z with fzf
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')" || return
}

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
