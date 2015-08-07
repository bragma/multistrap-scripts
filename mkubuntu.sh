#!/bin/bash
# Prepare an ubuntu image from tar.
#
# $1 tar file name
# $2 image name (optional)

set -e

# source functions
[ -f "$(dirname $(realpath $0))/functions.sh" ] && . "$(dirname $(realpath $0))/functions.sh" || exit 255

# get scripts path
PATH=$PATH:$(dirname $(realpath $0))

TARFILE=$(getfileorfail "$1" "source rootfs tar")
[ -n "$2" ] && IMGNAME="$2" || IMGNAME="ubuntu-core.img"



tartoimg.sh "$TARFILE" "$IMGNAME"
preprootdir.sh "$IMGNAME"
