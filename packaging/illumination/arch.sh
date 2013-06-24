#!/bin/bash

APP=illumination
PREV_VERSION=6.0.0
VERSION=6.0.0
RELEASE=1
ARCH_TYPE=`uname -m`
CURRDIR=`pwd`
SOURCE=archpackage/${APP}-${VERSION}.tar.gz

# Update version numbers automatically - so you don't have to
sed -i 's/VERSION='${PREV_VERSION}'/VERSION='${VERSION}'/g' Makefile debian.sh rpm.sh
sed -i 's/Version: '${PREV_VERSION}'/Version: '${VERSION}'/g' rpmpackage/${APP}.spec
sed -i 's/Release: '${RELEASE}'/Release: '${RELEASE}'/g' rpmpackage/${APP}.spec
sed -i 's/pkgrel='${RELEASE}'/pkgrel='${RELEASE}'/g' archpackage/PKGBUILD
sed -i 's/pkgver='${PREV_VERSION}'/pkgver='${VERSION}'/g' archpackage/PKGBUILD

# Set the type of architecture
sed -i "s/arch=('any')/arch=('${ARCH_TYPE}')/g" "archpackage/PKGBUILD"

# Create the source code
make clean
rm -f archpackage/*.gz
# having the root directory called name-version seems essential
mv ../${APP} ../${APP}-${VERSION}
tar -cvzf ${SOURCE} ../${APP}-${VERSION} --exclude-vcs
# rename the root directory without the version number
mv ../${APP}-${VERSION} ../${APP}

# calculate the MD5 checksum
CHECKSM=$(md5sum ${SOURCE})
sed -i "s/md5sums[^)]*)/md5sums=(${CHECKSM%% *})/g" archpackage/PKGBUILD

cd archpackage

# Create the package
makepkg

# Move back to the original directory
cd ${CURRDIR}

