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
        system = "aarch64-linux";
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        mkSystem = import ./lib/mk-system.nix {
            inherit nixpkgs; inherit nixpkgs-unstable; inherit home-manager;
        };
    in {
        devShells.${system} = {
            dotnet8 = pkgs.mkShell { 
                packages = [ pkgs.dotnet-sdk_8 ];
                shellHook = ''
                    export PATH="$PATH:/home/fabian/.dotnet/tools"
                    if ! command -v csharp-ls >/dev/null 2>&1; then
                        dotnet tool install -g csharp-ls --version 0.16.0
                    fi
                '';
            };
        };

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

