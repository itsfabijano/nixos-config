{ config, pkgs, pkgs-unstable, extraHomePackages ? [ ], ... }:

let
    stable = with pkgs; [
        git
        go
        python3
        python3Packages.pip
        fzf
        zathura
        dotnetCorePackages.dotnet_10.sdk
        gh
        btop
        jq
        ripgrep
        tree
        awscli2
        wget
        xclip
        trivy
        kubeseal
        cloc
        k6
    ];
    unstable = with pkgs-unstable; [
        bun
        pnpm
        neovim
        nodejs_24
        httpie
        typescript
        rustup
        luaPackages.tree-sitter-cli
        air
        templ
    ];
in {
    home.packages = stable ++ unstable ++ extraHomePackages;
}
