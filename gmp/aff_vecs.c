/* RMNLIB - Library of useful routines for C and FORTRAN programming
 * Copyright (C) 1975-2001  Division de Recherche en Prevision Numerique
 *                          Environnement Canada
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation,
 * version 2.1 of the License.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include <gmp.h>
extern GeoMapFlagsStruct   mapFlags;
extern int gmpFlagInterrupt;

void AfficherVecteurs(liste, nbItems, style, couleur, epaisseur)
ListePointsStruct *liste;
int nbItems, style, couleur, epaisseur;
{
   int i, linewidth;
   int largeurFenetre, hauteurFenetre;

   linewidth = c_wglglw();
   switch(mapFlags.verifStatutNecessaire)
      {
      case OUI:
      for (i=0; i < nbItems; i++)
         {
         switch(style)
            {
            case LIGNE:
            case TIRET:
            TracerVecteurs(&liste[i]);
            break;
            
            case POINT:
            TracerPoints(&liste[i]);
            break;
            }

	 if (0 == (i % 64) && linewidth > 1  && gmpFlagInterrupt)
	    {
	    if (c_wglanul())
	       return;
	    }
        }
      break;

      case NON:
      for (i=0; i < nbItems; i++)
         {
         switch(style)
            {
            case LIGNE:
            case TIRET:
            TracerVecteursModeTurbo(&liste[i]);
            break;
            
            case POINT:
            TracerPointsModeTurbo(&liste[i]);
            break;
            }

	 if (0 == (i % 64) && linewidth > 1  && gmpFlagInterrupt)
	    {
	    if (c_wglanul())
	       return;
	    }
         }
      }
   }
