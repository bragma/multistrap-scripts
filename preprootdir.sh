#!/bin/bash
# Prepare a rootfs directory
# $1 root folder name

set -e

# source functions
[ -f "$(dirname $(realpath $0))/functions.sh" ] && . "$(dirname $(realpath $0))/functions.sh" || exit 255

# source settings
[ -f "$(dirname $(realpath $0))/prepareroot.cfg" ] && . "$(dirname $(realpath $0))/prepareroot.cfg" || exit 255
[ -n "$USER" ] || exit 4
[ -n "$PASSWORD" ] || exit 4

# get scripts path
PATH=$PATH:$(dirname $(realpath $0))

DIRNAME=$(getdirorfail "$1" "source rootfs folder")

checkrootuser

function prepare {
	chroot "$1" sh -c "adduser --disabled-password --gecos \"\" $USER"
	chroot "$1" sh -c "usermod -aG adm,sudo,plugdev $USER"
	chroot "$1" sh -c "echo \"$USER:$PASSWD\" | chpasswd"
	chroot "$1" sh -c "echo \"BodySensor\" > etc/hostname"
	chroot "$1" sh -c "echo \"BSOS \n \l\" > /etc/issue"
}

setconfenv
preparechroot "$DIRNAME"
prepare "$DIRNAME"
unpreparechroot "$DIRNAME"

