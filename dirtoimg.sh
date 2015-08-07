#!/bin/bash
# Create an ext4 image file from a specified folder
#
# $1 source dir name
# $2 image name

set -e

# source functions
[ -f "$(dirname $(realpath $0))/functions.sh" ] && . "$(dirname $(realpath $0))/functions.sh" || exit 255

# get scripts path
PATH=$PATH:$(dirname $(realpath $0))

DIRNAME=$(getdirorfail "$1" "source rootfs folder")
IMGNAME=$(getparamorfail "$2" "destination rootfs image")

checkrootuser

createimg "$IMGNAME"
MNTPOINT=$(mountimg "$IMGNAME")
copyfs "$DIRNAME" "$MNTPOINT"
umountimg "$MNTPOINT"

