{ config, pkgs, ... }:

{

    home.stateVersion = "24.11";

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
