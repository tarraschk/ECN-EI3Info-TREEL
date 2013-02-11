#include "lpc22xx.h"
#include "sorties_s0_s3.h"
#include "afficheur_lcd.h"
#include "services.h"
//--------------------------------------------*
static void tache (const uint32 inArgument1, const uint32 inArgument2) {
		eteindre_sorties_s0_s3(inArgument1);
		volatile uint32 j;
		for(j = 0; j<inArgument2; j++) {
			swi_preempt();
		}
		allumer_sorties_s0_s3(inArgument1);
		for(j = 0; j<inArgument2; j++) {
			swi_preempt();
		}
}

//--------------------------------------------*
static task_descriptor descripteurTache1 ;
static task_descriptor descripteurTache2 ;
static task_descriptor descripteurTache3 ;
static task_descriptor descripteurTache4 ;
#define TAILLE_PILE_TACHE (64)
static uint32 gPileTache [TAILLE_PILE_TACHE] ;
//--------------------------------------------*
void initialiser_application (void) {
  initialiser_sorties_s0_s3 () ;
  programmer_uart1 () ;
//---
  swi_create_task (& descripteurTache1, 0, gPileTache, TAILLE_PILE_TACHE * 4) ;
  swi_create_task (& descripteurTache2, 0, gPileTache, TAILLE_PILE_TACHE * 4) ;
  swi_create_task (& descripteurTache3, 5, gPileTache, TAILLE_PILE_TACHE * 4) ;
  swi_create_task (& descripteurTache4, 0, gPileTache, TAILLE_PILE_TACHE * 4) ;
  swi_start_task (& descripteurTache1, tache, 1,  500000) ;
  swi_start_task (& descripteurTache2, tache, 2, 1000000) ;
  swi_start_task (& descripteurTache3, tache, 4,   50000) ;
  swi_start_task (& descripteurTache4, tache, 8,  200000) ;
}
//--------------------------------------------*