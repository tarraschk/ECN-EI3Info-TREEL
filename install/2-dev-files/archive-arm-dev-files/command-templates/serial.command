#!/bin/sh
set -e

cd `dirname $0` &&

SUDO_ON_LINUX="" &&
if [ `uname -s` \= Linux ] ; then
  SUDO_ON_LINUX="sudo"
fi &&
$SUDO_ON_LINUX /usr/local/dev-arm/arm-tools/bin/serial-terminal SERIALLINK
