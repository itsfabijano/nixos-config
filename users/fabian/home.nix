{ config, pkgs, pkgs-unstable, pkgs-custom, lib, envVars, ... }:
let 
    variables = builtins.fromJSON (builtins.readFile /tmp/nixos-config/.variables.json);
    sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        DOTNET_ROOT = "${pkgs.dotnet-sdk_9}/share/dotnet";
        NVIM_F_LSP = "1";
    };
in
{
    imports = [
        ./scripts.nix
        ./packages.nix
        ./tmux.nix
        ./unison.nix
        ./opencode.nix
    ];

    nix.registry.devshells.to = {
        type = "path";
        path = "${config.home.homeDirectory}/repos/personal/nixos-config";
    };

    home.stateVersion = "25.05";

    xdg.enable = true;

    home.sessionVariables = sessionVariables // envVars;

    programs.zsh = {
        enable = true;
        dotDir = config.home.homeDirectory;
        autosuggestion.enable = true;
        shellAliases = {
            vim = "nvim";
            cargodoc = "cargo doc --no-deps && (cd target/doc && python -m http.server 8000)";
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

            if [ -n "$SSH_CONNECTION" ] && [ -z "$TMUX" ]; then
              tmux attach || tmux new -s main
              logout
            fi
        '';
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
        settings = {
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

    xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/personal/dotfiles/home/.config/nvim";
    xdg.configFile.opencode.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/personal/dotfiles/home/.config/opencode";

    # Make sure lua finds the neovim libraries for autocomplete
    home.file.".local/share/nvim/nix-runtime".source = "${pkgs.neovim}/share/nvim/runtime";


    programs.direnv = {
        enable = true;
        enableZshIntegration = true; 
        nix-direnv.enable = true;
    };

}
