ENTRY(ResetHandler)
SEARCH_DIR(.)

/*
 * Define stack size here
 */
FIQ_STACK_SIZE = 0x0100;
IRQ_STACK_SIZE = 0x0100;
ABT_STACK_SIZE = 0x0100;
UND_STACK_SIZE = 0x0100;
USR_STACK_SIZE = 0x0100;
SVC_STACK_SIZE = 0x0400;
 
/*  Memory Definition */
MEMORY {
  internal_ram : org = 0x40000000, len = 16k
  external_ram : org = 0x81000000, len = 1M
}

SECTIONS
{
  .vectors :
  {
    *(.vectors);
  } > internal_ram
}

SECTIONS
{
  .text :
  {
    *(.init);
    . = ALIGN(4);
    *(.text);
    . = ALIGN(4);
    *(.rodata);
    . = ALIGN(4);
    *(.rodata*);
    . = ALIGN(4);
    *(.glue_7t);
    . = ALIGN(4);
    *(.glue_7);
    . = ALIGN(4);
    *(.comment);
    . = ALIGN(4);
    *(.ARM.*);
    . = ALIGN(4);
    etext = .;
  } > external_ram

  .data :
  {
    PROVIDE (__data_start = .);
    *(.data)
    . = ALIGN(4);
    edata = .;
    _edata = .;
    PROVIDE (__data_end = .);
  } > external_ram

  .bss :
  {
    PROVIDE (__bss_start = .);
    *(.bss)
    *(COMMON)
    . = ALIGN(4);
    PROVIDE (__bss_end = .);
    
    . = ALIGN(256);
    
    PROVIDE (__stack_start = .);
    
    PROVIDE (__stack_fiq_start = .);
    . += FIQ_STACK_SIZE;
    . = ALIGN(4);
    PROVIDE (__stack_fiq_end = .);

    PROVIDE (__stack_irq_start = .);
    . += IRQ_STACK_SIZE;
    . = ALIGN(4);
    PROVIDE (__stack_irq_end = .);

    PROVIDE (__stack_abt_start = .);
    . += ABT_STACK_SIZE;
    . = ALIGN(4);
    PROVIDE (__stack_abt_end = .);

    PROVIDE (__stack_und_start = .);
    . += UND_STACK_SIZE;
    . = ALIGN(4);
    PROVIDE (__stack_und_end = .);

    PROVIDE (__stack_svc_start = .);
    . += SVC_STACK_SIZE;
    . = ALIGN(4);
    PROVIDE (__stack_svc_end = .);

    PROVIDE (__stack_usr_start = .);
    . += USR_STACK_SIZE;
    . = ALIGN(4);
    PROVIDE (__stack_usr_end = .);

    PROVIDE (__stack_end = .);
    PROVIDE (__heap_start = .);   
  } > external_ram
    
}
/*** EOF ***/

