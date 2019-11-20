# vim: set filetype=zsh:

case "${OSTYPE}" in
    darwin*)
        LS_OPTS="-G"
        ;;
    linux*)
        LS_OPTS="--color=auto --group-directories-first"
        ;;
    *) ;;
esac

# misc
alias ls="ls ${LS_OPTS}"
alias lt="ls -ltrh"
alias grepi="grep -i"
alias vim="vim -O"

# git
alias ggrep="git grep -n -I --break --heading -B0 -A0"
alias ggrepi="ggrep --ignore-case"
alias gu="git stash && git pull && git stash pop || true"

# z with fzf
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}
