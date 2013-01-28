#!/bin/sh
set -e

cd `dirname $0` &&

make -f makefile.mak --warn-undefined-variables clean
