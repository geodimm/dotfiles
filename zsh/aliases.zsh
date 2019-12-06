# vim: set filetype=zsh:

function cmd_path () {
    if [[ ${ZSH_VERSION} ]]; then
        whence -cp "$1" > /dev/null 2>&1
    else  # bash
        type -P "$1" > /dev/null 2>&1
    fi
}

# misc
if cmd_path colorls ; then
    LS_OPTS="-l --sd --gs"
    alias ls="colorls ${LS_OPTS}"
    alias lt="ls -tr"
    alias la="ls -A"
else
    LS_OPTS="--color=auto --group-directories-first"
    alias ls="ls ${LS_OPTS}"
    alias lt="ls -ltrh"
    alias la="ls -A"
fi

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

# z with fzf
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}
