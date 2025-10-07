#!/usr/bin/env bash

set -a;
source .env; 
set +a; 

sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 \
    GIT_USER_EMAIL=$GIT_USER_EMAIL \
    nixos-rebuild switch --flake ./#vm-aarch64

