#!/bin/bash
# Delete a rootfs image which may have mounted fs
#
# $1 rootfs folder

set -e

# source functions
[ -f "$(dirname $(realpath $0))/functions.sh" ] && . "$(dirname $(realpath $0))/functions.sh" || exit 255

# get scripts path
PATH=$PATH:$(dirname $(realpath $0))

ROOTDIR=$(getdirorfail "$1" "rootfs folder")
if [ "$(realpath "$ROOTDIR")" == "/" ]; then
	echo "Refusing to remove disk root."
	exit 254
fi

checkrootuser

umounttmpfs "$ROOTDIR"
rm -rf "$ROOTDIR"
