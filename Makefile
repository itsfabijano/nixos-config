include .env
export $(shell sed 's/=.*//' .env)

# Connectivity info for Linux VM
NIXADDR ?= unset
NIXPORT ?= 22
NIXUSER ?= fabian

# Get the path to this Makefile and directory
MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

# SSH options that are used. These aren't meant to be overridden but are
# reused a lot so we just store them up here.
SSH_OPTIONS=-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

# We need to do some OS switching below.
UNAME := $(shell uname)


ifndef NIXNAME
$(error Environment variable NIXNAME is not defined)
endif

copy:
	mkdir -p /tmp/nixos-config
	cp -f $(MAKEFILE_DIR)/.variables.json /tmp/nixos-config/.variables.json

rebuild:
	$(MAKE) copy
	sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --impure --flake ".#${NIXNAME}"

switch:
	$(MAKE) copy
	home-manager switch --flake . --impure

clean:
	sudo nix-collect-garbage -d
	nix-collect-garbage -d
	nix-store --verify --check-contents
	nix-store --optimise
	home-manager expire-generations "-7 days"

update:
	nix flake update
	$(MAKE) rebuild

# bootstrap a brand new VM. The VM should have NixOS ISO on the CD drive
# and just set the password of the root user to "root". This will install
# NixOS. After installing NixOS, you must reboot and set the root password
# for the next step.
#
# NOTE(mitchellh): I'm sure there is a way to do this and bootstrap all
# in one step but when I tried to merge them I got errors. One day.
vm/bootstrap0:
	ssh $(SSH_OPTIONS) -p$(NIXPORT) root@$(NIXADDR) " \
		parted /dev/vda -- mklabel gpt; \
		parted /dev/vda -- mkpart root 512MB -8GB; \
		parted /dev/vda -- mkpart swap linux-swap -8GB 100\%; \
		parted /dev/vda -- mkpart ESP fat32 1MB 512MB; \
		parted /dev/vda -- set 3 esp on; \
		sleep 1; \
		mkfs.ext4 -L nixos /dev/vda1; \
		mkswap -L swap /dev/vda2; \
		mkfs.fat -F 32 -n boot /dev/vda3; \
		sleep 1; \
		mount /dev/disk/by-label/nixos /mnt; \
		mkdir -p /mnt/boot; \
		mount /dev/disk/by-label/boot /mnt/boot; \
		nixos-generate-config --root /mnt; \
		sed --in-place '/system\.stateVersion = .*/a \
			nix.extraOptions = \"experimental-features = nix-command flakes\";\n \
  			services.openssh.enable = true;\n \
			services.openssh.settings.PasswordAuthentication = true;\n \
			services.openssh.settings.PermitRootLogin = \"yes\";\n \
			users.users.root.initialPassword = \"root\";\n \
		' /mnt/etc/nixos/configuration.nix; \
		nixos-install --no-root-passwd && reboot; \
	"

# after bootstrap0, run this to finalize. After this, do everything else
# in the VM unless secrets change.
vm/bootstrap:
	NIXUSER=root $(MAKE) vm/copy
	NIXUSER=root $(MAKE) vm/switch
	$(MAKE) vm/secrets
	ssh $(SSH_OPTIONS) -p$(NIXPORT) $(NIXUSER)@$(NIXADDR) " \
		sudo reboot; \
	"

# copy our secrets into the VM
vm/secrets:
	# GPG keyring
	# rsync -av -e 'ssh $(SSH_OPTIONS)' \
	# 	--exclude='.#*' \
	# 	--exclude='S.*' \
	# 	--exclude='*.conf' \
	# 	$(HOME)/.gnupg/ $(NIXUSER)@$(NIXADDR):~/.gnupg
	# SSH keys
	ssh-copy-id -i ~/.ssh/id_rsa_nixbox.pub ${NIXUSER}@$(NIXADDR)
	rsync -av -e 'ssh $(SSH_OPTIONS)' \
		--exclude='archive' \
		--exclude='known_hosts' \
		$(HOME)/.ssh/ $(NIXUSER)@$(NIXADDR):~/.ssh

# copy the Nix configurations into the VM.
vm/copy:
	rsync -av -e 'ssh $(SSH_OPTIONS) -p$(NIXPORT)' \
		--exclude='vendor/' \
		--exclude='.git/' \
		--exclude='.git-crypt/' \
		--exclude='iso/' \
		--rsync-path="sudo rsync" \
		$(MAKEFILE_DIR)/ $(NIXUSER)@$(NIXADDR):/nix-config

# run the nixos-rebuild switch command. This does NOT copy files so you
# have to run vm/copy before.
vm/switch:
	ssh $(SSH_OPTIONS) -p$(NIXPORT) $(NIXUSER)@$(NIXADDR) " \
		mkdir -p /tmp/nixos-config; \
		cp -f /nix-config/.variables.json /tmp/nixos-config/; \
		sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --impure --flake \"/nix-config#${NIXNAME}\" \
	"
