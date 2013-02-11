#include "lpc22xx.h"
#include "sorties_s0_s3.h"
#include "afficheur_lcd.h"
#include "services.h"
#include "initialiser-compteur-0-it.h"
//--------------------------------------------*
static volatile uint32 gCurrentDate ;
static void spit_compteur_0 (void) {
//--- Acquitter l'interruption
  TIMER0_IR = 1 ;
//--- Compter le temps
  gCurrentDate ++ ;
//--- Préemption
  swi_preempt();
}
//-------------------------------------------*
static void attendre_echeance (const uint32 inEcheance) {
  while (gCurrentDate < inEcheance) {}
}
//--------------------------------------------*
static void tache (const uint32 inArgument1, const uint32 inArgument2) {
	uint32 echeance =  0;
	while(1) {
		eteindre_sorties_s0_s3(inArgument1);
	    echeance += inArgument2 ;
	    attendre_echeance (echeance) ;
		allumer_sorties_s0_s3(inArgument1);
	    echeance += inArgument2 ;
	    attendre_echeance (echeance) ;
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
  initialiser_compteur_0_it(9, spit_compteur_0);
  initialiser_sorties_s0_s3 () ;
  programmer_uart1 () ;
//---
  swi_create_task (& descripteurTache1, 0, gPileTache, TAILLE_PILE_TACHE * 4) ;
  swi_create_task (& descripteurTache2, 0, gPileTache, TAILLE_PILE_TACHE * 4) ;
  swi_create_task (& descripteurTache3, 0, gPileTache, TAILLE_PILE_TACHE * 4) ;
  swi_create_task (& descripteurTache4, 0, gPileTache, TAILLE_PILE_TACHE * 4) ;
  swi_start_task (& descripteurTache1, tache, 1,  500) ;
  swi_start_task (& descripteurTache2, tache, 2, 1000) ;
  swi_start_task (& descripteurTache3, tache, 4, 2000) ;
  swi_start_task (& descripteurTache4, tache, 8, 4000) ;
}
//--------------------------------------------*