{ config, pkgs, ... }:

{
    imports = [
        ./hardware/vm-aarch64-utm-avf.nix
    ];

    services.qemuGuest.enable = true; # Virtio optimizations
    services.spice-vdagentd.enable = true;

    # fileSystems."/" = {
    #     device = "/dev/disk/by-label/nixos";
    #     fsType = "ext4";
    # };
}

