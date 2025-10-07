#!/usr/bin/env bash

switch_to() {
    if [[ -z $TMUX ]]; then
        tmux attach-session -t $1
    else
        tmux switch-client -t $1
    fi
}

has_session() {
    tmux list-sessions | grep -q "^$1:"
}

hydrate() {
    if [ -f $2/.tmux-sessionizer ]; then
        tmux send-keys -t $1 "source $2/.tmux-sessionizer" c-M
    elif [ -f $HOME/.tmux-sessionizer ]; then
        tmux send-keys -t $1 "source $HOME/.tmux-sessionizer" c-M
    fi
}


dirs=(
    ~/repos
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ${dirs[@]} -mindepth 0 -maxdepth 2 -type d | fzf)
fi



if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    hydrate $selected_name $selected
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
    hydrate $selected_name $selected
fi

tmux switch-client -t $selected_name
