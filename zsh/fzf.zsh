#!/usr/bin/env zsh
# vim: foldmethod=marker
# vim: set filetype=zsh

test -f "${HOME}/.fzf.zsh" && source "${HOME}/.fzf.zsh"

FZF_DEFAULT_OPTS=--color=16,fg:7,bg:-1,hl:5,fg+:13,bg+:8,hl+:6,info:2,prompt:4,pointer:13,marker:3,spinner:4,header:4

# fzf-tab settings

# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# remove prefix
zstyle ':fzf-tab:*' prefix ''

# use tmux popup (requires tmux 3.2)
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' fzf-flags --color=16,fg:7,bg:-1,hl:5,fg+:13,bg+:8,hl+:6,info:2,prompt:4,pointer:13,marker:3,spinner:4,header:4

# Whether to automatically insert a space after the result.
zstyle ':fzf-tab:*' insert-space false
