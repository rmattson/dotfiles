#!/usr/bin/env bash
# Reinstall this machine onto a fresh Fedora Server with nothing attached to it but SSH.
# Settings live in f44-server.conf.
#
#   ./reinstall-fedora.sh --ks-only        regenerate only the kickstart (no root needed)
#   sudo ./reinstall-fedora.sh             write the kickstart, borrow the installer kernel,
#                                          add the boot entry, print the plan
#   sudo ./reinstall-fedora.sh --reboot    ... and reboot into the installer
#   sudo ./reinstall-fedora.sh --undo      drop the boot entry, restore the old default
#
# Why no monitor and no boot media are needed: the netinst image is only there to borrow its
# installer kernel and initrd, which are copied into /boot, and the install itself pulls
# packages from install_repo in the kickstart. The new system overwrites /boot and GRUB, so
# nothing of the installer is left behind; --undo is only for calling it off beforehand.
set -euo pipefail

dir=$(cd "$(dirname "$0")" && pwd)
. "$dir/f44-server.conf"

title="Install Fedora from $install_repo"
stage_dir=/boot/f44-installer
ks_only=0 do_reboot=0 undo=0

while [[ $# -gt 0 ]]; do
	case "$1" in
		-o) ks_out=$2; shift 2 ;;
		--ks-only) ks_only=1; shift ;;
		--reboot) do_reboot=1; shift ;;
		--undo) undo=1; shift ;;
		-h|--help) sed -n '2,14p' "$0"; exit 0 ;;
		*) echo "usage: $(basename "$0") [-o ks-path] [--ks-only] [--reboot] [--undo]" >&2; exit 2 ;;
	esac
done

die() { echo "$1" >&2; exit 1; }

if [[ $undo == 1 ]]; then
	[[ $EUID -eq 0 ]] || die "--undo needs root"
	[[ -f $stage_dir/previous-default ]] || die "no $stage_dir to undo"
	grubby --remove-kernel="$stage_dir/vmlinuz" >/dev/null 2>&1 || true
	grubby --set-default="$(< "$stage_dir/previous-default")"
	grub2-editenv - unset next_entry
	rm -rf "$stage_dir"
	echo "removed the installer entry; default is $(grubby --default-title)"
	exit 0
fi

# sudo makes us root, so the caller's key has to be looked up rather than read from ~.
caller_home=$(getent passwd "${SUDO_USER:-$USER}" | cut -d: -f6)
ssh_pubkey=${ssh_pubkey:-$(cat "$caller_home/.ssh/id_ed25519.pub" 2>/dev/null || true)}
hostname=${hostname:-$(hostnamectl --static)}
timezone=${timezone:-$(timedatectl show -p Timezone --value)}
[[ $ssh_pubkey == ssh-* ]] || die "no public key; set ssh_pubkey in $dir/f44-server.conf"
if [[ -z ${user_password:-} ]]; then
	read -rsp "password for $username: " user_password; echo >&2
	read -rsp "repeat it: " repeat; echo >&2
	[[ $user_password == $repeat ]] || die "passwords do not match"
fi

# Anaconda reads the kickstart off this filesystem before it wipes the disk, so it needs a
# UUID and has to stay where it is.
mkdir -p "$(dirname "$ks_out")"
boot_mp=$(findmnt -n -o TARGET -T "$(dirname "$ks_out")")
boot_uuid=$(findmnt -n -o UUID -T "$(dirname "$ks_out")") || true
[[ -n $boot_uuid ]] || die "$boot_mp has no UUID; keep $ks_out on a filesystem that does"

cat > "$ks_out" <<KS
# Generated from $(basename "$dir")/f44-server.conf by $(basename "$0") - edit the conf, not this.
url --url=$install_repo
lang $language
keyboard $keyboard
timezone $timezone --utc
network --bootproto=dhcp --activate --device=link --hostname $hostname
firewall --enabled --service=ssh
zerombr
clearpart --all --initlabel
autopart${autopart_extra:+ $autopart_extra}
user --name=$username --groups=$groups --iscrypted --password='$(openssl passwd -6 "$user_password")'
sshkey '$ssh_pubkey' --username=$username
sshkey '$ssh_pubkey' --username=root
rootpw --lock
reboot

%packages
@^$comps_environment
%end
KS

echo "wrote $ks_out (on $boot_mp, UUID $boot_uuid)"
if [[ $ks_only == 1 ]]; then exit 0; fi

[[ $EUID -eq 0 ]] || die "staging the installer needs root"

iso=/var/tmp/$(basename "$iso_url")
[[ -f $iso ]] || curl -fL --retry 3 -o "$iso" "$iso_url"
echo "$iso_sha256  $iso" | sha256sum -c - >/dev/null || die "checksum mismatch for $iso"
mnt=$(mktemp -d)
mount -q -o loop,ro "$iso" "$mnt"
install -d "$stage_dir"
cp "$mnt"/images/pxeboot/vmlinuz "$mnt"/images/pxeboot/initrd.img "$stage_dir"/
umount "$mnt"; rmdir "$mnt"; rm -f "$iso"
echo "borrowed vmlinuz + initrd.img into $stage_dir, dropped the ISO"

grubby --remove-kernel="$stage_dir/vmlinuz" >/dev/null 2>&1 || true
grubby --default-title > "$stage_dir/previous-default"
grubby --add-kernel="$stage_dir/vmlinuz" --initrd="$stage_dir/initrd.img" --title="$title" \
	--args="ks=hd:UUID=$boot_uuid:/${ks_out#"$boot_mp"/}${extra_args:+ $extra_args}" \
	--copy-default --make-default >/dev/null
idx=$(grubby --info=ALL | awk -v t="$title" '/^index=/{i=substr($0,7)} /title=/ && index($0,t){print i; exit}')
[[ -n $idx ]] || die "grubby did not create the entry"
# Both point at the same entry: the default is what grubby guarantees, next_entry is the
# one-shot form in case GRUB puts the new entry inside its "advanced options" submenu.
grub2-editenv - set "next_entry=$idx"

cat <<PLAN
armed: boot entry $idx ($title)
  kickstart: ks=hd:UUID=$boot_uuid:/${ks_out#"$boot_mp"/}
  source:    $install_repo
  layout:    clearpart --all --initlabel, autopart${autopart_extra:+ $autopart_extra}
  account:   $username (groups: $groups), root password locked, key installed for both
Nothing prompts from here on. The box should answer SSH again running the fresh Fedora Server.
If it comes back running the old system instead, GRUB ignored the entry and nothing was lost;
check with --undo and run it again. To call it off: sudo $0 --undo
PLAN
grub2-editenv - list | sed 's/^/grubenv: /'

if [[ $do_reboot == 1 ]]; then echo "rebooting"; reboot; fi
