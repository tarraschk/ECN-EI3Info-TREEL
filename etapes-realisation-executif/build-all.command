#!/bin/sh
set -e

cd `dirname $0` &&

for d in `ls`
do
  if [ -d $d ] && [ -e $d/1-build.command ]
  then
    echo "----- Building in '$d' directory"
    `dirname $0`/$d/1-build.command
  fi
done 
