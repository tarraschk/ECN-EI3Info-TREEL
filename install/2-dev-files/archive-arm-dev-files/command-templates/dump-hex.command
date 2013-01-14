#!/bin/sh
set -e

cd `dirname $0` && /usr/local/dev-arm/arm-tools/bin/dump-hex-srec USERPROGRAMNAME.srec
