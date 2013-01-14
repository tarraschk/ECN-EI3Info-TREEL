
  .code 32
  .section .text

/*---------------------------------------------------------------------------*/

   ARM_MODE_USER  = 0x10      /* Normal User Mode */ 
   IO1CLR         = 0xE002801C
   IO1SET         = 0xE0028014
   IO1DIR         = 0xE0028018

/*---------------------------------------------------------------------------*/
/*                                                                           */
/*              A R M 7    C O N T E X T                                     */
/*                                                                           */
/*---------------------------------------------------------------------------*/

/* ARM7 task context is stored is an 17 * 4 byte buffer.                     */

/* The gRunningTaskContextSaveAddress shared variable points to the buffer   */
/* associated to the current task.                                           */

/*                                                                   offset  */
/*                                           *---------------------*         */
/*                                           | PC_USR              | +64     */
/*                                           | R12                 | +60     */
/*                                           | R11                 | +56     */
/*                                           | R10                 | +52     */
/*                                           | R9                  | +48     */
/*                                           | R8                  | +44     */
/*                                           | R7                  | +40     */
/*                                           | R6                  | +36     */
/*                                           | R5                  | +32     */
/*                                           | R4                  | +28     */
/*                                           | R3                  | +24     */
/*                                           | R2                  | +20     */
/*                                           | R1                  | +16     */
/*                                           | R0                  | +12     */
/*                                           | LR_USR              | + 8     */
/* *--------------------------------*        | SP_USR              | + 4     */
/* | gRunningTaskContextSaveAddress +------> | CPSR                | + 0     */
/* *--------------------------------*        *---------------------*         */

/*---------------------------------------------------------------------------*/
/*                                                                           */
/*        C O N T R O L   R E G I S T E R S                                  */
/*                                                                           */
/*---------------------------------------------------------------------------*/

  VICVectAddr = 0xFFFFF030

/*---------------------------------------------------------------------------*/
/*                                                                           */
/*        A R M    A B I                                                     */
/*                                                                           */
/*---------------------------------------------------------------------------*/

/*--- From document ARM IHI 0042C, current through ABI release 2.07          */

/* The first four registers r0-r3 are used to pass argument values into a    */
/* subroutine and to return a result value from a function. They may also be */
/* used to hold intermediate values within a routine (but, in general, only  */
/* between subroutine calls).                                                */

/* A subroutine must preserve the contents of the registers r4-r8, r10, r11  */
/* and SP (and r9 in PCS variants that designate r9 as v6).                  */

/*--- So we can freely use r9 in SWI handler ? No, we preserve r4-r11        */

/*---------------------------------------------------------------------------*/
/*                                                                           */
/*        S W I    H A N D L E R                                             */
/*                                                                           */
/* As interrupts are disabled, we can use sp as a general purpose register.  */
/* A valid stack pointer will be set up before calling a sub routine.        */
/*---------------------------------------------------------------------------*/

  .global SWIHandler

SWIHandler:
/*-------------------------- Save working registers */
  stmfd sp!, {r6-r8, lr}
/*-------------------------- Led On */
  ldr   r8, =IO1CLR
  mov   r6, #1 << 23
  str   r6, [r8]
/*--------------------------- Get SWI Immediat value */
/*   LDRH loads a halfword from memory and zero-extends it to a 32-bit word. */
  ldrh  r6, [lr, #-4] /* Get 16 last bits of swi instruction */
/*--------------------------- r8 <- address of swi_xxx routine to call */
  ldr   r8, =__swi_dispatcher_table
  ldr   r8, [r8, r6, LSL #2]
/*--------------------------- R6 <- address of gRunningTaskContextSaveAddress */
  ldr   r6, =gRunningTaskContextSaveAddress
/*--------------------------- Save context pointer of current running task in R7 */
  ldr   r7, [r6]
/*--------------------------- Call swi_xxx routine */
  mov   lr, pc
  bx    r8
/*--------------------------- Select Running Task */
  mov   r8, r0 /* Save return value (if any) */
  bl    kernel_selectTaskToRun
  mov   r0, r8 /* Restore return value */
/*--------------------------- R2 <- address of new running task */
/*  R7: context of running task on SWI call */
/*  R6: 'gRunningTaskContextSaveAddress' address */
  ldr   r2, [r6]
  mov   r3, r7 /* R3: context of running task on SWI call */
/*--------------------------- Restore task registers */
  ldmfd sp!, {r6-r8, lr}
/*--------------------------- Context Switch */
  teq    r2, r3 /* Compare R2 (new task), with R3 (calling task) */
  moveqs pc, lr /* Return from interrupt if no context swith */
/*--------------------------- Perform the context switch */
/*----------- First save context of calling task */
/*--- If sp is NULL, there is no context to save */
  movs  r3, r3
  beq   __restore_context_of_running_task
/*--- Save registers R0, ..., R12, LR of calling task */
  add   r3, r3, #12 /* Make room for sp_usr, lr_usr and cpsr_usr */
  stmia r3, {r0-r12, lr}
/*--- cpsr_usr -> R8 */
  mrs   r8, spsr
/*--- Save sp_usr (R8) */
  str   r8, [r3, #-12]
/*--- Store sp_usr, lr_usr */
  sub   r3, r3, #8 /* Restore original value of R8 */
  stmia r3, {r13, r14}^
/*----------- Restore context of the new running task */
__restore_context_of_running_task:
  movs  r2, r2
  beq   __no_context_to_restore
/*--- Restore cpsr_usr from R8 */
  ldr   r8, [r2]
  msr   spsr, r8
/*--- Restore sp_usr, lr_usr */
  add   r2, r2, #4
  ldmia r2, {r13, r14}^
/*--- Restore registers R0, ..., R12, and PC */
/*    (^ and pc using perform here return from interrupt) */
  add   r2, r2, #8
  ldmia r2, {r0-r12, pc}^

/*---------------------------------------------------------------------------*/

__no_context_to_restore:
/*--- Led Off */
  ldr   r8, =IO1SET
  mov   r6, #1 << 23
  str   r6, [r8]
/*--- Set User Mode, interrupts enabled */
  msr   CPSR_c, #ARM_MODE_USER
/*--- Wait for interrupt */
__wait_interrupt:
  b     __wait_interrupt

/*---------------------------------------------------------------------------*/
/*                                                                           */
/*        I R Q    H A N D L E R                                             */
/*                                                                           */
/*---------------------------------------------------------------------------*/

  .global IRQHandler
  .global __entry_point
  .type __entry_point, %function
  .type kernel_selectTaskToRun, %function

IRQHandler:
/*--------------------------- Adjust return address */
  sub   r14, r14, #4
/*--------------------------- Save r0 on IRQ stack */
  stmfd sp!, {r0}
/*--------------------------- Context save */
/*--- R8 <- Address of current task context save */
  ldr   r0, =gRunningTaskContextSaveAddress
  ldr   r0, [r0]
/*--- If r0 is NULL, there is no context to save */
  movs  r0, r0
  beq   __no_context_to_save_on_irq
/*--- Save registers R1, ..., R12, LR */
  add   r0, r0, #16 /* Make room for sp_usr, lr_usr, cpsr_usr and r0 */
  stmia r0, {r1-r12, lr}
/*--- cpsr_usr -> R8 */
  mrs   r8, spsr
/*--- Save sp_usr (R8) */
  sub   r0, r0, #16 /* Restore original value */
  str   r8, [r0]
/*--- Store sp_usr, lr_usr */
  add   r0, r0, #4
  stmia r0, {r13, r14}^
/*--- Store user task r0 */
  add   r0, r0, #8
  ldr   r1, [sp]
  str   r1, [r0]
/*--------------------------- Adjust IRQ stack */
__no_context_to_save_on_irq:
  add   sp, sp, #4
/*--------------------------- Led On */
  ldr   r8, =IO1CLR
  mov   r6, #1 << 23
  str   r6, [r8]
/*--------------------------- IRQ Body : run interrupt service routine */
/*--- R1 <- contenu du registre VICVectAddr (call interrupt routine service) */
  ldr   r1, =VICVectAddr
  ldr   r1, [r1]
/*--- Link Register -> return address */
  mov   lr, pc
/*--- Call interrupt routine service */
  bx    r1
/*--- Acknowledge interrupt service (write any value into VICVectAddr register) */
  ldr   r0, =VICVectAddr
  str   r0, [r0]
/*--------------------------- Select Running Task */
__start: /* This entry point is kernel start routine */
  bl    kernel_selectTaskToRun
/*--------------------------- Context restore */
/*--- r0 <- Address of current running task context save */
  ldr   r0, =gRunningTaskContextSaveAddress
  ldr   r0, [r0]
  movs  r0, r0
  beq   __no_context_to_restore
/*--- Restore cpsr_usr (r1) */
  ldr   r1, [r0]
/*--- Restore cpsr_usr from r1 */
  msr   spsr, r1
/*--- Restore sp_usr, lr_usr */
  add   r0, r0, #4
  ldmia r0, {r13, r14}^
/*--- Restore registers R0, ..., R12, PC */
/*    ('^' and 'pc' means return from interrupt) */
  add   r0, r0, #8
  ldmia r0, {r0-r12, pc}^

/*---------------------------------------------------------------------------*/
/*                                                                           */
/*        E N T R Y    P O I N T                                             */
/*                                                                           */
/*---------------------------------------------------------------------------*/

__entry_point:
/*-------------------------- P1.23 -> output */
  ldr   r8, =IO1DIR
  ldr   r6, [r8]
  orr   r6, r6, #1 << 23
  str   r6, [r8]
/*-------------------------- Led On */
  ldr   r8, =IO1CLR
  mov   r6, #1 << 23
  str   r6, [r8]
/*--------------------------*/
  b     __start

/*---------------------------------------------------------------------------*/
