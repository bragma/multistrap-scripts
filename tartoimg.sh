#!/bin/bash
# Create an ext4 image file from a tar file
#
# $1 tar file name
# $2 image name

set -e

# source functions
[ -f "$(dirname $(realpath $0))/functions.sh" ] && . "$(dirname $(realpath $0))/functions.sh" || exit 255

# get scripts path
PATH=$PATH:$(dirname $(realpath $0))

TARFILE=$(getfileorfail "$1" "source rootfs tar")
IMGNAME=$(getparamorfail "$2" "destination rootfs image")

checkrootuser

createimg "$IMGNAME"
MNTPOINT=$(mountimg "$IMGNAME")
extract "$TARFILE" "$MNTPOINT"
umountimg "$MNTPOINT"

