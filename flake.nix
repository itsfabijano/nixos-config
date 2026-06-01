{
    description = "Basic NixOS Flake with an imported module";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        opencode = {
            url = "github:anomalyco/opencode/v1.15.3";
            # url = "github:anomalyco/opencode";
            # url = "github:anomalyco/opencode/e4957a78eae1bd218b7d2ddc8d4ad0a1866ab674";
        };
        templ.url = "github:a-h/templ";
    };


    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, opencode, templ }:
    let
        system = "aarch64-linux";

        overlays = [
            templ.overlays.default
            opencode.overlays.default
        ];

        mkSystem = import ./lib/mk-system.nix {
            inherit nixpkgs nixpkgs-unstable home-manager overlays;
        };

        mkDevshells = import ./lib/mk-devshells.nix {
            inherit nixpkgs overlays;
        };
    in {
        devShells.${system} = mkDevshells { inherit system; };

        nixosConfigurations = { 
            vm-aarch64 = mkSystem "vm-aarch64" {
                system = "aarch64-linux";
            };

            vm-aarch64-work = mkSystem "vm-aarch64-work" {
                system = "aarch64-linux";
                envVars = {
                    OPENCODE_CONFIG_DIR = "/home/fabian/repos/sii/opencode-config";
                };
            };
        };
    };
}
