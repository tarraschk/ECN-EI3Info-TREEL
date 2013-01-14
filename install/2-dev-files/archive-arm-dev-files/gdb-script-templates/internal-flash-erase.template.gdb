target remote localhost:3333
monitor reset halt
monitor mww 0xE01FC040 1
monitor flash erase_sector 0 0 LAST_INTERNAL_FLASH_BANK
monitor flash erase_check 0
