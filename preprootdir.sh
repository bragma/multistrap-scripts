#!/bin/bash
# Prepare a rootfs directory
# $1 root folder name

USER="bs"
PASSWORD="bs"

set -e

# source functions
[ -f "$(dirname $(realpath $0))/functions.sh" ] && . "$(dirname $(realpath $0))/functions.sh" || exit 255

# get scripts path
PATH=$PATH:$(dirname $(realpath $0))

DIRNAME=$(getdirorfail "$1" "source rootfs folder")

checkrootuser

function prepare {
	chroot "$DIRNAME" sh -c "cat > /etc/group << EOF
root:x:0:
daemon:x:1:
bin:x:2:
sys:x:3:
adm:x:4:bs
tty:x:5:
disk:x:6:
lp:x:7:
mail:x:8:
news:x:9:
uucp:x:10:
man:x:12:
proxy:x:13:
kmem:x:15:
dialout:x:20:
fax:x:21:
voice:x:22:
cdrom:x:24:
floppy:x:25:
tape:x:26:
sudo:x:27:bs
audio:x:29:
dip:x:30:
www-data:x:33:
backup:x:34:
operator:x:37:
list:x:38:
irc:x:39:
src:x:40:
gnats:x:41:
shadow:x:42:
utmp:x:43:
video:x:44:
sasl:x:45:
plugdev:x:46:bs
staff:x:50:
games:x:60:
users:x:100:
nogroup:x:65534:
input:x:101:
systemd-journal:x:102:
systemd-journal-remote:x:103:
systemd-timesync:x:104:
systemd-network:x:105:
systemd-resolve:x:106:
systemd-bus-proxy:x:107:
EOF"
	chroot "$DIRNAME" sh -c "adduser --disabled-password --gecos \"\" $USER"
	chroot "$DIRNAME" sh -c "usermod -aG adm,sudo,plugdev $USER"
	chroot "$DIRNAME" sh -c "echo \"$PASSWORD\" | passwd $USER --stdin"
}


setconfenv
preparechroot "$DIRNAME"
prepare
unpreparechroot "$DIRNAME"

