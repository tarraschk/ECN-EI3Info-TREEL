
   .section .text, "ax"
   .code 32
   
/*--------------------------------------------------------------------------*/
/*                           Entry point                                    */
/*--------------------------------------------------------------------------*/
  .global _entryPoint
  
  .word   __entry_point_checksum
_entryPoint:
/*--- Clear bss section */
   ldr   r1, =__bss_start
   ldr   r2, =__bss_end
   mov   r3, #0
_bss_clear_loop:
   cmp   r1, r2
   strne r3, [r1], #+4
   bne   _bss_clear_loop
/*--- Call main */    
   mov   r0, #0 /* No arguments */
   mov   r1, #0 /* No arguments */
   b     main

/*--------------------------------------------------------------------------*/

   .ltorg

/*--------------------------------------------------------------------------*/
