//-------------------------------------------------------------------------*

#include "lpc22xx.h"
#include "initialiser-compteur-0.h"

//-------------------------------------------------------------------------*
bool top_periode (void);
static void attendre_top_periode (void);

int main (void) {
  // set io pins for led P1.23
  IO1DIR |= (1 << 23) ;  // pin P1.23 is an output, everything else is input after reset
  IO1SET =  1 << 23 ;  // led off
  IO1CLR =  1 << 23 ;  // led on
  initialiser_compteur_0();
  // endless loop to toggle the red  LED P1.23
  while (1) {
    volatile int j ;
    IO1CLR = 1 << 23 ;
    for (j = 0; j < 1000; j++ ) {
      attendre_top_periode();	
    }
    IO1SET = 1 << 23 ;
    for (j = 0; j < 1000; j++ ) {
      attendre_top_periode();	
    }
  }
}

bool top_periode (void) {
  const bool result = (TIMER0_IR & 1) != 0 ;
  if (result) {
    TIMER0_IR = 1 ;
  }
  return result ;
}

static void attendre_top_periode (void) {
  while (! top_periode ()) {}
}

//---------------------------------------------------------------------------*
