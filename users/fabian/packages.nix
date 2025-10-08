{ config, pkgs, pkgsUnstable, ... }:

let
    u = pkgsUnstable;
in {
    home.packages = with pkgs; [ 
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

        u.bun
        u.opencode
        u.neovim
        u.nodejs_24
        u.httpie
        u.claude-code
        u.typescript
    ];
}
