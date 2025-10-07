{
    description = "Basic NixOS Flake with an imported module";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
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
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
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
                        home-manager.users.fabian = import ./users/fabian/home.nix;
                    }
                    ./machines/vm-aarch64-utm-avf.nix
                ];
            };
        };


        # Expose home manager configurations
        homeConfigurations = {
            "fabian" = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs {
                    system = "aarch64-linux";
                    config.allowUnfree = true; 
                };
                extraSpecialArgs = { inherit self; }; # Pass self to your home.nix
                modules = [
                    ./users/fabian/home.nix
                    {
                        # Set the username for standalone Home Manager
                        home.username = "fabian";
                        home.homeDirectory = "/home/fabian"; # Also good practice to set
                        home.enableNixpkgsReleaseCheck = false; # Disable the release check
                    }
                ];
            };
        };

    };
}

