#!/bin/bash
# Create a rootfs folder and intstall packages
# 
# $1 configuration file
# $2 destination rootfs folder

set -e

# source functions
[ -f "$(dirname $(realpath $0))/functions.sh" ] && . "$(dirname $(realpath $0))/functions.sh" || exit 255

# get scripts path
PATH=$PATH:$(dirname $(realpath $0))

MULTICFG=$(getfileorfail "$1" "configuration file")
ROOTFSDIR=$(getparamorfail "$2" "destination rootfs folder")

function up {
	setconfenv
	preparechroot "$1"
	addpreventstartfiles "$1"
	chroot "$1" ./preventstartup.sh .
}

function down {
	chroot "$1" ./preventstartdown.sh .
	rempreventstartfiles "$1"
	unpreparechroot "$1"
}

function configure {
	chroot "$1" /var/lib/dpkg/info/dash.preinst install
	chroot "$1" dpkg --configure -a
}

checkrootuser

if [ -d "$ROOTFSDIR" ]; then
	echo "Error: rootfs folder already exists"
	exit 4
fi

multistrap --file "$MULTICFG" --dir "$ROOTFSDIR"
up "$ROOTFSDIR"
configure "$ROOTFSDIR"
down "$ROOTFSDIR"
echo "RootFS created in $ROOTFSDIR"

