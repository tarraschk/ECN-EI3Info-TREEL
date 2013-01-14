#!/bin/sh
set -e
cd `dirname $0` &&
GDB_TOOL -command=GDBDIR/run-in-internal-ram.gdb
