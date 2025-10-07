{ config, pkgs, config-nvim, ... }:

{
    imports = [
        ./scripts.nix
    ];

    home.stateVersion = "24.11";

    home.packages = with pkgs; [ 
        neovim
        git
    ];

    home.extraActivationPath = [ pkgs.git pkgs.openssh ];

    programs.zsh = {
        enable = true;
        oh-my-zsh = {
            enable = true;
            theme = "robbyrussell";
            plugins = [
                "sudo"
                "vi-mode"
            ];
        };
    };
}
