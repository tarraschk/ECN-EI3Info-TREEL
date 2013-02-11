.text
.code 32
.global get_sp
.type get_sp, %function
get_sp:
mov r0, sp
bx lr
.global get_mode
.type get_mode, %function
get_mode:
mrs r0, CPSR /* r0 <- CPSR */
bx lr
.global appel_swi_0
.type appel_swi_0, %function
appel_swi_0:
swi #0
bx lr
.global SWIHandler
SWIHandler:
/*-------------------------- Save working registers */
stmfd sp!, {r7-r8, lr}
/*--------------------------- Get SWI Immediat value */
/* LDRH loads a halfword from memory and zero-extends it to a 32-bit word. */
ldrh r7, [lr, #-4] /* Get 16 last bits of swi instruction */
/*--------------------------- r8 <- address of kernel_xxx routine to call */
ldr r8, =__swi_dispatcher_table
ldr r8, [r8, r7, LSL #2]
/*--------------------------- Call kernel_xxx routine */
mov lr, pc
bx r8
/*--------------------- Restore working registers, return from interrupt */
ldmfd sp!, {r7-r8, pc}^
__swi_dispatcher_table:
.word kernel_appel_swi_0
.word kernel_appel_swi_1
.global appel_swi_1
.type appel_swi_1, %function
appel_swi_1:
swi #1
bx lr
.end
