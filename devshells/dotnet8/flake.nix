{
    description = ".NET 8 development shell";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    };

    outputs = { nixpkgs, ... }:
    let
        forAllSystems = nixpkgs.lib.genAttrs [
            "aarch64-linux"
            "x86_64-linux"
        ];
    in {
        devShells = forAllSystems (system:
        let
            pkgs = import nixpkgs { inherit system; };
        in {
            default = import ./shell.nix { inherit pkgs; };
        });
    };
}
