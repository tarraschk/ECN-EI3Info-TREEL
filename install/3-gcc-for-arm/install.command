#!/bin/sh
set -x

DIR=`dirname $0` &&

#--- GCC version
GCC_VERSION=4.6.1 &&

#--- OPERATING_SYSTEM is Darwin for Mac OS X, and Linux for Linux
OPERATING_SYSTEM=`uname -s` &&
echo "OPERATING_SYSTEM: $OPERATING_SYSTEM" &&

#--- Darwin
if [ "$OPERATING_SYSTEM" \= Darwin ] ; then
  #--- PROCESSOR_TYPE is i386 on an Intel Mac, powerpc on a PowerPC Mac
  PROCESSOR_TYPE=`uname -p`
else
  #---PROCESSOR_TYPE is i386 or i686 on 32-bit Linux, x86_64 on a 64-bit Linux
  PROCESSOR_TYPE=`uname -m` &&
  #--- If processor type is i686, set it to i386
  if [ $PROCESSOR_TYPE \= i686 ] ; then
    PROCESSOR_TYPE=i386
  fi
fi &&
echo "PROCESSOR_TYPE: $PROCESSOR_TYPE" &&

#--- Tool definition path
TOOL_DEFINITION_FILE=/usr/local/dev-arm/gcc-for-arm-definition.mak &&
cd $DIR &&

#--- Archive
ARCHIVE=$PROCESSOR_TYPE-$OPERATING_SYSTEM-arm-gcc-$GCC_VERSION &&
INSTALL_DIR=/usr/local/dev-arm &&

#--- Remove build directory
rm -f $DIR/*.tar &&
rm -fr $DIR/$PROCESSOR_TYPE-$OPERATING_SYSTEM-arm-gcc-$GCC_VERSION &&

#--- Unarchive -> arm directory
bunzip2 -kc archives-binaires/$ARCHIVE.tar.bz2 > $ARCHIVE.tar &&
tar xf $ARCHIVE.tar &&
rm $ARCHIVE.tar &&

#--- Install GNU ARM
sudo rm -fr $INSTALL_DIR/$PROCESSOR_TYPE-$OPERATING_SYSTEM-arm-gcc-$GCC_VERSION &&
sudo mkdir -p $INSTALL_DIR &&
sudo cp -r $PROCESSOR_TYPE-$OPERATING_SYSTEM-arm-gcc-$GCC_VERSION $INSTALL_DIR &&
sudo chmod -R u+rx $INSTALL_DIR &&

#--- Remove build directory
rm -fr $DIR/$PROCESSOR_TYPE-$OPERATING_SYSTEM-arm-gcc-$GCC_VERSION &&

#--- Install tool definition file
sudo rm -f $TOOL_DEFINITION_FILE &&
echo "GNU_ARM_PATH := $INSTALL_DIR/$PROCESSOR_TYPE-$OPERATING_SYSTEM-arm-gcc-$GCC_VERSION" > $DIR/temp &&
echo "ARM_COMPILER_PREFIX := arm-elf-" >> $DIR/temp &&
sudo cp $DIR/temp $TOOL_DEFINITION_FILE &&
rm $DIR/temp &&

#---
echo "----------- Success!"
