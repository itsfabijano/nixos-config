{ config, pkgs, ... }:

{
    imports = [
        ./hardware/vm-aarch64-utm.nix
    ];

    services.qemuGuest.enable = true; # Virtio optimizations
    # services.qemuGuest.agent.enable = false;

    # services.spice-vdagentd.enable = true;

    # fileSystems."/" = {
    #     device = "/dev/disk/by-label/nixos";
    #     fsType = "ext4";
    # };
}

