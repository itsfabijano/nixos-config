{ config, pkgs, pkgs-unstable, pkgs-opencode, ... }:

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
        kubeseal
    ];
    unstable = with pkgs-unstable; [
        bun
        neovim
        nodejs_24
        httpie
        claude-code
        typescript
    ];
    opencode-pkgs = with pkgs-opencode; [
        default
    ];
in {
    home.packages = stable ++ unstable ++ opencode-pkgs;
}
