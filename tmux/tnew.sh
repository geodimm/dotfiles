#!/bin/sh

SESSION_NAME="work"

tmux has-session -t ${SESSION_NAME}

if [ $? != 0 ]
then
    tmux new-session -s ${SESSION_NAME} -n "bash" -d
    tmux new-window -n "vim" -t ${SESSION_NAME}
    tmux new-window -n "htop" -t ${SESSION_NAME}
    tmux new-window -n "deploy" -t ${SESSION_NAME}
    tmux send-keys -t ${SESSION_NAME}:1 'cd /repos' C-m
    tmux send-keys -t ${SESSION_NAME}:2 'cd /repos' C-m
    tmux send-keys -t ${SESSION_NAME}:3 'sudo htop' C-m
    tmux send-keys -t ${SESSION_NAME}:4 'cd /repos/env/deploy && gu' C-m
    tmux select-window -t ${SESSION_NAME}:3
    tmux -2 attach-session -t ${SESSION_NAME}
fi
