/****************************************************************************/
/*                           Reset handler                                  */
/****************************************************************************/

   .section .text, "ax"
   .code 32
   
   .global IRQHandler


/****************************************************************************/
/*                           IRQ handler                                    */
/****************************************************************************/

VICVectAddr = 0xFFFFF030

/****************************************************************************/

IRQHandler:
/*--- Save shared registers */
  sub   r14, r14, #4
  stmfd r13!, {r0-r12, r14}
/*--- R1 <- contents of VICVectAddr register (call user interrupt routine) */
  ldr   r1, =VICVectAddr
  ldr   r1, [r1]
/*--- Link Register -> return address */
  mov   lr, pc
/*--- Call user interrupt routine */
  bx    r1
/*--- Acknowledge interrupt service (write any value into VICVectAddr register) */
  ldr   r0, =VICVectAddr
  str   r0, [r0]
/*--- Return from interrupt */
  ldmfd r13!, {r0-r12, pc}^

/****************************************************************************/

   .ltorg

/****************************************************************************/

  .end
