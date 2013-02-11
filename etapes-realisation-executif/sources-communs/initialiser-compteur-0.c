#include "lpc22xx.h"
#include "check-lpc2200-timing-settings.h"
#include "initialiser-compteur-0.h"
//-------------------------------------------------------------------------*
void initialiser_compteur_0 (void) {
//------------------- Init TIMER 0 (see UM10114, chapter 15)
//--- 1. Reset Counter 0 (Timer Control Register)
// Bit 0 : 0 (Disables counting)
// Bit 1 : 1 (Reset)
  TIMER0_TCR = 2 ;
//--- 2. Set Prescaler
//    If PCLK = 4 * 14.7456 MHz
//    We want T = 0.1 ms (counter is incremented every 100 µs), so F = 10 kHz
//    So: PRESCALER = PCLK / F - 1 = 5897
  TIMER0_PR = ((PCLK) / 10000) - 1 ;
//--- 3. Set Match Register 0
//    We want an interrupt every milli-second (1ms = 10 * 100 µs)
  TIMER0_MR0 = 10 - 1 ;
//--- 4. Set Count control Register
//    Bits 1-0: 00 (timer mode)
//    Bits 3-2: XX (any value, because timer mode)
  TIMER0_CCR = 0 ;
//--- 5. Match Control Register
//    Bit 0: 1 (interrupt on MR0 match)
//    Bit 1: 1 (reset on MR0 match)
//    Bit 2: 0 (do not stop on MR0 match)
//    Bit 5-3: 000 (MR1 not used)
//    Bit 8-6: 000 (MR2 not used)
//    Bit 11-9: 000 (MR3 not used)
  TIMER0_MCR = 3 ;
//--- 5. Start Counter 0 (Timer Control Register)
// Bit 0 : 1 (Enables counting)
// Bit 1 : 0 (No reset)
  TIMER0_TCR = 1 ;
}