#!/bin/sh
REPERTOIRE=`dirname $0` &&
cd $REPERTOIRE &&
DEV_DIR=/usr/local/dev-arm/arm-dev-files &&
sudo rm -fr $DEV_DIR &&
sudo mkdir -p $DEV_DIR &&
sudo cp -r archive-arm-dev-files/* $DEV_DIR &&
sudo chmod a+rx $DEV_DIR/commands/*.command &&
#--- Install tool definition file
REP1=`dirname $REPERTOIRE`&&
echo "DEV_LPC_PATH := `dirname $REP1`" > temp &&
sudo cp temp $DEV_DIR/../dev-arm-directory-definition.mak &&
rm temp &&
#---
echo "**  DEV-FILES INSTALLED."
