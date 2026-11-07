# tony

## File Systems
`sudo -i`
`lsblk` verify your space is given to sda if not use whatever name is user
`cfdisk /dev/sda`
	`gpt` for uefi system <- maybe check for your system
	create 3 partitions and assign types
	1 -> 1G EFI type for boot
	2 -> 4G Linux Swap for swap
	3 -> rest Linux Filesystem
	write, yes
`lsblk` to confirm that 
`mkfs.ext4 -L nixos /dev/sda3`
`mkswap -L swap /dev/sda2`
`mkfs.fat -F 32 -n boot /dev/sda1`
`mount /dev/sda3 /mnt`
`mount --mkdir /dev/sda1 /mnt/boot`
`swapon /dev/sda2`
`mount -t efivarfs efivarfs /sys/firmware/efi/efivars`
`lsblk` confirm 
Should look like this
```sh
[root@nixos:~]# lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0    7:0   0   1.1G  1 loop /nix/.ro-store
sda      8:0   0 127.3G  0 disk
├─sda1   8:1   0     1G  0 part /mnt/boot
├─sda2   8:2   0     4G  0 part [SWAP]
└─sda3   8:3   0 122.3G  0 part /mnt
sr0     11:0   1   1.1G  0 rom  /iso
```

## Configs
`nixos-generate-config --root /mnt`
`vim /mnt/etc/nixos/configuration.nix`
uncomment and set the following:
networking.hostName = "nixos-btw"

time.timeZone = "Asia/Kolkata"
below services.xserver add this
```
services.xserver = {
	enable = true;
	windowManager.qtile.enable = true;
};
```

programs.firefox.enable = true;

add and programs u might want preinstalled, add it to the line just below 
environment.systempackages = with pkgs; [
  vim
  wget
  alacritty
  neovim
];

`:wq`

## install

`nixos-install`
put in new credentials
`nixos-enter --root /mnt -c 'passwd {ur usr name}`
`reboot`

## updates

on any changes to config file (install, remove, etc)
`sudo nixos-rebuild switch`
`reboot`

## Rollbacks
_You can simply go to prev version temporarily from the bootloader_
- list versions
`nixos-rebuild list-generations`
- rollback to specific gen
```sh
sudo nix-env --profile /nix/var/nix/profiles/system --switch-generation 5 # replace `5` with gen no
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
```
and reboot if u feel like it

