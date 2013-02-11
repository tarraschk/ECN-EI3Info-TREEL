#include "lpc22xx.h"
#include "isr_compteur_0.h"
//--------------------------------*
static volatile uint32 gCompteur ;
//--------------------------------*
static void isr_compteur_0 (void) {
//--- Acquitter l'interruption
  TIMER0_IR = 1 ;
//--- Compter le temps
  gCompteur ++ ;
}