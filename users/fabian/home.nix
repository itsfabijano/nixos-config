{ config, pkgs, pkgsUnstable, lib, ... }:
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
        DOTNET_ROOT = "${pkgs.dotnet-sdk_9}/share/dotnet";
        NVIM_F_LSP = "1";
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

    # Make sure to write user manually, since order is not guaranteed
    # This gets inserted before any other git config
    xdg.configFile."git/config".text = ''
    [user]
      name = ${variables.git.default.userName}
      email = ${variables.git.default.userEmail}
    '';

    programs.git = {
        enable = true;
        extraConfig = {
            push = { autoSetupRemote = true; };
            includeIf."gitdir:~/repos/personal/" = {
                path = "~/repos/personal/.gitconfig";
            };
            includeIf."gitdir:~/repos/" = {
                path = "~/repos/.gitconfig";
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
