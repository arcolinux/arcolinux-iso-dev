#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name=arcolinux-dev
iso_label="arcolinux-dev-v20.11.4"
iso_publisher="ArcoLinux <http://www.arcolinux.info>"
iso_application="ArcoLinux Live/Rescue CD"
iso_version="v20.11.4"
install_dir=arch
work_dir=work
out_dir=out
gpg_key=""
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
