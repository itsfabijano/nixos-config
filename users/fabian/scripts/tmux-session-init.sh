#!/usr/bin/env bash

# i do this to every directory i am in
# 1 is neovim
# 2 is where i run commands
#
# could be cool!!
# this means i could create a neovim plugin to shoot commands out to "scartch"
if [[ "$(pwd)" == $HOME/repos || "$(pwd)" == $HOME/repos/* && "$(pwd)" != $HOME/repos/*/* ]]; then
    clear
    return
fi
tmux new-window -dn nvim 'nvim .; exec $SHELL'
tmux new-window -dn scratch
tmux rename-window "opencode"
oc .
clear
