#!/bin/sh
set -e
cd `dirname $0` &&
GDB_TOOL -command=GDBDIR/internal-flash-erase.gdb
