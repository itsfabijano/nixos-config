{
    description = "Basic NixOS Flake with an imported module";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        opencode = {
            url = "github:anomalyco/opencode/v1.2.14";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };
    };


    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, opencode }:
    let
        system = "aarch64-linux";
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        mkSystem = import ./lib/mk-system.nix {
            inherit nixpkgs; inherit nixpkgs-unstable; inherit home-manager; inherit opencode;
        };
    in {
        devShells.${system} = import ./devshells.nix { inherit pkgs; };

        nixosConfigurations = { 
            vm-aarch64 = mkSystem "vm-aarch64" {
                system = "aarch64-linux";
            };

            vm-aarch64-work = mkSystem "vm-aarch64-work" {
                system = "aarch64-linux";
            };
        };
    };
}

