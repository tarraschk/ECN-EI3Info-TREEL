#!/bin/sh
set -e

cd $1 &&

make -f makefile.mak "VERBOSE=1" --warn-undefined-variables all
