//-------------------------------------------------------------------------*

#include "lpc22xx.h"
#include "sorties_s0_s3.h"
#include "afficheur_lcd.h"
#include "assembleur.h"
#include "initialiser_serie_1_it.h"

//-------------------------------------------------------------------------*

#define RECEPTION_BUFFER_SIZE (20)
static volatile uint8 gReceptionBuffer [RECEPTION_BUFFER_SIZE] ;
static volatile uint32 gReceptionWriteIndex ;
static volatile uint32 gReceptionReadIndex ;
static volatile uint32 gReceptionCount ;

#define EMISSION_BUFFER_SIZE (10)
static volatile uint8 gEmissionBuffer [EMISSION_BUFFER_SIZE] ;
static volatile uint32 gEmissionReadIndex ;
static volatile uint32 gEmissionWriteIndex ;
static volatile uint32 gEmissionCount ;

//-------------------------------------------------------------------------*

static void spit_serie1 (void) {
  const uint8 interrupt_identification = U1IIR & 0xE ; // Acknowledge
  if (interrupt_identification == 4) { // Reception interrupt ?
  //--- Get received data
    gReceptionBuffer [gReceptionWriteIndex] = U1RBR ;
  //--- If buffer is full, do not change index and receive count
    if (gReceptionCount < RECEPTION_BUFFER_SIZE) { // RDA interrupt
    //---  Handle reception write index
      gReceptionWriteIndex ++ ;
      if (gReceptionWriteIndex == RECEPTION_BUFFER_SIZE) {
        gReceptionWriteIndex = 0 ;
      }
    //---
      gReceptionCount ++ ;
    }
  }else if (interrupt_identification == 2) { // THRE interrupt
    if (gEmissionCount > 0) {
      U1THR = gEmissionBuffer [gEmissionReadIndex] ; // Transmit Character
      gEmissionReadIndex ++ ;
      if (gEmissionReadIndex == EMISSION_BUFFER_SIZE) {
        gEmissionReadIndex = 0 ;
      }
      gEmissionCount -- ;
    }
    if (gEmissionCount == 0) {
      U1IER &= 0xFD ; // Disable THRE interrupt
    }
  }
}

//-------------------------------------------------------------------------*

void envoyer_caractere_serie1 (const char inCaractere) {
//--- Wait for buffer not full
  while (gEmissionCount == EMISSION_BUFFER_SIZE) {}
//--- If emission buffer is empty and UART1 ready to send, transmit data directly
  if ((gEmissionCount == 0) && ((U1LSR & 0x20) != 0)) {
    U1THR = inCaractere ; // Transmit Character
  }else{
  //--- Enter data in the buffer
    gEmissionBuffer [gEmissionWriteIndex] = inCaractere ;
    gEmissionWriteIndex ++ ;
    if (gEmissionWriteIndex == EMISSION_BUFFER_SIZE) {
      gEmissionWriteIndex = 0 ;
    }
    //--- BUG : gEmissionCount est partagée avec le sp d'it
      appel_swi_1();
  //--- Enable THRE interrupt
    U1IER |= 0x02 ; // Enable THRE interrupt
  }
}

//-------------------------------------------------------------------------*

bool recevoir_caractere_serie1 (uint8 * outCaractere) {
  const bool recu = gReceptionCount > 0 ;
//---
  if (recu) {
    * outCaractere = gReceptionBuffer [gReceptionReadIndex] ;
    gReceptionReadIndex ++ ;
    if (gReceptionReadIndex == RECEPTION_BUFFER_SIZE) {
      gReceptionReadIndex = 0 ;
    }
    //--- BUG : gReceptionCount est partagée avec le sp d'it
      appel_swi_0();
    //---
  }
//---
  return recu ;
}

//-------------------------------------------------------------------------*

static void reporter_entrees (void) {
  uint8 nouvellesEntrees = 0 ;
  if (recevoir_caractere_serie1 (& nouvellesEntrees)) {
    lcd_goto_line_column (2, 0) ;
    lcd_print_string ("F0-F3 : ") ;
    lcd_print_hex1 (nouvellesEntrees >> 4) ;
    lcd_goto_line_column (3, 0) ;
    lcd_print_string ("F0-F3 : ") ;
    lcd_print_hex1 (nouvellesEntrees & 15) ;
  }
}

//--------------------------Exécuté en mode superviseur-----------------------------*
uint32 kernel_appel_swi_0 (void) {
	gReceptionCount --;
return 23;
}
uint32 kernel_appel_swi_1 (void) {
	gEmissionCount ++;
return 145 ;
}

//------------------------Exécuté en mode Undefined---------------------------*

int main (void) {
  initialiser_sorties_s0_s3 () ;
  initialiser_serie_1_it (9, spit_serie1) ;
  lcd_init () ;
  lcd_print_string ("Hello !") ;



  // set io pins for led P1.23
  IO1DIR |= (1 << 23) ;  // pin P1.23 is an output, everything else is input after reset
  IO1SET =  1 << 23 ;  // led off
  IO1CLR =  1 << 23 ;  // led on
 
  // endless loop to toggle the red  LED P1.23
  uint32 valeur = 8 ;
  uint32 compteur = 0 ;
  while (1) {
    volatile int j ;
    IO1CLR = 1 << 23 ;
    allumer_sorties_s0_s3 (valeur) ;
    valeur >>= 1 ;
    if (0 == valeur) {
      valeur = 8 ;
      lcd_goto_line_column (1, 0) ;
      lcd_print_unsigned (compteur) ;
      compteur ++ ;
    }
    reporter_entrees () ;
    for (j = 0 ; j < 500000; j++ );
    IO1SET = 1 << 23 ;
    eteindre_sorties_s0_s3 (15) ;
    reporter_entrees () ;
    for (j = 0 ; j < 2000000; j++ );
    lcd_goto_line_column (0, 0) ;
  }
}

//---------------------------------------------------------------------------*
