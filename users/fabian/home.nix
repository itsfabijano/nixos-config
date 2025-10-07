{ config, pkgs, config-nvim, lib, ... }:
let 
    variables = builtins.fromJSON (builtins.readFile /tmp/nixos-config/.variables.json);
in
{
    imports = [
        ./scripts.nix
        ./packages.nix
    ];

    home.stateVersion = "25.05";

    xdg.enable = true;

    home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
    };

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
                "vi-mode"
                "git"
                "fzf"
            ];
        };
        syntaxHighlighting = {
            enable = true;
        };
        initContent = ''
            bindkey -s ^f "tmux-session\n"
        '';
    };

    programs.neovim = {
        enable = true;
        withPython3 = true;
    };

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

    programs.git = {
        enable = true;
        userName = variables.git.default.userName;
        userEmail = variables.git.default.userEmail;
        extraConfig = {
            push = { autoSetupRemote = true; };
            includeIf."gitdir:/home/fabian/repos/personal/" = {
                path = "/home/fabian/repos/personal/.gitconfig";
            };
            includeIf."gitdir:/home/fabian/repos/" = {
                path = "/home/fabian/repos/.gitconfig";
            };
        };
    };

    home.file."repos/personal/.gitconfig".text = ''
        [user]
            name = ${variables.git.personal.userName}
            email = ${variables.git.personal.userEmail}
        [core]
            sshCommand = ssh -i ~/.ssh/id_rsa_github_personal -F /dev/null
    '';

    xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/personal/config.nvim";

    programs.direnv = {
        enable = true;
        enableZshIntegration = true; 
    };

}
