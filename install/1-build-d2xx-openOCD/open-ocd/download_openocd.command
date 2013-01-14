#!/bin/sh
set -x

DIR=`dirname $0` &&
cd $DIR &&

#--- Archives
REVISION=1200 &&

#--- Remove build directories
svn checkout -r $REVISION svn://svn.berlios.de/openocd/trunk openocd-r$REVISION &&

#---
echo "----------- Success!"
