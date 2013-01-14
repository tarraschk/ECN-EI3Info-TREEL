ENTRY(ResetHandler)
SEARCH_DIR(.)

/* Include monitor settings */
INCLUDE sources/script.ld ;

MEMORY {
  internal_flash : org = 0x00000000, len = INTERNAL_FLASH_SIZE
  internal_ram   : org = 0x40000000, len = INTERNAL_RAM_SIZE
  external_ram   : org = EXTERNAL_RAM_ADDRESS, len = EXTERNAL_RAM_SIZE
}

/*--------------------------------------------------------------------------*/
/*                                                                          */
/*    U S E R    P R O G R A M    R E S E R V E D    S P A C E              */
/*                                                                          */
/*--------------------------------------------------------------------------*/

SECTIONS {
  .user_program : {
    . += 512k ;
  } > external_ram
}

/*--------------------------------------------------------------------------*/
/*                                                                          */
/*    H E A P                                                               */
/*                                                                          */
/*--------------------------------------------------------------------------*/

SECTIONS {
  .heap : {        
    __allocation_zone_start = . ;
    . += 512k ;
    . = ALIGN(4);
    __allocation_zone_end = . ;
  } > external_ram
}

/*--------------------------------------------------------------------------*/
/*                                                                          */
/*    M O N I T O R    C O D E                                              */
/*                                                                          */
/*--------------------------------------------------------------------------*/

SECTIONS {
  .text : {
    __vector_start = . ;
    *(.vectors);
    . = ALIGN(4);
    __vector_end = . ;
  /*--- Entry Points */
    __entry_point_source_start = . ;
    *(.entryPointSource) ;
    __entry_point_source_end = . ;
  /*--- Code */
    __code_start = . ;
    *(.init);
    . = ALIGN(4);
  /*--- Tables des routines d'initialisation */
    . = ALIGN (4) ;
    adrTabMonBoot = . ;
    *(.ctors) ; /* initialise les variables globales C++ */
    *(.monBoot) ;
    adrFinTabMonBoot = . ;
    . = ALIGN (4) ;
    adrTabMonInit = . ;
    *(.monInit) ;
    adrFinTabMonInit = . ;
    . = ALIGN (4) ;
    adrTabNetInit = . ;
    *(.netInit) ;
    adrFinTabNetInit = . ;
    . = ALIGN (4) ;
  /*--- Le code du moniteur */
    *(.text.*) ;
    *(.text) ;
    *(text) ;
  /* Interruption temps reel */
    . = ALIGN (4) ;
    __rt_interrupt_service_routine_start = . ;
    *(spittr) ;
    __rt_interrupt_service_routine_end = . ;
  /*--- Le tableau des routines a executer lors du lacement d'un prgm a signature nulle */
    . = ALIGN (4) ;
    adrTabMonExit = . ;
    *(.monExit) ;
    adrFinTabMonExit = . ;
  /*--- Le tableau des commandes du moniteur */
    . = ALIGN (4) ;
    debutTableauCommandes = . ;
    *(tabCmdsSection) ;
    finTableauCommandes = . ;
  /*--- Le tableau des commandes cachÈes du moniteur */
    . = ALIGN (4) ;
    debutTableauCommandesCachees = . ;
    *(tbCmdsCa) ;
    finTableauCommandesCachees = . ;
  /*--- Ethernet Protocol Array */
    . = ALIGN (4) ;
    __ethernet_protocol_start = . ;
    *(ethernetProtocol) ;
    __ethernet_protocol_end = . ;
  /*--- ICMP Protocol Array */
    . = ALIGN (4) ;
    __icmp_protocol_start = . ;
    *(icmpProtocol) ;
    __icmp_protocol_end = . ;
  /*--- IP Protocol Array */
    . = ALIGN (4) ;
    __ip_protocol_start = . ;
    *(ipProtocol) ;
    __ip_protocol_end = . ;
  /*--------*/
    . = ALIGN(4);
    *(.rodata);
    . = ALIGN(4);
    *(.rodata*);
    . = ALIGN(4);
    *(.glue_7t);
    . = ALIGN(4);
    *(.glue_7);
    . = ALIGN(4);
    __code_end = .;
  } > internal_flash
}

/*--------------------------------------------------------------------------*/
/*                                                                          */
/*    I N T E R N A L    R A M                                              */
/*                                                                          */
/*--------------------------------------------------------------------------*/

SECTIONS {
  .entryPointImage : {
    . += 0x40 ;
    __entry_point_target_start = . ;
    . += (ABSOLUTE (__entry_point_source_end) - ABSOLUTE (__entry_point_source_start)) ;
    __entry_point_target_end = . ;
  } > internal_ram
}

/*--------------------------------------------------------------------------*/
/*                                                                          */
/*    I N I T I A L I Z E D    D A T A                                      */
/*                                                                          */
/*--------------------------------------------------------------------------*/

SECTIONS {
  .data : AT (__code_end) {
      __data_start = . ;
      *(.data) ;
      . = ALIGN(4);
      __data_end = . ;
  } > internal_ram
}

/*--------------------------------------------------------------------------*/

__data_load_start = LOADADDR (.data) ;
__data_load_end   = LOADADDR (.data) + SIZEOF (.data) ;

/*--------------------------------------------------------------------------*/
/*                                                                          */
/*    U N I N I T I A L I Z E D    D A T A                                  */
/*                                                                          */
/*--------------------------------------------------------------------------*/

SECTIONS {
  .bss : {
    __bss_start = . ;
    *(.bss) ;
    *(COMMON) ;
    . = ALIGN(4);
    __bss_end = . ;
  } > internal_ram
}

/*--------------------------------------------------------------------------*/

SECTIONS {
  .stack : {
        
    __stack_fiq_start = . ;
    . += FIQ_STACK_SIZE;
    . = ALIGN(4);
    __stack_fiq_end = . ;

    __stack_irq_start = . ;
    . += IRQ_STACK_SIZE;
    . = ALIGN(4);
    __stack_irq_end = . ;

    __stack_abt_start = . ;
    . += ABT_STACK_SIZE;
    . = ALIGN(4);
    __stack_abt_end = . ;

    __stack_und_start = . ;
    . += UND_STACK_SIZE;
    . = ALIGN(4);
    __stack_und_end = .;

    __stack_svc_start = . ;
    . += SVC_STACK_SIZE;
    . = ALIGN(4);
    __stack_svc_end = . ;

    __stack_usr_start = . ;
    . += SVC_STACK_SIZE;
    . = ALIGN(4);
    __stack_usr_end = . ;
  } > internal_ram
}

/*--------------------------------------------------------------------------*/
/*                                                                          */
/*    F R E E    I N T E R N A L    R A M                                   */
/*                                                                          */
/*--------------------------------------------------------------------------*/

__free_internal_ram_start = __stack_usr_end ;
__free_internal_ram_end = 0x40000000 + INTERNAL_RAM_SIZE ;

/*--------------------------------------------------------------------------*/

