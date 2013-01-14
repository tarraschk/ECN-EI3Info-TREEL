//-------------------------------------------------------------------------*

#include "lpc22xx.h"

//-------------------------------------------------------------------------*

int main (void) {
  // set io pins for led P1.23
  IO1DIR |= (1 << 23) ;  // pin P1.23 is an output, everything else is input after reset
  IO1SET =  1 << 23 ;  // led off
  IO1CLR =  1 << 23 ;  // led on
 
  // endless loop to toggle the red  LED P1.23
  while (1) {
    volatile int j ;
    IO1CLR = 1 << 23 ;
    for (j = 0; j < 500000; j++ );
    IO1SET = 1 << 23 ;
    for (j = 0; j < 2000000; j++ ); 
  }
}

//---------------------------------------------------------------------------*
