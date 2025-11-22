#!/bin/sh

set -eu

ARCH=$(uname -m)
APPNAME=wget
VERSION=$(pacman -Q wget | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export APPNAME

SHARUN_LINK=${SHARUN_LINK:-https://github.com/VHSgunzo/sharun/releases/latest/download/sharun-$ARCH-aio}
wget -qO /tmp/sharun-aio "$SHARUN_LINK"
chmod +x /tmp/sharun-aio

# Deploy dependencies
/tmp/sharun-aio lib4bin --with-wrappe --dst-dir ./dist /usr/bin/wget

mv -v ./dist/$APPNAME ./dist/$APPNAME-$VERSION-wrappe
