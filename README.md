# nixos-config

## Setup Virtual Machine
1. Create New Virtual Machine > Virtualize > Linux
2. Select "Use Apple Virtualization"
3. Set around 50% of host memory, since we'll use it as the main machine
4. Select 50% of cores
5. Select 128 GiB harddrive storage
6. Share mac home directory
7. Create VM

## Prerequisites
1. Make sure you have the following ssh keys setup in ~/.ssh on the host
    - id_rsa_github_personal
    - id_rsa_nixbox

## Install NixOS
1. Start VM
2. `ifconfig` to find out IP address of VM
3. Change root password
```
sudo su
passwd
```
4. `cp .env.example .env` and fill out the variables
4. `NIXADDR=<IP_ADDR> make vm/bootstrap0`
5. VM restarts after the command has been executed
4. `NIXADDR=<IP_ADDR> make vm/bootstrap`

## Helpful commands
### DEV Shell with DIRENV
1. Create a .envrc file in the project root with the following content:
```text
# .envrc
use flake devshells#dotnet8
```
2. Run `direnv allow` to enable the environment

### Updating OpenCode
OpenCode is pinned to a specific release version in `flake.nix`. To update to a newer version:

1. **Check available versions:**
   Visit the [OpenCode releases page](https://github.com/anomalyco/opencode/releases)

2. **Update to a specific version:**
   Edit `flake.nix` and change the opencode input URL:
   ```nix
   opencode.url = "github:anomalyco/opencode/vX.X.X";
   ```
   Then update the lock file:
   ```bash
   nix flake lock --update-input opencode
   ```

3. **Rebuild your system:**
   ```bash
   sudo nixos-rebuild switch --flake /home/fabian/repos/personal/nixos-config
   ```

## TODO
- how should I handle different email from differnt git accounts?
- directory sharing with apple Virtualization
