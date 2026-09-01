{ config, pkgs, pkgs-unstable, extraHomePackages ? [ ], ... }:

let
    stable = with pkgs; [
        git
        python3
        python3Packages.pip
        fzf
        zathura
        dotnetCorePackages.dotnet_10.sdk
        csharp-ls
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
        pnpm
        neovim
        nodejs_26
        httpie
        typescript
        rustup
        luaPackages.tree-sitter-cli
        go
        air
        templ
    ];
in {
    home.packages = stable ++ unstable ++ extraHomePackages;
}
