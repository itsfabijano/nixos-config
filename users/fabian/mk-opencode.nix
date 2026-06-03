{ pkgs, lib }:
{ }:

let
    version = "1.15.13";
    assets = {
      "x86_64-linux" = {
        name = "opencode-linux-x64.tar.gz";
        hash = lib.fakeHash;
      };

      "aarch64-linux" = {
        name = "opencode-linux-arm64.tar.gz";
        hash = "sha256-eg5dokJ8eAQxT+D4e3S0QIRn+U47ixphuiWh1x/gtNI=";
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
