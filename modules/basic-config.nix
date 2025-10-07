{ config, pkgs, ... }:

{
    system.stateVersion = "24.11";
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Define the root filesystem
    # fileSystems."/" = {
    #     device = "/dev/vda1"; # Replace with your root device
    #     fsType = "ext4";     # Adjust to your filesystem type
    # };


    # Basic networking for VM
    networking.hostName = "nixos";
    networking.useDHCP = true;


    services.openssh = {
        enable = true;
        settings = {
            X11Forwarding = true;
            X11DisplayOffset = 10;
            X11UseLocalhost = true;
        };
    };
    services.openssh.settings.PermitRootLogin = "yes";

    security.sudo.wheelNeedsPassword = false;

    environment.systemPackages = with pkgs; [
        gnumake
        zsh
        htop
        neofetch
        git
        which
        clang
        unzip
        bash
        home-manager
        ripgrep
        fd
        xorg.xauth # for x11 forwarding
    ];

    users.defaultUserShell = pkgs.zsh;

}
