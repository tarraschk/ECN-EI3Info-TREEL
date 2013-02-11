target remote localhost:3333
monitor arm7_9 force_hw_bkpts enable
monitor reset halt
monitor mww 0xE002C014 0x0F804924
monitor mdw 0xE002C014
monitor mww 0xFFE00004 0x20000400
monitor mdw 0xFFE00004
file zPRODUCTS/test-external-ram.elf
load
directory sources /usr/local/dev-arm/arm-dev-files/sources ../sources-communs
monitor mww 0xE01FC040 2
monitor mdw 0xE01FC040
monitor soft_reset_halt
