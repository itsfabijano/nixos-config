{ nixpkgs, overlays }:
{ system }:

let
    systemFunc = nixpkgs.lib.nixosSystem;
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; inherit overlays; };
in devshellFunc {
    dotnet8 = import ./devshells/dotnet8/shell.nix { inherit pkgs; };
}
