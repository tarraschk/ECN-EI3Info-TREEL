//-------------------------------------------------------------------------*

#include "lpc22xx.h"
#include "sorties_s0_s3.h"

//-------------------------------------------------------------------------*

int main (void) {
  // set io pins for led P1.23
  IO1DIR |= (1 << 23) ;  // pin P1.23 is an output, everything else is input after reset
  IO1SET =  1 << 23 ;  // led off
  IO1CLR =  1 << 23 ;  // led on
  initialiser_sorties_s0_s3();
  // endless loop to toggle the LEDs
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

//---------------------------------------------------------------------------*
