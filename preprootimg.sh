#!/bin/bash
# Prepare an image by mounting it
#
# $1 image name

set -e

# source functions
[ -f "$(dirname $(realpath $0))/functions.sh" ] && . "$(dirname $(realpath $0))/functions.sh" || exit 255

# get scripts path
PATH=$PATH:$(dirname $(realpath $0))

IMGNAME=$(getfileorfail "$1" "source rootfs image")

checkrootuser

MNTPOINT=$(mountimg "$IMGNAME")

preprootdir "$MNTPOINT"

umountimg "$MNTPOINT"
