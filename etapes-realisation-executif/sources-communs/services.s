.code 32
.section .text
.global __swi_dispatcher_table
__swi_dispatcher_table:
.word swi_create_task
.word swi_task_self_terminate
.word swi_preempt
.global usr_create_task
.type usr_create_task, %function
usr_create_task:
swi #0
bx lr
.global usr_task_self_terminate
.type usr_task_self_terminate, %function
usr_task_self_terminate:
swi #1
bx lr
.global usr_preempt
.type usr_preempt, %function
usr_preempt:
swi #2
bx lr
