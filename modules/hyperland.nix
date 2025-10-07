{ config, pkgs, ... }:

{
    # Enable Hyprland
    programs.hyprland.enable = true;

    # services.xserver.enable = false;
    # services.xserver.displayManager.gdm.enable = false; # Disable GDM if it was enabled
    # services.displayManager.sddm.enable = false; # Disable SDDM if it was enabled

    # Enable GPU acceleration for VirtIO-GPU
    # hardware.graphics = {
    #   enable = true;
    # };

    # Install essential Wayland packages
    environment.systemPackages = with pkgs; [
        kitty 
    ];
}
