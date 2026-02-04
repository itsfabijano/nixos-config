{ pkgs, ... }:

{
    home.packages = [ pkgs.unison ];

    systemd.user.services.unison-sync = {
        Unit = {
            Description = "Bidirectional Unison sync (polling repeat)";
            RequiresMountsFor = [ "/mnt/utm/repos" ];
        };

        Service = {
            Type = "simple";

            Environment = [
                "UNISONLOCALHOSTNAME=nixos-vm"
            ];

            ExecStart = ''
                ${pkgs.unison}/bin/unison \
                    /home/fabian/repos \
                    /mnt/utm/repos \
                    -repeat 5 \
                    -prefer newer \
                    -batch \
                    -times \
                    -ignore "Name node_modules" \
                    -ignore "Name target" \
                    -ignore "Name .direnv" \
                    -ignore "Name .gitconfig"
            '';

            Restart = "on-failure";
            RestartSec = 10;
            SuccessExitStatus = [ 3 ];
        };

        Install = {
            WantedBy = [ "default.target" ];
        };
    };

}

