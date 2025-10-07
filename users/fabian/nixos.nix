{ pkgs, inputs, ... }:

{
    programs.zsh.enable = true;

    users.users.fabian = {
        isNormalUser = true;
        home = "/home/fabian";
        extraGroups = [ "wheel" ];
        hashedPassword = "$6$aLs0hqyuBRFZV6LA$pOwdLCBGJ5RVFBqNKkAcdjVRJPxMZMdgIXRruNy59q6T6xTuoSfpM47LezIomaEkth4KmNsWfOVNs0uXeSNJb/";
        shell = pkgs.zsh;
    };
}
