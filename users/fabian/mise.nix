{ pkgs-unstable, ... }:

{
    programs.mise = {
        enable = true;
        enableZshIntegration = true;
        package = pkgs-unstable.mise;
        globalConfig = {
            tools = {
                hunk = "0.20.1";
                "npm:@opencode-ai/cli" = "beta";
            };
        };
    };
}
