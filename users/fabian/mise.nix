{ pkgs-unstable, ... }:

{
    programs.mise = {
        enable = true;
        enableZshIntegration = true;
        package = pkgs-unstable.mise;
        globalConfig = {
            settings.npm.package_manager = "bun";

            tools = {
                bun = "1.4.0";
                hunk = "0.20.1";
                "npm:@opencode/cli" = {
                    version = "2.0.8";
                    bun_args = "--trust";
                };
            };
        };
    };
}
