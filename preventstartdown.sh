#!/bin/sh
# Remove changes for preventing start of services during configuration

set -e

# The script is called with the following arguments:
# $1 = $DIR  - the top directory of the bootstrapped system

TARGET="$1"

[ -n "$TARGET" ] || exit 1

# upstart support
if [ -x "$TARGET/sbin/start-stop-daemon" ] && [ -x "$TARGET/sbin/start-stop-daemon.REAL" ]; then
	echo "start-stop-daemon: Removing prevent daemons from starting in $TARGET"
	mv "$TARGET/sbin/start-stop-daemon.REAL" "$TARGET/sbin/start-stop-daemon"
fi

if [ -x "$TARGET/sbin/initctl" ] && [ -x "$TARGET/sbin/initctl.REAL" ]; then
	echo "start-stop-daemon: Removing prevent daemons from starting in $TARGET"
	mv "$TARGET/sbin/initctl.REAL" "$TARGET/sbin/initctl"
fi
# sysvinit support - exit value of 101 is essential.
if [ -f "$TARGET/usr/sbin/policy-rc.d.FAKED" ]; then
	echo "sysvinit: Removing policy-rc.d to prevent daemons from starting in $TARGET"
	rm "$TARGET/usr/sbin/policy-rc.d" "$TARGET/usr/sbin/policy-rc.d.FAKED"
fi

