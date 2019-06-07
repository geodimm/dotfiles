#!/bin/sh

SESSION_NAME="work"

if ! tmux has-session -t ${SESSION_NAME}
then
    tmux new-session -s ${SESSION_NAME} -n "deploy" -d
    tmux new-window -n "${SHELL}" -t ${SESSION_NAME}
    tmux send-keys -t ${SESSION_NAME}:1 'cd /repos/env/deploy && gu' C-m
    tmux send-keys -t ${SESSION_NAME}:2 'cd /repos' C-m
    tmux -2 attach-session -t ${SESSION_NAME}
fi
