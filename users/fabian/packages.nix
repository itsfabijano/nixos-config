{ config, pkgs, pkgs-unstable, pkgs-custom, extraHomePackages ? [ ], ... }:

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
    ];
    unstable = with pkgs-unstable; [
        bun
        pnpm
        neovim
        nodejs_24
        httpie
        typescript
        rustup
    ];
    custom = with pkgs-custom; [
        opencode
    ];
in {
    home.packages = stable ++ unstable ++ custom ++ extraHomePackages;
}
