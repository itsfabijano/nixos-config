{ config, lib, pkgs, ... }:

let
    runtimeLibs = with pkgs; [
        stdenv.cc.cc.lib
        libgbm
        systemd
        zlib
        openssl
        curl
        glib
        nspr
        nss
        dbus
        expat
        cups
        alsa-lib
        atk
        at-spi2-atk
        at-spi2-core
        cairo
        pango
        gtk3
        xorg.libX11
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        xorg.libxcb
        libxkbcommon
        mesa
    ];
in {
    system.stateVersion = "24.11";
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnsupportedSystem = true;

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
    networking.firewall.enable = false; # Disable firewall for simplicity

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
        fastfetch
        git
        which
        clang
        unzip
        bash
        home-manager
        ripgrep
        fd
        xorg.xauth # for x11 forwarding
        gcc
        docker
        nix-prefetch-github
        lsof
        fio
        openssl
        icu
    ];

    users.defaultUserShell = pkgs.zsh;

    virtualisation.docker.enable = true;

    # Needed to run dynamically linked executables (eg. sst with bun)
    programs.nix-ld = {
        enable = true;
        # needed to run sharp with bun
        libraries = runtimeLibs;
    };

    # environment.sessionVariables = {
        # needed to run sharp with bun
        # LD_LIBRARY_PATH = lib.makeLibraryPath runtimeLibs;
    # };

}
