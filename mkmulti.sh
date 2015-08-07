#!/bin/bash
# 
# $1 dist name

set -e

# source functions
[ -f "$(dirname $(realpath $0))/functions.sh" ] && . "$(dirname $(realpath $0))/functions.sh" || exit 255

# get scripts path
PATH=$PATH:$(dirname $(realpath $0))

DIST=$(getparamorfail "$1" "distribution name")
MULTICFG="${DIST}.multi.cfg"
ROOTFSDIR="$DIST"

if [ ! -f $MULTICFG ]; then
	echo "Error: can't find multistrap configuration file $MULTICFG"
	exit 3
fi

checkrootuser

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

multistrap -f "$MULTICFG"
up "$ROOTFSDIR"
configure "$ROOTFSDIR"
down "$ROOTFSDIR"

