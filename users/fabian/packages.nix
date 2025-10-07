{ config, pkgs, ... }:

{
    home.packages = with pkgs; [ 
        git
        nodejs_24
        go
        python3
        fzf
        zathura
        dotnetCorePackages.dotnet_9.sdk
        gh
        htop
        jq
        ripgrep
        tree
        claude-code
        codex
        opencode
        httpie
        bun
    ];
}
