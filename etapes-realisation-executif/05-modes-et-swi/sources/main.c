//-------------------------------------------------------------------------*

#include "lpc22xx.h"
#include "sorties_s0_s3.h"
#include "afficheur_lcd.h"
#include "assembleur.h"

//------------------------Exécuté en mode Undefined---------------------------*

int main (void) {
  // set io pins for led P1.23
  IO1DIR |= (1 << 23) ;  // pin P1.23 is an output, everything else is input after reset
  IO1SET =  1 << 23 ;  // led off
  IO1CLR =  1 << 23 ;  // led on
  initialiser_sorties_s0_s3(); //Initialisation sorties S0 à S3
  programmer_uart1(); //Initialisation liaison série 1
  lcd_init();
  // endless loop to launch the program
  int i = 0;
  while (1) {
	lcd_goto_line_column(0,0);
	lcd_print_string("sp: ");
	lcd_print_hex8(get_sp());
	lcd_goto_line_column(1,0);
	lcd_print_string("mode: ");
	lcd_print_hex8(get_mode());
	i++;
	if(i==500) {
		lcd_init();
		lcd_goto_line_column(2,0);
		lcd_print_unsigned(appel_swi_0());
	}
	if(i==1000) {
		lcd_init();
		lcd_goto_line_column(2,0);
		lcd_print_unsigned(appel_swi_1());
		i=0;
	}
  }
}

//--------------------------Exécuté en mode superviseur-----------------------------*
uint32 kernel_appel_swi_0 (void) {
return 23 ;
}
uint32 kernel_appel_swi_1 (void) {
return 145 ;
}