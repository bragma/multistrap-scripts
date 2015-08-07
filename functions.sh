#!/bin/bash

function getparamorfail {
	if [ -z "$1" ] ; then
		echo "Error: $2 has not been specified." >&2
		exit 1
	fi

	echo "$1"
}

function getdirorfail {
	if [ -z "$1" ] ; then
		echo "Error: $2 has not been specified." >&2
		exit 1
	fi

	if [ ! -d "$1" ] ; then
		echo "Error: $2 does not exist or is not a folder." >&2
		exit 1
	fi

	echo "$1"
}

function getfileorfail {
	if [ -z "$1" ] ; then
		echo "Error: $2 has not been specified." >&2
		exit 1
	fi

	if [ ! -f "$1" ] ; then
		echo "Error: $2 does not exist or is not a file." >&2
		exit 1
	fi

	echo "$1"
}


function extract {
	tar xf "$1" -C "$2"
}

function mounttmpfs {
	mount /dev -o bind "$1/dev/"
	mount /sys -o bind "$1/sys/"
	mount /proc -o bind "$1/proc/"
}

function umounttmpfs {
	umount "$1/dev/"
	umount "$1/sys/"
	umount "$1/proc/"
}

function addemu {
	cp $(which qemu-arm-static) "$1/usr/bin"
}

function rememu {
	rm "$1/usr/bin/qemu-arm-static"
}


function addpreventstartfiles {
	cp "$(dirname $(realpath $0))/preventstartup.sh" "$1"
	cp "$(dirname $(realpath $0))/preventstartdown.sh" "$1"
}

function rempreventstartfiles {
	rm "$1/preventstartup.sh" "$1/preventstartdown.sh"
}

function preparechroot {
	mounttmpfs "$1"
	addemu "$1"
}

function unpreparechroot {
	rememu "$1"
	umounttmpfs "$1"
}

function setconfenv {
	export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
	export LC_ALL=C LANGUAGE=C LANG=C
}

function setupfolder {
	local TMPDIR="$(mktemp -d -p .)" || exit $?
	echo "$TMPDIR"
}

function cleanupfolder {
	rm -rf "$1"
}

function createimg {
	dd if=/dev/zero of="$1" bs=1 count=0 seek=2048M
	mkfs.ext4 -b 4096 -L linuxroot -F "$1"
}

function mountimg {
	local MNTPOINT="$(mktemp -d -p .)" || exit $?
	mount "$1" "$MNTPOINT"
	echo "$MNTPOINT"
}

function umountimg {
	umount "$1"
	rmdir "$1"
}

function copyfs {
	rsync -qaAXv --exclude={"dev/*","proc/*","sys/*","tmp/*","run/*","mnt/*","media/*","/lost+found"} "$1/" "$2/"
}

function checkrootuser {
	if [ "$(whoami)" != "root" ]; then
		echo "This command requires root privileges. Please run using sudo."
		exit 2
	fi
}
