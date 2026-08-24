{ pkgs, pkgs-unstable, envVars, lib, ... }:

let
    opencode = pkgs-unstable.opencode;
    opencodeCommand = lib.getExe opencode;
    opencodeConfigDir = envVars.OPENCODE_CONFIG_DIR or "/home/fabian/.config/opencode";
in {
    home.packages = [ 
        opencode

        (pkgs.writeShellScriptBin "oc" ''
            #!/usr/bin/env bash
            exec ${opencodeCommand} attach http://localhost:4096 --dir "$PWD" "$@"
        '')
    ];

    systemd.user.services.opencode-server = {
        Unit = {
            Description = "Opencode Server";
            After = [ "network.target" ];
        };

        Service = {
            WorkingDirectory = "%h";
            Environment = [
                "OPENCODE_CONFIG_DIR=${opencodeConfigDir}"
                "PATH=%h/.nix-profile/bin:/etc/profiles/per-user/%u/bin:/run/current-system/sw/bin"
                "HOME=%h"
            ];
            ExecStart = "${opencodeCommand} serve --port 4096 --hostname 0.0.0.0";
            Restart = "on-failure";
            RestartSec = 5;
        };

        Install.WantedBy = [ "default.target" ];
    };
}
