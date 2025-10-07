{ config, pkgs, ... }:

{
    imports = [
        ./hardware/vm-aarch64-utm.nix
    ];

    services.qemuGuest.enable = true; # Virtio optimizations
    services.spice-vdagentd.enable = true;

    # Define the 9p filesystem for the shared folder
    fileSystems."/mnt/utm" = {
        device = "share";
        fsType = "9p";
        options = [
            "trans=virtio"
            "version=9p2000.L"
            "rw"
            "_netdev"
            "nofail"
            "auto"
        ];
    };

    # fileSystems."/" = {
    #     device = "/dev/disk/by-label/nixos";
    #     fsType = "ext4";
    # };
}

