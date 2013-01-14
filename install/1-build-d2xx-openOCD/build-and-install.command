#!/bin/sh
set -x

DIR=`dirname $0` &&
OPERATING_SYSTEM=`uname -s` &&
echo "OPERATING_SYSTEM: $OPERATING_SYSTEM" &&
cd $DIR &&

if [ $OPERATING_SYSTEM \= Darwin ] ; then
  #--- Create directories, install FTDI headers
  sudo mkdir -p /usr/local/lib /usr/local/include &&
  sudo cp drivers-d2xx/ftd2xx.h /usr/local/include/ &&
  sudo cp drivers-d2xx/WinTypes.h /usr/local/include/ &&
  #--- Install FTDI Library
  ./drivers-d2xx/$OPERATING_SYSTEM/build-and-install-d2xx.command
fi &&

#--- OPENOCD
./open-ocd/build-and-install-openocd-$OPERATING_SYSTEM.command &&

#---
echo "----------- Success!"
