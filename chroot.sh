#!/bin/bash
# Chroot into a rootfs folder or image. If an image is specified, it is mounted first
#
# $1 rootfs image name or folder

set -e

# source functions
[ -f "$(dirname $(realpath $0))/functions.sh" ] && . "$(dirname $(realpath $0))/functions.sh" || exit 255

# get scripts path
PATH=$PATH:$(dirname $(realpath $0))

ROOTNAME=$(getparamorfail "$1" "rootfs name")

if [ ! -f "$ROOTNAME" ] && [ ! -d "$ROOTNAME" ] ; then
	echo "Error: must specify an existing rootfs image or folder"
fi

checkrootuser

if [ -f "$ROOTNAME" ]; then
	MNTPOINT=$(mountimg "$IMGNAME")
	ROOTNAME="$MNTPOINT"
fi

preparechroot "$ROOTNAME"
setconfenv

chroot "$ROOTNAME"

unpreparechroot "$ROOTNAME"

if [ -n "$MNTPOINT" ]; then
	umountimg "$MNTPOINT"
fi

