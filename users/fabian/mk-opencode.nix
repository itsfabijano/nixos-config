{ pkgs, lib }:
{ }:

let
    version = "1.17.7";
    assets = {
      "x86_64-linux" = {
        name = "opencode-linux-x64.tar.gz";
        hash = lib.fakeHash;
      };

      "aarch64-linux" = {
        name = "opencode-linux-arm64.tar.gz";
        hash = "sha256-rIDqDufj8QSDvZgphlS2qt3DBciAsWJmegPnQtmEP+Y=";
      };
    };

    system = pkgs.stdenv.hostPlatform.system;
    asset =
        assets.${system}
        or (throw "Unsupported system: ${system}");
in
pkgs.stdenvNoCC.mkDerivation {
    pname = "opencode";
    inherit version;
    sourceRoot = ".";

    src = pkgs.fetchurl {
        name = "opencode-${version}-${asset.name}";
        url = "https://github.com/anomalyco/opencode/releases/download/v${version}/${asset.name}";
        hash = asset.hash;
    };

    installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        cp opencode $out/bin/opencode
        chmod +x $out/bin/opencode
        runHook postInstall
    '';
}
