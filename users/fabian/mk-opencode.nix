{ pkgs, lib }:
{ }:

let
    version = "1.16.0";
    assets = {
      "x86_64-linux" = {
        name = "opencode-linux-x64.tar.gz";
        hash = lib.fakeHash;
      };

      "aarch64-linux" = {
        name = "opencode-linux-arm64.tar.gz";
        hash = "sha256-Bu9gK5vIpiT9yOknZz59qky3Dx5XxVhAI8qTYxxKR24=";
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
