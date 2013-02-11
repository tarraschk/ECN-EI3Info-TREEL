.text
.code 32

.global usr_attente_echeance
.type usr_attente_echeance, %function
usr_attente_echeance:
swi #0
bx lr

__swi_dispatcher_table:
.word swi_attente_echeance
.end
