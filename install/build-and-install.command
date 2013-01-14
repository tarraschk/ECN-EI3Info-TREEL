#!/bin/sh
set -x

DIR=`dirname $0` &&

$DIR/1-build-d2xx-openOCD/build-and-install.command &&
$DIR/2-dev-files/install-dev-files.command &&
$DIR/3-gcc-for-arm/install.command &&

#---
echo "----------- Success!"
