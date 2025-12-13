#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q podman | awk '{print $2; exit}')
VERSION=${VERSION#*:}
export ARCH VERSION
export OUTPATH=./dist
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export APPNAME=podman
export ICON=DUMMY
export DESKTOP=DUMMY

# Deploy dependencies
quick-sharun /usr/bin/podman \
             /usr/bin/podman-remote \
             /usr/bin/podmansh \
             /usr/lib/podman

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Make rpm and deb

tmpdir="/tmp/make-deb-rpm"
univ="$tmpdir/univ"
deb="$tmpdir/deb"
rpm="$tmpdir/rpm"
NAME_OF_FILE="$APPNAME-$VERSION-anylinux-$ARCH"
mkdir -p "$univ/usr/bin" \
         "$univ/usr/libexec/podman" \
         "$univ/usr/lib/systemd/system" \
         "$univ/usr/lib/systemd/user" \
         "$univ/usr/lib/systemd/user-generators" \
         "$univ/usr/share/bash-completion/" \
         "$univ/usr/share/fish/vendor_completions.d" \
         "$univ/usr/share/zsh/site-functions" \
         "$deb" \
         "$rpm/SOURCES"
         
mv -v "./dist/$NAME_OF_FILE.AppImage" "$univ/usr/bin/podman"
chmod +x "$univ/usr/bin/podman"
ln -sfv "$univ/usr/bin/podman" "$univ/usr/bin/podman-remote"
ln -sfv "$univ/usr/bin/podman" "$univ/usr/bin/podmansh"
ln -sfv "$univ/usr/bin/podman" "$univ/usr/libexec/podman/quadlet"
ln -sfv "$univ/usr/bin/podman" "$univ/usr/libexec/podman/rootlessport"
ln -sfv "$univ/usr/bin/podman" "$univ/usr/bin/quadlet"
ln -sfv "$univ/usr/bin/podman" "$univ/usr/bin/rootlessport"
cp -v /usr/lib/systemd/system/podman* "$univ/usr/lib/systemd/system/"
cp -v /usr/lib/systemd/user/podman* "$univ/usr/lib/systemd/user/"
cp -v /usr/lib/systemd/user-generators/podman* "$univ/usr/lib/systemd/user-generators/"
cp -v /usr/lib/tmpfiles.d/podman* "$univ/usr/lib/tmpfiles.d/"
cp -v /usr/share/fish/vendor_completions.d/podman* "$univ/usr/share/fish/vendor_completions.d/"
cp -v /usr/share/bash-completion/completions/podman* "$univ/usr/share/bash-completion/completions/"
cp -v /usr/share/zsh/site-functions/*podman* "$univ/usr/share/zsh/site-functions/"

# Make deb
if [ "$ARCH" = "x86_64" ]; then
  DEB_ARCH=amd64
elif [ "$ARCH" = "aarch64" ]; then
  DEB_ARCH=arm64
fi

cat << EOF > "$deb/dpkg.control"
Package: podman-anylinux
Description: Manage containers, pods, and images with Podman. Seamlessly work with containers and Kubernetes from your local environment.
Homepage: https://podman.io/
Maintainer: "fiftydinar <???>"
Version: $VERSION
Architecture: $DEB_ARCH
Section: utils
Priority: optional
Depends: 
EOF

cp -r "$univ"/* "$deb"
dpkg-deb --root-owner-group --build "$deb" "./dist/$NAME_OF_FILE.deb"

# Make rpm
cat << EOF > "$rpm/rpm.spec"
Name: podman-anylinux
Summary: Manage containers, pods, and images with Podman. Seamlessly work with containers and Kubernetes from your local environment.
Version: $VERSION
Release: 1%{?dist}
URL: https://podman.io/
License: Apache-2.0 AND BSD-2-Clause AND BSD-3-Clause AND ISC AND MIT AND MPL-2.0
BuildArch: $ARCH

%description
Manage containers, pods, and images with Podman. Seamlessly work with containers and Kubernetes from your local environment.

%install
cp --parents -r %{_sourcedir}/* /

%files
%{_bindir}/podman*
%{_bindir}/podman-remote
%{_bindir}/quadlet
%{_bindir}/rootlessport
%{_libexecdir}/podman/*
%{_unitdir}/podman*
%{_userunitdir}/podman*
%{_tmpfilesdir}/podman*
/usr/lib/systemd/user-generators/podman*
%{_datadir}/fish/vendor_completions.d/podman*
%{_datadir}/bash-completion/completions/podman*
%{_datadir}/zsh/site-functions/*podman*
EOF

cp -r "$univ"/* "$rpm/SOURCES/"
rpmbuild -bb $rpm/rpm.spec --define "_topdir $rpm"
mv -v "$rpm/RPMS/$ARCH/podman-anylinux-$VERSION-1.$ARCH.rpm" "$NAME_OF_FILE.rpm"
