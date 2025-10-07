{ config, pkgs, ... }:

{
    home.packages = [
        pkgs.git
        (pkgs.writeShellScriptBin "tmux-session" (builtins.readFile ./scripts/tmux-session.sh))
        (pkgs.writeShellScriptBin "tmux-session-init" (builtins.readFile ./scripts/tmux-session-init.sh))
        (pkgs.writeShellScriptBin "nixos-postinstall" (builtins.readFile ./scripts/nixos-postinstall.sh))
    ];
}
