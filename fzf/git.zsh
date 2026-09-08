#! /usr/bin/zsh

# Show Git completions from any command with Ctrl-G chords.
_fzf-git-complete-as() {
  emulate -L zsh
  git rev-parse --is-inside-work-tree &>/dev/null ||
    { zle -M "Not inside a Git repository"; return 1 }

  local completion_command="${1}"
  local original_buffer="${BUFFER}"
  local -i original_cursor="${CURSOR}"

  BUFFER="${completion_command}"
  CURSOR=${#BUFFER}
  zle fzf-tab-complete

  local selection="${BUFFER#${completion_command}}"
  BUFFER="${original_buffer}"
  CURSOR="${original_cursor}"
  [[ -z "${selection}" ]] && return

  [[ -n "${LBUFFER}" && "${LBUFFER[-1]}" != ' ' ]] && LBUFFER+=' '
  LBUFFER+="${selection}"
  zle reset-prompt
}

fzf-git-status-widget() {
  _fzf-git-complete-as 'git add '
}

fzf-git-checkout-widget() {
  _fzf-git-complete-as 'git checkout '
}

fzf-git-widget() {
  zle -M 'Git: [f] status files [c] checkout'
  zle -R

  local key
  read -rk 1 key
  case "${key}" in
    f) zle fzf-git-status-widget ;;
    c) zle fzf-git-checkout-widget ;;
    $'\e') ;;
    *) zle -M "Unknown Git chord: ${key}" ;;
  esac
}

zle -N fzf-git-status-widget
zle -N fzf-git-checkout-widget
zle -N fzf-git-widget
bindkey -M viins '^G' fzf-git-widget
bindkey -M emacs '^G' fzf-git-widget
