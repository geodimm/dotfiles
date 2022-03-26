#!/usr/bin/env zsh
# vim: foldmethod=marker
# vim: set filetype=zsh

export FZF_DEFAULT_COMMAND='find -L'
export FZF_DEFAULT_OPTS="--bind 'ctrl-v:execute(vim {})+abort,?:toggle-preview,alt-a:select-all,alt-d:deselect-all' --tiebreak=index --cycle --preview-window right:50%:border:wrap"
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --color=dark,fg:7,bg:-1,hl:5,fg+:15,bg+:8,hl+:13,info:2,prompt:4,pointer:1,marker:3,spinner:4,header:4"
export FZF_CTRL_R_OPTS="--layout=reverse --preview-window hidden"

# fzf-tab settings
#
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# remove prefix
zstyle ':fzf-tab:*' prefix ''

# Whether to automatically insert a space after the result.
zstyle ':fzf-tab:*' insert-space false

# The preview command used by fzf-tab (show file or directory contents on completion)
zstyle ':fzf-tab:complete:*:*' fzf-preview '(bat --color=always --pager=never ${realpath} || lsd --color=always --long -A --group-dirs=first ${realpath}) 2>/dev/null'

zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

# show systemd unit status
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# environment variable
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'

test -f "${HOME}/.fzf.zsh" && source "${HOME}/.fzf.zsh"
