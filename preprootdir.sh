#!/bin/bash
# Prepare and configure a rootfs directory
#
# $1 root folder name

set -e

SCRIPT_DIR="$(dirname "$(realpath $0)")"

# source functions
[ -f "$SCRIPT_DIR/functions.sh" ] && . "$SCRIPT_DIR/functions.sh" || exit 255

# get scripts path
PATH=$PATH:"$(dirname "$(realpath "$0")")"

# source settings
[ -f "$SCRIPT_DIR/preproot.cfg" ] && . "$SCRIPT_DIR/preproot.cfg"
if [ -d "$SCRIPT_DIR/preproot.d" ]; then
	for CFG_FILE in "$SCRIPT_DIR"/preproot.d/*; do
		. "$CFG_FILE"
	done
fi


checkset "$CFG_USER" "Error: CFG_USER not set"
checkset "$CFG_PASSWORD" "Error: CFG_PASSWORD not set"
checkset "$CFG_HOSTNAME" "Error: CFG_HOSTNAME not set"

DIRNAME=$(getdirorfail "$1" "source rootfs folder")

function prepare_users {
	# Add a user, set groups and password
	chroot "$1" bash -c "adduser --disabled-password --gecos \"\" $CFG_USER"
	chroot "$1" bash -c "usermod -aG adm,sudo,plugdev $CFG_USER"
	chroot "$1" bash -c "echo \"$CFG_USER:$CFG_PASSWORD\" | chpasswd"
}

function prepare_hostname {
	# Set machine hostname
	chroot "$1" bash -c "echo \"$CFG_HOSTNAME\" > etc/hostname"
	chroot "$1" bash -c "echo \"127.0.0.1	$CFG_HOSTNAME\" >> etc/hosts"
}

function prepare_issue {
	# Change the issue
	chroot "$1" bash -c "echo \"BSOS \\n \\l\" > /etc/issue"
}

function prepare_networking {
	# Set up some basic networking
	chroot "$1" bash -c "echo \"allow-hotplug eth0\" > /etc/network/interfaces.d/eth0"
	chroot "$1" bash -c "echo \"iface eth0 inet dhcp\" >> /etc/network/interfaces.d/eth0"
}

function prepare_fstab {
	# Add a basic fstab
	chroot "$1" bash -c "echo \"\" > /etc/fstab"
}

function prepare {
	prepare_users "$1"
	prepare_hostname "$1"
	prepare_issue "$1"
	prepare_networking "$1"
	prepare_fstab "$1"
}



checkrootuser

setconfenv
preparechroot "$DIRNAME"
prepare "$DIRNAME"
unpreparechroot "$DIRNAME"

