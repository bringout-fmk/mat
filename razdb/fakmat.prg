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


function fakmat()

O_PARAMS
// select 99; use (PRIVPATH+"params") index (PRIVPATH+"parai1")
private cSection:="T",cHistory:=" "; aHistory:={}

private gDirFakt:="",gVN:=gVD:="41"
RPar("df",@gDirFakt)
RPar("vn",@gVN)
if empty(gDirFakt)
  gDirFakt:=strtran(cDirRad,"MAT","FAKT")+"\"
  WPar("df",gDirFakt)
endif
select 99; use

private opc[2]
Opc[1]:="1. prenos fakt -> mat"
Opc[2]:="2. parametri"
h[1]:=h[2]:=""


Izbor:=1
do while .t.
Izbor:=menu("osn",opc,Izbor,.f.)

   do case
     case Izbor==0
       exit
     case izbor == 1
         Prenos()
     case izbor == 2
         ParamT()
   endcase

enddo

return

************************************
************************************
function paramT()

O_PARAMS
// select 99; use (PRIVPATH+"params") index (PRIVPATH+"parai1")
private cSection:="T",cHistory:=" "; aHistory:={}

gDirFakt:=padr(gDirFakt,25)
Box(,4,70)
  @ m_x+1,m_y+2 SAY "Direktorij u kome se nalazi FAKT.DBF:" GET gDirFakt
  @ m_x+3,m_y+2 SAY "Vrsta naloga u mat   :" GET gVN
  @ m_x+4,m_y+2 SAY "Vrsta dokumenta mat  :" GET gVD
  read
BoxC()
gDirFakt:=trim(gDirFakt)
WPar("df",gDirFakt)
WPar("fi",gFirma)
WPar("vn",gVN)
WPar("vd",gVD)
select 99; use
return


**************************************
**************************************
function Prenos()

local cIdFirma:=gFirma,cIdTipDok:="11",cBrdok:=space(8),cBrMat:="",;
      cIdZaduz:=space(6)


O_PRIPR
O_NALOG
O_ROBA
O_SIFV
O_SIFK
O_KONTO
O_PARTN
O_VALUTE

#ifndef C50
use  (gDirFakt+"FAKT") new; set order to tag "1"
#else
use  (gDirFakt+"FAKT")   index (gDirFakt+"fakti1") new
#endif

dDatMat:=date()
cIdKonto:=cIdKonto2:=space(7)
cIdZaduz2:=space(6)

select nalog
#ifndef C50
set order to tag "1"
#else
set order to 1
#endif
seek cidfirma+gVN+"X"
skip -1
if idvn<>gVN
   cbrmat:="0"
else
   cbrmat:=brnal
endif

Box(,15,60)

cbrmat:=padl(alltrim( str(val(cbrmat)+1) ),4,"0")
do while .t.

  nRBr:=0
  @ m_x+1,m_y+2   SAY "Broj naloga mat "+gVN+" -" GET cBrMat pict "@!"
  @ m_x+1,col()+2 SAY "Datum:" GET dDatMat
  @ m_x+3,m_y+2   SAY "Konto zaduzuje :" GET cIdKonto  pict "@!" valid P_Konto(@cIdKonto)
  @ m_x+3,col()+2 SAY "Zaduzuje:" GET cIdZaduz  pict "@!"      valid empty(cidzaduz2) .or. P_Firma(@cIdZaduz)

  @ m_x+6,m_y+2 SAY "Broj fakture: " +cIdFirma
  @ m_x+6,col()+1 SAY "- "+cidtipdok
  @ m_x+6,col()+1 SAY "-" GET cBrDok
  read
  if lastkey()==K_ESC; exit; endif


  select fakt
  seek cIdFirma+cIdTipDok+cBrDok
  if !found()
     Beep(4)
     @ m_x+14,m_y+2 SAY "Ne postoji ovaj dokument !!"
     inkey(4)
     @ m_x+14,m_y+2 SAY space(30)
     loop
  else
     aMemo:=parsmemo(txt)
      if len(aMemo)>=5
        @ m_x+10,m_y+2 SAY trim(amemo[3])
        @ m_x+11,m_y+2 SAY trim(amemo[4])
        @ m_x+12,m_y+2 SAY trim(amemo[5])
      else
         cTxt:=""
      endif
      inkey(0)
      //cIdPartner:=space(6)
      //@ m_x+14,m_y+2 SAY "Sifra partnera:"  GET cIdpartner pict "@!" valid P_Firma(@cIdPartner)
      read

     select PRIPR
     locate for BrDok=cBrDok // faktura je vec prenesena
     if found()
      Beep(4)
      @ m_x+8,m_y+2 SAY "Dokument je vec prenesen !!"
      inkey(4)
      @ m_x+8,m_y+2 SAY space(30)
      loop
     endif
     go bottom
     if brnal==cBrMat; nRbr:=val(Rbr); endif
     select fakt
     do while !eof() .and. cIdFirma+cIdTipDok+cBrDok==IdFirma+IdTipDok+BrDok
       select ROBA; hseek fakt->idroba

       select fakt
       if alltrim(podbr)=="."
          skip
          loop
       endif
       if fakt->cijena<>roba->mpc  // nivelacija
        select roba; hseek fakt->idroba
        select PRIPR
        APPEND BLANK
        replace idfirma with fakt->idfirma,;
                rbr     with str(++nRbr,4),;
                idvn with gVN,;   // izlazna faktura
                idtipdok with gVD,;
                brnal with cBrMat,;
                datdok with dDatMat,;
                brdok with fakt->brdok,;
                datdok with fakt->datdok,;
                idkonto   with cidkonto,;
                idzaduz  with cidzaduz,;
                datkurs with fakt->datdok,;
                kolicina with 0,;
                idroba with fakt->idroba,;
                cijena with 0,;
                u_i with "1",;
                d_p with "1",;
                iznos with (fakt->cijena-roba->mpc)*fakt->kolicina,;
                iznos2 with iznos*Kurs(datdok)

       endif
       select PRIPR
       APPEND BLANK
       replace idfirma with fakt->idfirma,;
               rbr     with str(++nRbr,4),;
               idvn with gVN,;   // izlazna faktura
               idtipdok with gVD,;
               brnal with cBrMat,;
               datdok with dDatMat,;
               brdok with fakt->brdok,;
               datdok with fakt->datdok,;
               idkonto   with cidkonto,;
               idzaduz  with cidzaduz,;
               datkurs with fakt->datdok,;
               kolicina with fakt->kolicina,;
               idroba with fakt->idroba,;
               cijena with fakt->cijena,;
               u_i with "2",;
               d_p with "2",;
               iznos with cijena*kolicina,;
               iznos2 with iznos*Kurs(datdok)

       select fakt
       skip
     enddo
     @ m_x+8,m_y+2 SAY "Dokument je prenesen !!"
     // cbrmat:=padl(alltrim( str(val(cbrmat)+1) ),4,"0")
     inkey(4)
     @ m_x+8,m_y+2 SAY space(30)
  endif

enddo
Boxc()
closeret
return


