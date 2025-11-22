#!/bin/sh

set -eu

ARCH=$(uname -m)
SHARUN_LINK=${SHARUN_LINK:-https://github.com/VHSgunzo/sharun/releases/latest/download/sharun-$ARCH-aio}
wget -qO /tmp/sharun-aio "$SHARUN_LINK"
chmod +x /tmp/sharun-aio

APPNAME="
	wget
	curl
	gawk
	sed
"

for appname in $APPNAME; do
  VERSION=$(pacman -Q $appname | awk '{print $2; exit}')
  /tmp/sharun-aio lib4bin --with-wrappe --dst-dir ./dist /usr/bin/$appname
  mv -v ./dist/$appname ./dist/$appname-$VERSION-$ARCH-wrappe
done

APPNAME="
	find
"

for appname in $APPNAME; do
  VERSION=$(pacman -Q findutils | awk '{print $2; exit}')
  /tmp/sharun-aio lib4bin --with-wrappe --dst-dir ./dist /usr/bin/$appname
  mv -v ./dist/$appname ./dist/$appname-$VERSION-$ARCH-wrappe
done

###################################### coreutils ######################################

APPNAME="
	cp
	mv
	ln
	rm
	rmdir
	mkdir
	cat
	chmod
	chown
"

VERSION=$(pacman -Q coreutils | awk '{print $2; exit}')
for appname in $APPNAME; do
  /tmp/sharun-aio lib4bin --with-wrappe --dst-dir ./dist /usr/bin/"$appname"
  mv -v ./dist/"$appname" ./dist/"$appname"-coreutils-"$VERSION"-$ARCH-wrappe
done
