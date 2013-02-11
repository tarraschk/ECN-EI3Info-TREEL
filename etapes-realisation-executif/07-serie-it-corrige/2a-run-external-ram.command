#!/bin/sh
set -e
cd `dirname $0` &&
/usr/local/dev-arm/i386-Darwin-arm-gcc-4.6.1/bin/arm-elf-gdb -command=zGDB-SCRIPTS/run-in-external-ram.gdb
