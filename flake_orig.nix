{
    description = "Basic NixOS Flake with an imported module";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/release-24.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };


    outputs = { self, nixpkgs, home-manager }: {
        nixosConfigurations = {
            vm-aarch64 = nixpkgs.lib.nixosSystem {
                system = "aarch64-linux"; 
                modules = [
                    home-manager.nixosModules.home-manager
                    ./modules/basic-config.nix
                    ./users/fabian/nixos.nix
                    # {
                    #     home-manager.useGlobalPkgs = true;
                    #     home-manager.useUserPackages = true;
                    #     home-manager.users.fabian = import ./users/fabian/home.nix;
                    # }
                    ./machines/vm-aarch64-utm.nix
                ];
            };
        };
    };
}

