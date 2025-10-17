{ config, pkgs, ... }:

{
  home.packages = [ pkgs.unison ];

  systemd.user.services.unison-sync = {
    Unit = {
      Description = "Unison bidirectional sync";
    };
    Service = {
        Type = "oneshot";
        ExecStartPre = "/run/current-system/sw/bin/mkdir -p /mnt/utm/nixbox-shared/repos";
        ExecStart = ''
        ${pkgs.unison}/bin/unison /home/fabian/repos /mnt/utm/nixbox-shared/repos \
          -auto -batch -prefer=newer \
          -ignore='Name .git' -ignore='Name node_modules' -ignore='Name target'
      '';
    };
  };

  systemd.user.timers.unison-sync = {
    Unit = { Description = "Run Unison sync periodically"; };
    Timer = {
      OnBootSec = "5min";
      OnUnitActiveSec = "10min";
      Unit = "unison-sync.service";
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };
}
