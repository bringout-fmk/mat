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



function Povrat()

if Klevel<>"0"
    Beep(2)
    Msg("Nemate pristupa ovoj opciji !",4)
    closeret
endif

O_SUBAN
O_ANAL
O_SINT
O_NALOG
O_PRIPR
O_ROBA
O_SIFK
O_SIFV

SELECT SUBAN
set order to tag "4"

cIdFirma:=gFirma
cIdVN:=space(2)
cBrNal:=space(4)

Box("",1,35)
 @ m_x+1,m_y+2 SAY "Nalog:"
 if gNW$"DR"
  @ m_x+1,col()+1 SAY gFirma
 else
  @ m_x+1,col()+1 GET cIdFirma
 endif
 @ m_x+1,col()+1 SAY "-" GET cIdVN
 @ m_x+1,col()+1 SAY "-" GET cBrNal
 read; ESC_BCR
BoxC()

seek cidfirma+cidvn+cbrNal
if Pitanje("","Nalog "+cIdFirma+"-"+cIdVN+"-"+cBrNal+" povuci u pripremu (D/N) ?","N")=="N"
   closeret
endif


if !(  suban->(flock()) .and. anal->(flock()) .and. sint->(flock()) .and. nalog->(flock()) )
  Beep(1)
  Msg("Neko vec koristi datoteke !")
  closeret
endif

MsgO("SUBAN")
select SUBAN
do while !eof() .and. cIdFirma==IdFirma .and. cIdVN==IdVN .and. cBrNal==BrNal
   select PRIPR; Scatter()
   select SUBAN; Scatter()
   select PRIPR
   APPEND NCNL
   if _Iznos<>0 .and. _Kolicina<>0
     _Cijena:=_Iznos/_Kolicina
   else
     _Cijena:=0
   endif
   Gather2()

   nUlazK:=nIzlK:=nDug:=nPot:=0
   IF _U_I="1"
     nUlazK:=_Kolicina
   ELSE
     nIzlK:=_Kolicina
   ENDIF
   IF _D_P="1"
      nDug:=_Iznos
   ELSE
      nPot:=_Iznos
   ENDIF

   select SUBAN
   skip; nRec:=recno(); skip -1
   dbdelete2()
   go nRec
enddo
use
MsgC()

MsgO("ANAL")
select ANAL
#ifndef C50
set order to tag "2"
#else
set order to 2
#endif
seek cidfirma+cidvn+cbrNal
do while !eof() .and. cIdFirma==IdFirma .and. cIdVN==IdVN .and. cBrNal==BrNal
 skip; nRec:=recno(); skip -1
 dbdelete2()
 go nRec
enddo
use
MsgC()


MsgO("SINT")
select SINT
#ifndef C50
set order to tag "2"
#else
set order to 2
#endif
seek cidfirma+cidvn+cbrNal
do while !eof() .and. cIdFirma==IdFirma .and. cIdVN==IdVN .and. cBrNal==BrNal
 skip; nRec:=recno(); skip -1
 dbdelete2()
 go nRec
enddo
use
MsgC()

MsgO("NALOG")
select nalog
seek cidfirma+cidvn+cbrNal
do while !eof() .and. cIdFirma==IdFirma .and. cIdVN==IdVN .and. cBrNal==BrNal
  skip; nRec:=recno(); skip -1
  dbdelete2()
  go nRec
enddo
use
MsgC()
closeret
return


// ----------------------------------------------
// generacija dokumenta pocetnog stanja
// ----------------------------------------------
function PrenosMat()

O_PRIPR

if reccount2()<>0
	MsgBeep("Priprema mora biti prazna !!!")
  	closeret
	return
endif

zap
set order to
index on idfirma+idkonto+idpartner+idroba to "PRIPTMP"
GO TOP

Box(,5,60)
	nMjesta := 3
  	dDatDo := DATE()
  	@ m_x+3, m_y+2 SAY "Datum do kojeg se promet prenosi" GET dDatDo
  	read
	ESC_BCR
BoxC()

start print cret

O_SUBANX

// ovo je bio stari indeks, stari prenos bez partnera
//set order to tag "3"
// "3" - "IdFirma+IdKonto+IdRoba+dtos(DatDok)"

set order to tag "5"
// "5" - "IdFirma+IdKonto+IdPartner+IdRoba+dtos(DatDok)"

? "Prolazim kroz bazu...."
select suban
go top

// idfirma, idkonto, idpartner, idroba, datdok
do while !eof()

  nRbr := 0
  cIdFirma := idfirma
 
  do while !eof() .and. cIdFirma == IdFirma
      
      cIdKonto := IdKonto
      select suban
      
      nDin:=0
      nDem:=0
      
      do while !eof() .and. cIdFirma==IdFirma .and. cIdKonto==IdKonto
        
	cIdPartner := idpartner

	do while !eof() .and. cIdFirma==IdFirma .and. cIdKonto==IdKonto .and. IdPartner==cIdPartner
	
	   cIdRoba:=IdRoba
        
	   ? "Konto:", cIdKonto, ", partner:", cIdPartner, ", roba:", cIdRoba
        
	   do while !eof() .and. cIdFirma==IdFirma .and. cIdKonto==IdKonto .and. IdRoba==cIdRoba
         
	 	select pripr
         
	 	hseek suban->(idfirma + idkonto + idpartner + idroba)
         
	 	if !found()

           		append blank
           		
			replace idfirma with cIdFirma
                   	replace idkonto with cIdkonto
			replace idpartner with cIdPartner
                   	replace idRoba  with cIdRoba
                   	replace datdok with dDatDo + 1
                   	replace datkurs with dDatDo + 1
                   	replace idvn with "00"
			replace idtipdok with "00"
                   	replace brnal with "0001"
                  	replace d_p with "1"
                   	replace u_i with "1"
                   	replace rbr with "9999"
                   	replace kolicina with ;
				iif(suban->U_I=="1", suban->kolicina, ;
				-suban->kolicina)
                   	replace iznos with ;
				iif(suban->D_P=="1", suban->iznos, ;
				-suban->iznos)
                   	replace iznos2 with ;
				iif(suban->D_P=="1", suban->iznos2, ;
				-suban->iznos2)
         	
		else
           
	   		replace kolicina with ;
				kolicina + iif(suban->U_I=="1", ;
				suban->kolicina, -suban->kolicina)
                     	
			replace iznos with ;
				iznos + iif(suban->D_P=="1", ;
				suban->iznos,-suban->iznos)
                     	
			replace iznos2 with ;
				iznos2 + iif(suban->D_P=="1", ;
				suban->iznos2,-suban->iznos2)
         
		endif
         
	 	select suban
         	skip
        
	    enddo //  roba

	enddo // partner

      enddo // konto
  
  enddo // firma

enddo // eof

select pripr
// set order to 0
set order to
go top
do while !eof()
	if round(iznos,2)==0 .and. round(iznos2,2)==0 .and. ;
		round(kolicina,3) == 0
      		dbdelete2()
  	endif
  	skip
enddo
__dbpack()

set order to tag "1"
go top

nTrec := 0

do while !eof()
	cIdFirma := idfirma
  	nRbr := 0
  	do while !eof() .and. cIdFirma==IdFirma
    		skip 
		nTrec := recno()
		skip -1
    		replace rbr with str(++nRbr,4)
            	replace cijena with iif(Kolicina<>0,Iznos/Kolicina,0)
    		go nTrec
  	enddo
enddo
close all

end print

if !EMPTY( gSezonDir ) .and. ;
	Pitanje(,"Prebaciti dokument u radno podrucje","D")=="D"
	
	O_PRIPRRP
  	O_PRIPR
  	select priprrp
  	append from pripr
  	select pripr
	zap
  	close all
  	if Pitanje(,"Prebaciti se na rad sa radnim podrucjem ?","D")=="D"
      		URadPodr()
  	endif
endif

closeret

return



// u MAT modulu ne trebamo kreirati tabele rabata
//
function crerabdb()
return

function crefmkpi()
return


