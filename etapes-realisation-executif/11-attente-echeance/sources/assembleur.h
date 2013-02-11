#include "lpc22xx.h"
void usr_attente_echeance (const uint32 inEcheance); // TODO : faire l'appel à swi_attente_echeance en assembleur
void swi_attente_echeance(const uint32 inEcheance); // TODO : implémenter cette fonction dans application.c