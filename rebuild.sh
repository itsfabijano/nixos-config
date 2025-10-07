#!/usr/bin/env bash

set -a;
source .env; 
set +a; 

CONFIG_NAME=${CONFIG_NAME:-"vm-aarch64"}

echo $GIT_USER_EMAIL

sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 \
    nixos-rebuild switch --flake ./#$CONFIG_NAME

