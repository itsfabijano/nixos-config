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

    # load the driver
    boot.kernelModules = [ "virtiofs" ];

    # declarative mount
    fileSystems."/mnt/utm" = {
        device = "share";    # must match the tag name you gave in UTM’s “Shared Directory”
        fsType = "virtiofs";
        options = [
            "rw"
            "nofail"
            "_netdev"
            "noauto"
            "x-systemd.automount"  # optional: mount on first access
            # "x-systemd.idle-timeout=300"  # optional: unmount after 5 min idle
        ];
    };
}

