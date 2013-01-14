//---------------------------------------------------------------------------*
//                                                                           *
//  MONITOR EXTENSION STRUCTURE                                              *
//                                                                           *
//  Copyright (C) 2009, ..., 2009 Pierre Molinaro.                           *
//                                                                           *
//  e-mail : molinaro@irccyn.ec-nantes.fr                                    *
//                                                                           *
//  IRCCyN, Institut de Recherche en Communications et Cybernétique de Nantes*
//  ECN, Ecole Centrale de Nantes (France)                                   *
//                                                                           *
//  This program is free software; you can redistribute it and/or modify it  *
//  under the terms of the GNU General Public License as published by the    *
//  Free Software Foundation.                                                *
//                                                                           *
//  This program is distributed in the hope it will be useful, but WITHOUT   *
//  ANY WARRANTY; without even the implied warranty of MERCHANDIBILITY or    *
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for *
//  more details.                                                            *
//                                                                           *
//---------------------------------------------------------------------------*

#ifndef MONITOR_EXTENSION_DEFINED
#define MONITOR_EXTENSION_DEFINED

//---------------------------------------------------------------------------*

#include "processor-defines.h"

//---------------------------------------------------------------------------*
//                                                                           *
//    E X T E N S I O N    R O U T I N E S                                   *
//                                                                           *
//---------------------------------------------------------------------------*

extern const char * ext_name __attribute__ ((section ("romData"))) ;

bool ext_start (void) ;

void ext_stop (void) ;

//---------------------------------------------------------------------------*

#endif
