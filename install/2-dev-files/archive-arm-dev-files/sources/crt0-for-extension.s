
   .code 32
   
/*--------------------------------------------------------------------------*/
/*                                                                          */
/*  E X T E N S I O N   H E A D E R                                         */
/*                                                                          */
/*  This header has a structure that corresponds to                         */
/*  the extension_descriptor_struct structure                               */
/*                                                                          */
/*--------------------------------------------------------------------------*/

   .section extensionHeader, "ax"

   .word 0x12345678    /* Magic number #1 */
   .word __entry_point_checksum /* Monitor checksum */
   .word ext_name      /* Extension name ext_name */
   .word __ext_start   /* Start routine */
   .word ext_stop      /* Stop routine */
   .word 0x87654321    /* Magic number #2 */

/*--------------------------------------------------------------------------*/
/*                                                                          */
/*   S T A R T    C O D E                                                   */
/*                                                                          */
/*--------------------------------------------------------------------------*/

  .type __ext_start, %function

__ext_start:
/*--- Clear bss section */
   mov   r0, #0
   ldr   r1, =__bss_start
   ldr   r2, =__bss_end
_bss_clear_loop:
   cmp   r1, r2
   strne r0, [r1], #+4
   bne   _bss_clear_loop 
/*--- Copy initialized data */
   ldr   r1, =__data_load_start /* Source start */
   ldr   r2, =__data_start      /* Target start */
   ldr   r3, =__data_end        /* Target end */
_data_copy_loop: 
   cmp   r2, r3
   ldrne r0, [r1], #+4
   strne r0, [r2], #+4
   bne   _data_copy_loop
/*--- Goto ext_start */
   b     ext_start

/*--------------------------------------------------------------------------*/

   .ltorg

/*--------------------------------------------------------------------------*/

  .end

