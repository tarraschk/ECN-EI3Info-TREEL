#!/bin/sh
set -e
cd `dirname $0` &&
/usr/local/dev-arm/i386-Darwin-arm-gcc-4.6.1/bin/arm-elf-size -t  zBUILDS/crt0-pour-executif.s.o  zBUILDS/handler-stub-for-DAbort.s.o  zBUILDS/handler-stub-for-FIRQ.s.o  zBUILDS/handler-stub-for-PAbort.s.o  zBUILDS/handler-stub-for-undef.s.o  zBUILDS/initialize-lpc2200-pll.c.o  zBUILDS/sorties_s0_s3.c.o  zBUILDS/afficheur_lcd.c.o  zBUILDS/arm-context.s.o  zBUILDS/task-descriptor.c.o  zBUILDS/scheduler-no-priority.c.o  zBUILDS/task-list.c.o  zBUILDS/services.s.o  zBUILDS/application.c.o
