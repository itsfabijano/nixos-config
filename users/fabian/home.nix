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
        dotnetCorePackages.dotnet_9.sdk
        gh
        htop
        jq
        ripgrep
        tree
        claude-code
        codex
        opencode
    ];

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

    home.activation.createPersonalProjectsDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${pkgs.coreutils}/bin/mkdir -p /home/fabian/projects/personal/config.nvim
        ${pkgs.coreutils}/bin/mkdir -p /home/fabian/projects/personal/nixos-config
    '';

    xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/personal/config.nvim";

    home.activation.cloneDotfiles = lib.hm.dag.entryAfter [ "setupSSH" ] ''
    #!/usr/bin/env bash
    declare -A TARGET_DIRS=(
      ["git@github.com:itsfabijano/config.nvim.git"]="${config.home.homeDirectory}/repos/personal/config.nvim"
      ["git@github.com:itsfabijano/nixos-config.git"]="${config.home.homeDirectory}/repos/personal/nixos-config"
    )
    success=1  # Assume success unless failure
    for repo_url in ''${!TARGET_DIRS[@]}; do
      target_dir=''${TARGET_DIRS[$repo_url]}
      repo_name=$(basename "$repo_url" .git)

      # Check if the target directory already exists
      if [ -d "$target_dir" ]; then
        echo "Repository $repo_name already exists at $target_dir"
      else
        cmd="${pkgs.git}/bin/git clone --config core.sshCommand=\"${pkgs.openssh}/bin/ssh -i ${config.home.homeDirectory}/.ssh/id_rsa_github_personal\" $repo_url $target_dir"
        echo "Cloning $repo_name to $target_dir..."
        if $cmd; then
          echo "Successfully cloned $repo_name"
        else
          echo "Failed to clone $repo_name"
          success=0
        fi
      fi
    done
    # Optional: exit $success to propagate failure, but activation scripts usually continue
    '';

    home.activation.enableUserDocker = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo "Enabling Docker user service..."
      /run/current-system/sw/bin/systemctl --user enable --now docker
    '';


}
