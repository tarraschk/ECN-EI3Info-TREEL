#!/bin/sh
set -x

DIR=`dirname $0` &&
VERSION_MAC=`sw_vers -productVersion | awk 'BEGIN { FS = "." } ; { print $1"."$2 }'` &&
echo "VERSION_MAC: $VERSION_MAC" &&
cd $DIR &&

#--- Install D2XX
sudo rm -f /usr/local/lib/libftd2xx.*.dylib /usr/local/lib/libftd2xx.dylib &&
sudo cp libftd2xx.0.1.4.dylib /usr/local/lib/ &&
sudo ln -sf /usr/local/lib/libftd2xx.0.1.4.dylib /usr/local/lib/libftd2xx.dylib
