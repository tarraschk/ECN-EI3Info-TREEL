
ENTRY (zero)
SEARCH_DIR (.)

zero = 0 ;
 
MEMORY {
  internal_ram_for_extension : org = 0x40003C00, len = 1k
  external_ram : org = 0x81000000, len = 64k
}

/*--------------------------------------------------------------------------*/
/*                                                                          */
/*   . T E X T :   C O D E                                                  */
/*                                                                          */
/*--------------------------------------------------------------------------*/

SECTIONS {
  .text : {
    *(extensionHeader);
    . = ALIGN(4);
    *(romData);
    . = ALIGN(4);
    *(.text);
    . = ALIGN(4);
    *(.text.*);
    . = ALIGN(4);
    *(.rodata);
    . = ALIGN(4);
    *(.rodata*);
    . = ALIGN(4);
    *(.glue_7t);
    . = ALIGN(4);
    *(.glue_7);
    . = ALIGN(4);
    etext = .;
  } > external_ram
}

/*--------------------------------------------------------------------------*/
/*                                                                          */
/*   . B S S :   U N I N I T I A L I Z E D    D A T A                       */
/*                                                                          */
/*--------------------------------------------------------------------------*/

SECTIONS {
  .bss : {
    __bss_start = . ;
    *(.bss)
    *(COMMON)
    . = ALIGN(4);
    __bss_end = . ;
    
  } > internal_ram_for_extension
}

/*--------------------------------------------------------------------------*/
/*                                                                          */
/*   . D A T A :   I N I T I A L I Z E D    D A T A                         */
/*                                                                          */
/* Initialized data is loaded at __data_load_start until __data_load_end    */
/* after __bss_end; the code is linked so that it considers the initialized */
/* data to be at etext. Before actual 'start' routine is called, code in    */ 
/* the crt0-for-extension.s source file copies data from __data_load_start  */
/* to __data_start.                                                         */
/*                                                                          */
/*--------------------------------------------------------------------------*/

/*SECTIONS {
  .data : {
      __data_start = . ;
      *(.data) ;
      . = ALIGN(4);
      __data_end = . ;
  } > internal_ram_for_extension
}*/

SECTIONS {
  .data : AT (etext) {
      __data_start = . ;
      *(.data) ;
      . = ALIGN(4);
      __data_end = . ;
  } > internal_ram_for_extension
}

/*--------------------------------------------------------------------------*/

__data_load_start = LOADADDR (.data) ;
__data_load_end   = LOADADDR (.data) + SIZEOF (.data) ;

/*--------------------------------------------------------------------------*/
