#!/bin/sh
set -e
cd `dirname $0` &&
GDB_TOOL -command=GDBDIR/debug-in-internal-ram.gdb
