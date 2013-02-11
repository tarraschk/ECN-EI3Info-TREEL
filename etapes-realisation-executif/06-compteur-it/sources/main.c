//-------------------------------------------------------------------------*

#include "lpc22xx.h"
#include "initialiser-compteur-0-it.h"

//-------------------------------------------------------------------------*

//--------------------------------*
static volatile uint32 gCompteur ;
//--------------------------------*
static void isr_compteur_0 (void) {
//--- Acquitter l'interruption
  TIMER0_IR = 1 ;
//--- Compter le temps
  gCompteur ++ ;
}

/*static void attendre_delai (const uint32 inDelai) {
  const uint32 echeance = gCompteur + inDelai ;
while (gCompteur < echeance) {}
}*/

static void attendre_echeance (const uint32 inEcheance) {
  while (gCompteur < inEcheance) {}
}

int main (void) {
  // set io pins for led P1.23
  IO1DIR |= (1 << 23) ;  // pin P1.23 is an output, everything else is input after reset
  IO1SET =  1 << 23 ;  // led off
  IO1CLR =  1 << 23 ;  // led on
  initialiser_compteur_0_it (9, isr_compteur_0);
  // endless loop to toggle the red  LED P1.23
  uint32 echeance = 0 ;
  while (1) {
    IO1CLR = 1 << 23 ;
    //attendre_delai(500) ;
    echeance += 500 ;
    attendre_echeance (echeance) ;
    IO1SET = 1 << 23 ;
    //attendre_delai(500) ;
    echeance += 500 ;
    attendre_echeance (echeance) ;
  }
}

//---------------------------------------------------------------------------*
