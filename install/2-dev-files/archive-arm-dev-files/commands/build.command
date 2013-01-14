#!/bin/sh
set -e

cd $1 &&

if [ `uname -s` \= Darwin ] ; then
  CORE_COUNT=`sysctl -n hw.ncpu`
else
  if [ `uname -s` \= Linux ] ; then
    CORE_COUNT=`cat /proc/cpuinfo | grep -i 'processor' | wc -l`
  else
    CORE_COUNT=1
  fi
fi &&

make -f makefile.mak --warn-undefined-variables all -j $CORE_COUNT
