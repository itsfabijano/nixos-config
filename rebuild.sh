#!/usr/bin/env bash

set -a;
source .env; 
set +a; 

CONFIG_NAME=${CONFIG_NAME:-"vm-aarch64"}

sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 \
    GIT_USER_EMAIL=$GIT_USER_EMAIL \
    nixos-rebuild switch --flake ./#$CONFIG_NAME

