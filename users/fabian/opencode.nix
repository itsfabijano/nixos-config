{ pkgs-unstable, envVars, lib, ... }:

let
    opencode = pkgs-unstable.opencode;
    opencodeConfigDir = envVars.OPENCODE_CONFIG_DIR or "/home/fabian/.config/opencode";
    servicePath = lib.makeBinPath [
        pkgs-unstable.bun
        pkgs-unstable.nodejs
        pkgs-unstable.go
    ];
in {
    home.packages = [ 
        opencode

        (pkgs-unstable.writeShellScriptBin "oc" ''
            #!/usr/bin/env bash
            exec ${opencode}/bin/opencode attach http://localhost:4096 --dir "$PWD" "$@"
        '')
    ];

    systemd.user.services.opencode-server = {
        Unit = {
            Description = "Opencode Server";
            After = [ "network.target" ];
        };

        Service = {
            Environment = [
                "OPENCODE_CONFIG_DIR=${opencodeConfigDir}"
                "PATH=${servicePath}"
            ];
            ExecStart = "${opencode}/bin/opencode serve --port 4096 --hostname 0.0.0.0";
            Restart = "on-failure";
            RestartSec = 5;
        };

        Install.WantedBy = [ "default.target" ];
    };
}
