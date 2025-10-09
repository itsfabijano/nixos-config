{ config, pkgs, pkgsUnstable, ... }:

let
    stable = with pkgs; [
        git
        go
        python3
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
    ];
    unstable = with pkgsUnstable; [
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
