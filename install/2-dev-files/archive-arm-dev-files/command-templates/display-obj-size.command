#!/bin/sh
set -e
cd `dirname $0` &&
GNUARMPATH/bin/arm-elf-size -t OBJECTFILELIST