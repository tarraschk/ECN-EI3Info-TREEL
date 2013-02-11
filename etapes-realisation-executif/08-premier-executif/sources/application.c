#include "lpc22xx.h"
#include "sorties_s0_s3.h"
#include "afficheur_lcd.h"
#include "services.h"
//--------------------------------------------*
static void tache (const uint32 inArgument1, const uint32 inArgument2) {
  IO1DIR |= (1 << 23) ;  // pin P1.23 is an output, everything else is input after reset
  IO1SET =  1 << 23 ;  // led off
  IO1CLR =  1 << 23 ;  // led on
  initialiser_sorties_s0_s3();
  while (1) {
	int i;
	for(i = 1; i<9; i<<=1) {
		eteindre_sorties_s0_s3(0xF);
		allumer_sorties_s0_s3(i);
		volatile int j;
		for(j = 0; j<500000; j++) {}
	}
  }
}

//--------------------------------------------*
static task_descriptor descripteurTache ;
#define TAILLE_PILE_TACHE (64)
static uint32 gPileTache [TAILLE_PILE_TACHE] ;
//--------------------------------------------*
void initialiser_application (void) {
  initialiser_sorties_s0_s3 () ;
  programmer_uart1 () ;
//---
  swi_create_task (& descripteurTache, 0, gPileTache, TAILLE_PILE_TACHE * 4) ;
  swi_start_task (& descripteurTache, tache, 0, 0) ;
}
//--------------------------------------------*