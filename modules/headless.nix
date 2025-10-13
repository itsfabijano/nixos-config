{ config, pkgs, ... }:

{
  systemd.services.xvfb = {
    description = "Virtual X framebuffer";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.xorg.xvfb}/bin/Xvfb :99 -screen 0 1024x768x24";
      Restart = "always";
      StandardOutput = "null";
      StandardError = "null";
    };
    environment = {
      DISPLAY = ":99";
    };
  };
}

