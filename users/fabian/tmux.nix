{ pkgs, ... }:
let 
    tmuxGit = pkgs.tmux.overrideAttrs (oldAttrs: rec {
        pname = "tmux-git";
        src = pkgs.fetchFromGitHub {
          owner = "tmux";
          repo = "tmux";
          rev = "0ff2676a2594aa6a26de7232e605640c28021f28";
          sha256 = "sha256-W7Z6ECsj0PuL+Z+tTI+cNq/ba+iyoKsdmnFDm/u2rGQ="; 
        };
  });
in
{
    home.packages = [
        tmuxGit
    ];

    programs.tmux = {
        enable = true;
        keyMode = "vi";
        mouse = true;
        baseIndex = 1;
        prefix = "C-a";
        terminal = "tmux-256color";
        escapeTime = 0;
        shortcut = "a";
        extraConfig = builtins.readFile ./tmux.conf;
        package = tmuxGit;
    };
}
