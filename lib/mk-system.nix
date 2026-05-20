{ nixpkgs, nixpkgs-unstable, home-manager, overlays }:
name:
{ system }:

let
    machineConfig = ../machines/${name}.nix;
    systemFunc = nixpkgs.lib.nixosSystem;
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    pkgs-unstable = import nixpkgs-unstable { 
        inherit system;
        config.allowUnfree = true;
        inherit overlays;
    };
in systemFunc {
    inherit system;
    modules = [
        home-manager.nixosModules.home-manager
        ../modules/basic-config.nix
        ../users/fabian/nixos.nix
        {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit pkgs-unstable; extraHomePackages = []; };
            home-manager.users.fabian = import ../users/fabian/home.nix;
        }
        ../machines/vm-aarch64-utm-avf.nix
    ];
}
