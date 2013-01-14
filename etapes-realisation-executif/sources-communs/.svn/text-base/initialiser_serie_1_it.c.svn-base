//-------------------------------------------------------------------------*

#include "initialiser_serie_1_it.h"
#include "check-lpc2200-timing-settings.h"
#include "lpc22xx.h"

//-------------------------------------------------------------------------*
//                                                                         *
//   B A U D    R A T E S    C O M P U T A T I O N S                       *
//                                                                         *
//-------------------------------------------------------------------------*

#define BAUD_RATE (19200)

//-------------------------------------------------------------------------*
//    For PCLK = 4 * 14.7456 MHz, if we want BAUD_RATE = 19200 bauds
//    (256 * UART1_DLM + UART1_DLL) = PCLK / (16 * BAUD_RATE) = 192 (an integer value)
//    So UART1_DLM = 0, and UART1_DLL = 192

//    For PCLK = 6 * 10 MHz, if we want BAUD_RATE = 19200 bauds
//    (256 * UART1_DLM + UART1_DLL) = PCLK / (16 * BAUD_RATE) = 195.3125
//    So UART1_DLM = 0, and UART1_DLL = 195

#define SETTING_VALUE (PCLK / (16 * BAUD_RATE))
#define UART1_DLM_VALUE  ((SETTING_VALUE) >> 8)
#define UART1_DLL_VALUE  ((SETTING_VALUE) & 255)

//-------------------------------------------------------------------------*

void initialiser_serie_1_it (const uint32 inSlot,
                             void (spit) (void)) {
//------------------- Init UART1 (see UM10114, chapter 10.4)
//--- 1. Set DLAB=1 in UART1_LCR(for accessing to UART1_DLL)
  U1LCR = 0x80 ;
//--- 2. Set baud rate by writing values to registers UART0_DLL and UART0_DLM
  U1DLM = UART1_DLM_VALUE ;
  U1DLL = UART1_DLL_VALUE ;
//--- 3. Program UART1_LCR
// Bit 7 : 0 (Disable access to Divisor Latches)
// Bit 6 : 0 (Disable break transmission)
// Bits 5-4 : 00 (any value, parity is not enabled)
// Bit 3 : 0 (Disable parity generation and checking)
// Bit 2 : 0 (1 stop bit)
// Bits 1-0 : 11 (8 bit character length)
  U1LCR = 0x03 ;
//--- 4. UART FIFO (UART1_FCR)
// Bit 7-6 : 00 (1 received character triggers interrupt)
// Bits 5-3 : 000 (reserved)
// Bit 2 : 0 (no action on TX FIFO)
// Bit 1 : 0 (no action on RX FIFO)
// Bit 0 : 0->1 (clears TX and RX FIFO, and enables them)
  U1FCR = 0 ;
  U1FCR = 0x01 ;
//--- 5. Select PIN for beeing TXB1 and RXB1
//  Bits 17-16 : 01 (P0.8 is TxD for UART1)
//  Bits 19-18 : 01 (P0.9 is RxD for UART1)
  PINSEL0 &= ~ 0xF0000 ;
  PINSEL0 |=   0x50000 ;
//--- 6. Use vector inSlot for UART1 interrupt
  VICVect(inSlot) = (uint32) spit ;
  VICVectCntl(inSlot) = 0x20 | 7 ;
//--- 7. Use IRQ for receiving characters
//  UART1 gets interruption #7 (mask: 0x80)
  VICIntEnClr   = 1 << 7 ; // UART1 interrupt generates IRQ
  VICIntEnable |= 1 << 7 ; // Enable UART1 interrupt
//--- 8. Enable Receive interrupt for UART1
  U1IER = 1 ; // Bit 0 is receive interrupt enable
}

//---------------------------------------------------------------------------*
