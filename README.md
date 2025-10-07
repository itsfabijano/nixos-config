# nixos-config

## Setup Virtual Machine
1. Create New Virtual Machine > Virtualize > Linux
2. Select "Use Apple Virtualization"
3. Set around 50% of host memory, since we'll use it as the main machine
4. Select 50% of cores
5. Select 128 GiB harddrive storage
6. Share mac home directory
7. Create VM

## Install NixOS
1. Start VM
2. `ifconfig` to find out IP address of VM
3. Change root password
```
sudo su
passwd
```
4. `NIXADDR=<IP_ADDR> make vm/bootstrap0`
5. VM restarts after the command has been executed

## Helpful commands
### Enable Docker rootless
```
systemctl --user enable --now docker
```


## TODO
- how should I handle different email from differnt git accounts?
- directory sharing with apple Virtualization
