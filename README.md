# nixos-config

## Setup Virtual Machine
1. Create New Virtual Machine > Virtualize > Linux
2. Select "Use Apple Virtualization"
3. Set around 70% of host memory, since we'll use it as the main machine
4. Select 6/8 cores
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

```bash
home-manager switch --flake ./#<username>
```

## TODO
- make home manager switch respect env variables ?? or get rid of env varaibles
- how should I handle different email from differnt git accounts?
