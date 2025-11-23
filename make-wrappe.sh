#!/bin/sh

set -eu

ARCH=$(uname -m)

APPNAME="
	wget
	curl
	gawk
	sed
"

for appname in $APPNAME; do
  VERSION=$(pacman -Q $appname | awk '{print $2; exit}')
  quick-sharun --make-static-bin --dst-dir ./dist /usr/bin/"$appname"
  mv -v ./dist/"$appname" ./dist/"$appname-$VERSION-$ARCH-wrappe"
done

APPNAME="
	find
"

for appname in $APPNAME; do
  VERSION=$(pacman -Q findutils | awk '{print $2; exit}')
  quick-sharun --make-static-bin --dst-dir ./dist /usr/bin/"$appname"
  mv -v ./dist/"$appname" ./dist/"$appname-$VERSION-$ARCH-wrappe"
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
  quick-sharun --make-static-bin --dst-dir ./dist /usr/bin/"$appname"
  mv -v ./dist/"$appname" ./dist/"$appname-coreutils-$VERSION-$ARCH-wrappe"
done
