{ config, pkgs, config-nvim, ... }:

{
    imports = [
        ./scripts.nix
    ];

    home.stateVersion = "24.11";

    xdg.enable = true;

    home.packages = with pkgs; [ 
        git
        nodejs
        lazygit
        go
        python3
        fzf
    ];

    programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        oh-my-zsh = {
            enable = true;
            theme = "robbyrussell";
            plugins = [
                "sudo"
                "vi-mode"
                "git"
                "fzf"
            ];
        };
        syntaxHighlighting = {
            enable = true;
        };
    };

    programs.neovim = {
        enable = true;
        withPython3 = true;
    };

    programs.git = {
        enable = true;
        userName = "itsfabijano";
        userEmail = builtins.getEnv "GIT_USER_EMAIL"; 
    };

    programs.tmux = {
        enable = true;
        extraConfig = builtins.readFile ./tmux.conf;
    };
}
