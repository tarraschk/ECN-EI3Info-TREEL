target remote localhost:3333
monitor reset halt
monitor mww 0xE01FC040 1
monitor flash write_image erase INTERNAL_FLASH_TARGET
monitor flash erase_check 0
