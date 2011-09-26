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



