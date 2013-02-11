target remote localhost:3333
monitor reset halt
monitor mww 0xE01FC040 1
monitor flash write_image erase zPRODUCTS/test-internal-flash.elf
monitor flash erase_check 0
