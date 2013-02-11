#!/bin/sh
set -e
cd `dirname $0` &&
/usr/local/dev-arm/i386-Darwin-arm-gcc-4.6.1/bin/arm-elf-size -t  zBUILDS/main.c.o  zBUILDS/crt0-for-sample-code.s.o  zBUILDS/initialize-lpc2200-pll.c.o  zBUILDS/initialiser-compteur-0-it.c.o  zBUILDS/handler-for-IRQ.s.o  zBUILDS/handler-stub-for-DAbort.s.o  zBUILDS/handler-stub-for-FIRQ.s.o  zBUILDS/handler-stub-for-PAbort.s.o  zBUILDS/handler-stub-for-SWI.s.o  zBUILDS/handler-stub-for-undef.s.o
