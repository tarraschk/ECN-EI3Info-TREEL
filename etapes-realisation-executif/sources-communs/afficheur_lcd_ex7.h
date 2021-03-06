//---------------------------------------------------------------------------*

#ifndef LCD_ROUTINES_DEFINED
#define LCD_ROUTINES_DEFINED

//---------------------------------------------------------------------------*

#include "processor-defines.h"

//---------------------------------------------------------------------------*
//   En cas d'inclusion à partir d'un fichier C++                            *
//---------------------------------------------------------------------------*

#ifdef __cplusplus
  extern "C" {
#endif

//-------------------------------------------------------------------------*
// Routine a definir 

bool recevoir_caractere_serie1 (uint8 * outCaractere);
uint8 attente_caractere_serie1 (void);
void envoyer_caractere_serie1 (const char inCaractere) ;

//-------------------------------------------------------------------------*

void programmer_uart1 (void) ;

//-------------------------------------------------------------------------*

void lcd_init (void) ;

void lcd_goto_line_column (const uint32 inLine, const uint32 inColumn) ;

void lcd_print_char (const char inChar) ;

void lcd_print_string (const char * inString) ;

void lcd_print_unsigned (const uint32 inValue) ;

void lcd_print_unsigned_with_leading_spaces (const uint32 inValue, const uint32 inDisplayWidth) ;

void lcd_print_signed (const int inValue) ;

void lcd_print_signed_with_leading_spaces (const int inValue, const uint32 inDisplayWidth) ;

void lcd_print_hex1 (const uint8 inValue) ;

void lcd_print_hex2 (const uint8 inValue) ;

void lcd_print_hex4 (const uint16 inValue) ;

void lcd_print_hex8 (const uint32 inValue) ;

void lcd_print_spaces (const uint32 inSpaceCount) ;

void lcd_backlight (const bool inBacklightOn) ;

//---------------------------------------------------------------------------*
//   En cas d'inclusion à partir d'un fichier C++                            *
//---------------------------------------------------------------------------*

#ifdef __cplusplus
  }
#endif

//---------------------------------------------------------------------------*

#endif

//---------------------------------------------------------------------------*
