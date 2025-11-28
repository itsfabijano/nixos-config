{ config, pkgs, pkgs-unstable, ... }:

let
    stable = with pkgs; [
        git
        go
        python3
        python3Packages.pip
        fzf
        zathura
        dotnetCorePackages.dotnet_9.sdk
        gh
        btop
        jq
        ripgrep
        tree
        codex
        awscli2
        wget
        xclip
        trivy
    ];
    unstable = with pkgs-unstable; [
        bun
        opencode
        neovim
        nodejs_24
        httpie
        claude-code
        typescript
    ];
in {
    home.packages = stable ++ unstable;
}
