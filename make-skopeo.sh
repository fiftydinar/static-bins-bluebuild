#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q skopeo | awk '{print $2; exit}')
VERSION=${VERSION#*:}
export ARCH VERSION
export OUTPATH=./dist
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export APPNAME=skopeo
export ICON=DUMMY
export DESKTOP=DUMMY

# Deploy dependencies
mkdir -p /tmp/skopeo-tmp
quick-sharun /usr/bin/skopeo -- "copy docker://docker.io/library/nginx:latest containers-storage:localhost/nginx:latest"

# Workaround skopeo-in-a-user-namespace process being ran as bin for some reason
ln -srfv ./AppDir/bin/skopeo ./AppDir/bin/skopeo-in-a-user-namespace

# Turn AppDir into AppImage
quick-sharun --make-appimage
rm ./dist/*.zsync
