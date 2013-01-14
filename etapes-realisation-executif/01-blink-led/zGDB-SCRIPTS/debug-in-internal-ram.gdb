target remote localhost:3333
monitor arm7_9 force_hw_bkpts enable
monitor reset halt
monitor mww 0xE01FC040 2
monitor mdw 0xE01FC040
file TARGET_INTERNAL_RAM
load
directory sources /usr/local/dev-arm/arm-dev-files/sources
monitor soft_reset_halt
