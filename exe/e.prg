/* 
 * This file is part of the bring.out FMK, a free and open source 
 * accounting software suite,
 * Copyright (c) 1996-2011 by bring.out doo Sarajevo.
 * It is licensed to you under the Common Public Attribution License
 * version 1.0, the full text of which (including FMK specific Exhibits)
 * is available in the file LICENSE_CPAL_bring.out_FMK.md located at the 
 * root directory of this source code archive.
 * By using this software, you agree to be bound by its terms.
 */


#include "mat.ch"


EXTERNAL DESCEND
EXTERNAL RIGHT

#ifndef LIB

/*! \fn function Main(cKorisn, cSifra, p3, p4, p5, p6, p7)
 *  \brief Main fja za MAT.EXE
 */
function Main(cKorisn, cSifra, p3, p4, p5, p6, p7)
  MainMat(cKorisn, cSifra, p3, p4, p5, p6, p7)
return


#endif


/*! \fn MainePdv(cKorisn, cSifra, p3, p4, p5, p6, p7)
 *  \brief Glavna funkcija Fin aplikacijskog modula
 */
 
function MainMat(cKorisn, cSifra, p3, p4, p5, p6, p7)
local oMat
local cModul

PUBLIC gKonvertPath:="D"

oMat:=TMatModNew()
cModul:="MAT"

PUBLIC goModul

goModul:=oMat
oMat:init(NIL, cModul, D_MAT_VERZIJA, D_MAT_PERIOD , cKorisn, cSifra, p3, p4, p5, p6, p7)

oMat:run()

return



