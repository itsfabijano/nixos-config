{ pkgs, ... }:
let 
    tmuxGit = pkgs.tmux.overrideAttrs (oldAttrs: rec {
        pname = "tmux-git";
        src = pkgs.fetchFromGitHub {
            owner = "tmux";
            repo = "tmux";
            rev = "3.6a";
            # sha256 = pkgs.lib.fakeSha256; 
            sha256 = "sha256-VwOyR9YYhA/uyVRJbspNrKkJWJGYFFktwPnnwnIJ97s=";
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
        escapeTime = 0;
        terminal = "tmux-256color";
        shortcut = "a";
        package = tmuxGit;
        extraConfig = ''
            set -ga terminal-overrides ",xterm-*:RGB"
            set -s extended-keys on
            set -g extended-keys-format csi-u
            set -as terminal-features 'xterm-*:extkeys'
            set -g allow-passthrough on
            set -g set-clipboard on
            set -g focus-events on

            bind r source-file ~/.config/tmux/tmux.conf

            set -g pane-active-border-style bg=default,fg=red
            set -g pane-border-style fg=default
            set -g status-style 'bg=#333333 fg=white'
            setw -g window-status-current-style 'fg=#5eacd3'
            setw -g window-status-current-format ' #I #W #F '
            setw -g window-status-style 'fg=white'
            setw -g window-status-format ' #I #[fg=white]#W #[fg=yellow]#F '
            set -g status-right ""
            set -g status-right-length 10

            # vim-like pane switching
            bind -r ^ last-window
            bind -r k select-pane -U
            bind -r j select-pane -D
            bind -r h select-pane -L
            bind -r l select-pane -R 

            set -g status-left-length 50

            bind-key -r f run-shell "tmux neww tmux-session"
            bind-key -r C run-shell "tmux neww tmux-session ~/repos/personal/nixos-config"
            bind-key -r N run-shell "tmux neww tmux-session ~/repos/personal/config.nvim"
            bind-key -r S run-shell "tmux neww tmux-session #{pane_current_path}"

            # copy functionality
            bind C-u copy-mode \; send -X search-backward "(https?://|git@|git://|ssh://|ftp://|file:///)[[:alnum:]?=%/_.:,;~@!#$&()*+-]*"

            # vim-like visual mode
            bind-key -T copy-mode-vi v send-keys -X begin-selection
            bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        '';
    };
}
