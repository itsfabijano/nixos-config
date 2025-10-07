{ config, pkgs, ... }:

{
    system.stateVersion = "24.05";

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Define the root filesystem
    fileSystems."/" = {
        device = "/dev/vda1"; # Replace with your root device
        fsType = "ext4";     # Adjust to your filesystem type
    };

    # Example: Enable SSH and install packages
    services.openssh.enable = true;
    services.openssh.settings.PermitRootLogin = "yes";

    security.sudo.wheelNeedsPassword = false;

    environment.systemPackages = with pkgs; [
        zsh
        htop
        neofetch
        git
        which
        clang
        unzip
        bash
    ];

    users.defaultUserShell = pkgs.zsh;

}
