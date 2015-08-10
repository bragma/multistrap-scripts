#!/bin/bash
# Create a rootfs folder and intstall packages
# 
# $1 dist name

set -e

# source functions
[ -f "$(dirname $(realpath $0))/functions.sh" ] && . "$(dirname $(realpath $0))/functions.sh" || exit 255

# get scripts path
PATH=$PATH:$(dirname $(realpath $0))

DIST=$(getparamorfail "${1%.multi.cfg}" "distribution name")
MULTICFG="${DIST}.multi.cfg"
ROOTFSDIR="$DIST"
ROOTFSIMG="${DIST}.img"

mkmulti.sh "$MULTICFG" "$ROOTFSDIR"
preprootdir.sh "$ROOTFSDIR"
dirtoimg.sh "$ROOTFSDIR" "$ROOTFSIMG"
echo "Root image file $ROOTFSIMG created successfully!"

