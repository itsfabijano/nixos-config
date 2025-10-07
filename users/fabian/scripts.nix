{ config, pkgs, ... }:

{
    home.packages = [
        pkgs.git
        (pkgs.writeShellScriptBin "nixos-setup-dotfiles" (builtins.readFile ./scripts/nixos-setup-dotfiles.sh))
        (pkgs.writeShellScriptBin "tmux-session" (builtins.readFile ./scripts/tmux-session.sh))
    ];
}
