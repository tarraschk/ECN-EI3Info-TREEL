#!/bin/sh
set -e
cd `dirname $0` &&
for d in `ls`
do
  if [ -d $d ] && [ -e $d/clean.command ]
  then
    echo "----- Cleaning '$d' directory"
    $d/clean.command
  fi
done 
