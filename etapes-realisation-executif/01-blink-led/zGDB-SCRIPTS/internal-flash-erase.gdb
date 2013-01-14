target remote localhost:3333
monitor reset halt
monitor mww 0xE01FC040 1
monitor flash erase_sector 0 0 16
monitor flash erase_check 0
