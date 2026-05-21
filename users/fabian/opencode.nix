{ pkgs-unstable, ... }:

let
    opencode = pkgs-unstable.opencode;
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
            ExecStart = "${opencode}/bin/opencode serve --port 4096 --hostname 0.0.0.0";
            Restart = "on-failure";
            RestartSec = 5;
        };

        Install.WantedBy = [ "default.target" ];
    };
}

