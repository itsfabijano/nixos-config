{ pkgs }:

pkgs.mkShell {
    packages = [ pkgs.dotnet-sdk_8 ];

    shellHook = ''
        export DOTNET_ROOT="${pkgs.dotnet-sdk_8}/share/dotnet"
        export PATH="$HOME/.dotnet/tools:$DOTNET_ROOT:$PATH"

        if ! dotnet tool list -g | grep -q '^csharp-ls '; then
            echo "Installing csharp-ls dotnet tool..."
            dotnet tool install -g csharp-ls --version 0.16.0
        fi
    '';
}
