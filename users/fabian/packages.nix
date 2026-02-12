{ config, pkgs, pkgs-unstable, pkgs-custom, ... }:

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
        pnpm
        neovim
        nodejs_24
        httpie
        claude-code
        typescript
    ];
    custom = with pkgs-custom; [
        opencode
    ];
in {
    home.packages = stable ++ unstable ++ custom;
}
