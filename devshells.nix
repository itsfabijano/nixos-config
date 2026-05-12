{ pkgs }:
{
    dotnet8 = import ./devshells/dotnet8/shell.nix { inherit pkgs; };
}
