{
    description = "Basic NixOS Flake with an imported module";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };


    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager }:
    let
        system = builtins.currentSystem;
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        pkgsUnstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
    in {
        nixosConfigurations = {
            vm-aarch64 = nixpkgs.lib.nixosSystem {
                system = "aarch64-linux"; 
                modules = [
                    home-manager.nixosModules.home-manager
                    ./modules/basic-config.nix
                    ./users/fabian/nixos.nix
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.extraSpecialArgs = { inherit pkgsUnstable; };
                        home-manager.users.fabian = import ./users/fabian/home.nix;
                    }
                    ./machines/vm-aarch64-utm-avf.nix
                ];
            };

            vm-aarch64-work = nixpkgs.lib.nixosSystem {
                system = "aarch64-linux"; 
                modules = [
                    home-manager.nixosModules.home-manager
                    ./modules/basic-config.nix
                    ./users/fabian/nixos.nix
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.extraSpecialArgs = { inherit pkgsUnstable; };
                        home-manager.users.fabian = import ./users/fabian/home.nix;
                    }
                    ./machines/vm-aarch64-utm-avf.nix
                ];
            };
        };
    };
}

