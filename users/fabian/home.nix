{ config, pkgs, config-nvim, lib, ... }:

let 
    variables = builtins.fromJSON (builtins.readFile /home/fabian/repos/personal/nixos-config/.variables.json);
in
{
    imports = [
        ./scripts.nix
    ];

    home.stateVersion = "25.05";

    xdg.enable = true;

    home.packages = with pkgs; [ 
        git
        nodejs
        go
        python3
        fzf
        zathura
    ];

    programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        shellAliases = {
            vim = "nvim";
        };
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
        initExtra = ''
            bindkey -s ^f "tmux-session\n"
        '';
    };

    programs.neovim = {
        enable = true;
        withPython3 = true;
    };

    programs.git = {
        enable = true;
        userName = variables.git.default.userName;
        userEmail = variables.git.default.userEmail;
        extraConfig = {
            includeIf."gitdir:/home/fabian/repos/personal/" = {
                path = "/home/fabian/repos/personal/.gitconfig";
            };
        };
    };

    home.file."repos/personal/.gitconfig".text = ''
        [user]
            name = ${variables.git.personal.userName}
            email = ${variables.git.personal.userEmail}
    '';

    home.activation.createPersonalProjectsDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${pkgs.coreutils}/bin/mkdir -p /home/fabian/projects/personal
    '';

    programs.tmux = {
        enable = true;
        extraConfig = builtins.readFile ./tmux.conf;
    };

    programs.lazygit = {
        enable = true;
        settings = {
            gui = {
                tabWidth = 2;
            };
        };
    };
}
