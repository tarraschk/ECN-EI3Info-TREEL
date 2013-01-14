target remote localhost:3333
monitor reset halt
monitor mww 0xE01FC040 0
monitor mdw 0xE01FC040
file INTERNAL_RAM_TARGET
load
monitor mww 0xE01FC040 2
monitor mdw 0xE01FC040
monitor soft_reset_halt
monitor resume
