//-------------------------------------------------------------------------*

#include "lpc22xx.h"
#include "sorties_s0_s3.h"

//-------------------------------------------------------------------------*

void initialiser_sorties_s0_s3 (void) {
  IO1CLR  = (1 << 20) | (1 << 21) | (1 << 22) | (1 << 24) ;
  IO1DIR |= (1 << 20) | (1 << 21) | (1 << 22) | (1 << 24) ;
}

//-------------------------------------------------------------------------*

void allumer_sorties_s0_s3 (const unsigned inValeur) {
  unsigned v = 0 ;
  if ((inValeur & 1) != 0) { // P1.20
    v = (1 << 20) ;
  }
  if ((inValeur & 2) != 0) { // P1.24
    v |= (1 << 24) ;
  }
  if ((inValeur & 4) != 0) { // P1.21
    v |= (1 << 21) ;
  }
  if ((inValeur & 8) != 0) { // P1.22
    v |= (1 << 22) ;
  }
  IO1SET = v ;
}

//-------------------------------------------------------------------------*

void eteindre_sorties_s0_s3 (const unsigned inValeur) {
  unsigned v = 0 ;
  if ((inValeur & 1) != 0) { // P1.20
    v = (1 << 20) ;
  }
  if ((inValeur & 2) != 0) { // P1.24
    v |= (1 << 24) ;
  }
  if ((inValeur & 4) != 0) { // P1.21
    v |= (1 << 21) ;
  }
  if ((inValeur & 8) != 0) { // P1.22
    v |= (1 << 22) ;
  }
  IO1CLR = v ;
}

//-------------------------------------------------------------------------*