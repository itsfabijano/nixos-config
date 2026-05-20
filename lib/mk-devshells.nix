{ nixpkgs, overlays }:
{ system }:

let
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; inherit overlays; };
in {
    dotnet8 = import ../devshells/dotnet8/shell.nix { inherit pkgs; };
}
