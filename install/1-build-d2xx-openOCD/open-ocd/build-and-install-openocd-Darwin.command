#!/bin/sh
set -x

DIR=`dirname $0` &&
cd $DIR &&

#--- OpenOCD archive
OPENOCD=openocd-0.4.0 &&

#--- Remove build directory
rm -fr $OPENOCD &&

#--- Remove Open OCD library dir
sudo rm -fr /usr/local/lib/openocd &&
sudo rm -fr /usr/local/share/openocd &&

#--- OPENOCD
bunzip2 -kc $OPENOCD.tar.bz2 > $OPENOCD.tar &&
tar xf $OPENOCD.tar &&
rm $OPENOCD.tar &&

#--- Install OPENOCD
cd $OPENOCD &&
./configure --help &&
./configure --disable-shared --disable-werror --enable-ft2232_ftd2xx "CC=gcc -m32" &&
make &&
sudo make install &&
cd .. &&
rm -fr $OPENOCD
