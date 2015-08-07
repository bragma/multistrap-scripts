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

# Get dir size in blocks of 4096 bytes
DIRBLOCKS=$(du -s -B 4096 "$DIRNAME" | awk '{print $1}')

# Increase output image of 40%
IMGBLOCKS=$(( $DIRBLOCKS * 140 / 100 ))

createimg "$IMGNAME" "$IMGBLOCKS"
MNTPOINT=$(mountimg "$IMGNAME")
copyfs "$DIRNAME" "$MNTPOINT"
umountimg "$MNTPOINT"

