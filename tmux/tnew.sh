#!/usr/bin/env bash

SESSION_NAME="work"

if tmux has-session -t ${SESSION_NAME}
then
    tmux -2 attach-session -t ${SESSION_NAME}
else
    tmux new-session -s ${SESSION_NAME} -n "repos" -d
    tmux send-keys -t ${SESSION_NAME}:1 'cd /repos' C-m
    tmux -2 attach-session -t ${SESSION_NAME}
fi
