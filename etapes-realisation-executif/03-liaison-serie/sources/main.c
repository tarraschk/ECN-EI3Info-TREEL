//-------------------------------------------------------------------------*

#include "lpc22xx.h"
#include "sorties_s0_s3.h"
#include "afficheur_lcd.h"

//-------------------------------------------------------------------------*

int main (void) {
  // set io pins for led P1.23
  IO1DIR |= (1 << 23) ;  // pin P1.23 is an output, everything else is input after reset
  IO1SET =  1 << 23 ;  // led off
  IO1CLR =  1 << 23 ;  // led on
  initialiser_sorties_s0_s3(); //Initialisation sorties S0 à S3
  programmer_uart1(); //Initialisation liaison série 1
  lcd_init();
  // endless loop to launch the program
  while (1) {
	int i;
	lcd_goto_line_column(0,0);
	lcd_print_string("Mon super TP!");
	for(i = 1; i<9; i<<=1) {
		eteindre_sorties_s0_s3(0xF);
		lcd_goto_line_column(15,0);
		lcd_print_spaces(5);
		lcd_goto_line_column(2,0);
		lcd_print_string("Allumage LED : ");
		if(i==8) {
			lcd_print_unsigned(4);
		}
		else {
			lcd_print_string(" ");
		}
		if(i==4) {
			lcd_print_unsigned(3);
		}
		else {
			lcd_print_string(" ");
		}
		if(i==2) {
			lcd_print_unsigned(2);
		}
		else {
			lcd_print_string(" ");
		}
		if(i==1) {
			lcd_print_unsigned(1);
		}
		else {
			lcd_print_string(" ");
		}
		allumer_sorties_s0_s3(i);
		volatile int j;
		for(j = 0; j<5000000; j++) {}
	}
  }
}

//---------------------------------------------------------------------------*
