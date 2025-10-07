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
### Enable Docker rootless
```
systemctl --user enable --now docker
```


## TODO
- how should I handle different email from differnt git accounts?
- directory sharing with apple Virtualization
