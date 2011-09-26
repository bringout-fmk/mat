#include "mat.ch"


function specif()

O_ROBA
O_SIFV
O_SIFK
O_TARIFA
O_SUBAN
O_PARTN
O_KONTO

cIdFirma:=gFirma
qqKonto:=qqPartn:=SPACE(55)
cIdTarifa:=space(6)
dDATOD=dDatDO:=CTOD("")
//cDN:="D"
cFmt:="2"
Box("Spec",8,65,.f.)

@ m_x+1,m_y+2 SAY "SPECIFIKACIJA - Izvjestaj formata A3/A4 (1/2)" GET cFmt VALID cFmt $ "12"
read
if cFmt=="2"
 cFmt:="1"
 @ m_x+2,m_y+2 SAY "Iznos u "+ValPomocna()+"/"+ValDomaca()+"(1/2) ?" GET cFmt VALID cFmt $ "12"
 read
 if cFmt=="1"; cFmt:="2"; else; cFmt:="3"; endif
endif

if gNW$"DR"
  @ m_x+4,m_y+2 SAY "Firma "; ?? gFirma,"-",gNFirma
else
  @ m_x+4,m_y+2 SAY "Firma: " GET cIdFirma valid {|| P_Firma(@cIdFirma),cidfirma:=left(cidfirma,2),.t.}
endif
@ m_x+5,m_y+2 SAY KonSeks("Konta  ")+" : " GET qqKonto  PICTURE "@S50"
@ m_x+6,m_y+2 SAY "Partner : " GET qqPartn  PICTURE "@S50"
@ m_x+7,m_y+2 SAY "Tarifa (prazno-sve) : " GET cidTarifa  valid empty(cidtarifa) .or. P_Tarifa(@cIdTarifa)
@ m_x+8,m_y+2 SAY "Datum dokumenta - od datuma:"    GET dDatOd
@ m_x+8,col()+1 SAY "do:"    GET dDatDo valid dDatDo>=dDatOd

do while .t.
READ; ESC_BCR
  aUsl1:=Parsiraj(qqKonto,"IdKonto","C")
  aUsl2:=Parsiraj(qqPartn,"IdPartner","C")
  if aUsl1<>NIL .and. aUsl2<>NIL; exit; endif
enddo

BoxC(); ESC_RETURN 0

cIdFirma:=left(cIdFirma,2)

*
SELECT SUBAN
#ifndef C50
set order to tag "3"
#else
set order to 3
#endif

if len(aUsl2)==0
 if !empty(dDatOd) .or. !empty(dDatDo)
  set filter to cIdFirma==IdFirma .and. Tacno(aUsl1) ;
               .and. dDatOd<=DatDok .and. dDatDo>=DatDok
 else
   set filter to cIdFirma==IdFirma .and. Tacno(aUsl1)
 endif
else
 if !empty(dDatOd) .or. !empty(dDatDo)
  set filter to cIdFirma==IdFirma .and. Tacno(aUsl1) ;
                .and. dDatOd<=DatDok .and. dDatDo>=DatDok .and. Tacno(aUsl2)
 else
   set filter to cIdFirma==IdFirma .and. Tacno(aUsl1) .and. Tacno(aUsl2)
 endif
endif
go top
EOF CRET

if cFmt=="1" // A3
 m:="---- ---------- ---------------------------------------- --- ---------- ---------- ---------- ---------- ---------- ---------- ----------- ----------- ----------- ------------ ------------ ------------"
elseif cFmt=="2"
 m:="---- ---------- ---------------------------------------- --- ---------- ---------- ---------- ----------- ----------- -----------"
else
 m:="---- ---------- ---------------------------------------- --- ---------- ---------- ---------- ------------ ------------ ------------"
endif

START PRINT CRET


nCDI:=0
DO WHILE !eof()

   cIdKonto:=IdKonto
   IF prow()==0
      P_COND
      ?? "MAT.P: SPECIFIKACIJA STANJA (U "
      if cFmt=="1"
       ?? ValPomocna()+"/"+ValDomaca()+") "
      elseif cFmt=="2"
       ?? ValPomocna()+") "
      else
       ?? ValDomaca()+") "
      endif
      if !empty(dDatOd) .or. !empty(dDatDo)
        ?? "ZA PERIOD OD",dDatOd,"-",dDatDo
      endif
      ?? "      NA DAN:"
      @ prow(),pcol()+1 SAY DATE()
      if !empty(qqPartn)
        @ prow()+1,0 SAY "Kriterij za partnera:"; ?? trim(qqPartn)
      endif
      if !empty(cidtarifa)
        @ prow()+1,0 SAY "Tarifa: "; ?? cidtarifa
      endif
      @ prow()+1,0 SAY "FIRMA:"
      @ prow(),pcol()+1 SAY cIdFirma
      SELECT PARTN; HSEEK cIdFirma
      @ prow(),pcol()+1 SAY naz; @ prow(),pcol()+1 SAY naz2
      @ prow()+1,0 SAY KonSeks("KONTO")+":"
      @ prow(),pcol()+1 SAY cIdKonto
      select konto; hseek cidkonto
      @ prow(),pcol()+1 SAY naz
      select SUBAN
      ?  m
      if cFmt=="1"
       ? "*R. *  SIFRA   *       N A Z I V                        *J. *   ZADNJA *  ZADNJA  *  ZADNJA  *       K O L I C I N A          *     V R I J E D N O S T    "+ValPomocna()+"   *        V R I J E D N O S T   "+ValDomaca()+"   *"
       ? " Br.                                                    *   *    NC    *    VPC   *   MPC     ------------------------------- ------------------------------------ --------------------------------------"
       ? "*   *          *                                        *MJ.*          *          *          *   ULAZ   *  IZLAZ   *  STANJE  *  DUGUJE   * POTRAZUJE *   SALDO   *  DUGUJE    *  POTRAZUJE *  SALDO    *"
     elseif cFmt=="2"
       ? "*R. *  SIFRA   *       N A Z I V                        *J. *       K O L I C I N A          *     V R I J E D N O S T          *"
       ? "*Br.*                                                       -------------------------------- ------------------------------------"
       ? "*   *          *                                        *MJ.*   ULAZ   *  IZLAZ   *  STANJE  *  DUGUJE   * POTRAZUJE *  SALDO   *"
      elseif cFmt=="3"
       ? "*R. *  SIFRA   *       N A Z I V                        *J. *       K O L I C I N A          *        V R I J E D N O S T          *"
       ? "*Br.*                                                       -------------------------------- ---------------------------------------"
       ? "*   *          *                                        *MJ.*   ULAZ   *  IZLAZ   *  STANJE  *  DUGUJE    *  POTRAZUJE *  SALDO    *"
      endif
       ?  m
   ENDIF
   B:=0
   nUkDugI:=nUkPotI:=0
   nUkDugI2:=nUkPotI2:=0
   do while  !eof() .and.  cIdKonto==IdKonto

      IF prow()>63; FF; ENDIF

      SELECT SUBAN
      cIdRoba:=IdRoba
      select roba; hseek cidroba; select suban
      if !empty(cIdTarifa)
          if roba->idtarifa<>cIdtarifa
             skip
             loop
          endif
      endif
      nDugI:=nPotI:=nUlazK:=nIzlazK:=0
      nDugI2:=nPotI2:=nUlazK2:=nIzlazK2:=0
      DO WHILE !eof() .AND. cIdkonto==IdKonto .AND. cIdRoba=IdRoba
          IF U_I="1"
             nUlazK+=Kolicina
          ELSE
             nIzlazK+=Kolicina
          ENDIF
          IF D_P="1"
             nDugI+=Iznos
             nDugI2+=Iznos2
          ELSE
             nPotI+=Iznos
             nPotI2+=Iznos2
          ENDIF
       SKIP
      ENDDO // IdRoba
      select roba
      cRoba:=naz; cjmj:=jmj

      nSaldoK:=nUlazK-nIzlazK
      nSaldoI:=nDugI-nPotI
      nSaldoK2:=nUlazK2-nIzlazK2
      nSaldoI2:=nDugI2-nPotI2
      @ prow()+1,0 SAY ++B PICTURE '9999'
      @ prow(),pcol()+1 SAY cIdRoba
      @ prow(),pcol()+1 SAY cRoba
      @ prow(),pcol()+1 SAY cjmj
      if cFmt=="1"
        @ prow(),pcol()+1 SAY NC   picture "999999.999"
        @ prow(),pcol()+1 SAY VPC  picture "999999.999"
        @ prow(),pcol()+1 SAY MPC  picture "999999.999"
      endif
      @ prow(),pcol()+1 SAY nUlazK PICTURE picKol
      @ prow(),pcol()+1 SAY nIzlazK PICTURE picKol
      @ prow(),pcol()+1 SAY nSaldoK PICTURE picKol
      nCDI:=pcol()
     if cFmt $ "12"
      @ prow(),pcol()+1 SAY nDugI PICTURE PicDEM
      @ prow(),pcol()+1 SAY nPotI PICTURE PicDEM
      @ prow(),pcol()+1 SAY nSaldoI PICTURE PicDEM
     endif
     if cFmt $ "13"
      @ prow(),pcol()+1 SAY nDugI2 PICTURE PicBHD
      @ prow(),pcol()+1 SAY nPotI2 PICTURE PicBHD
      @ prow(),pcol()+1 SAY nSaldoI2 PICTURE PicBHD
     endif


      nUkDugI+=nDugI
      nUkPotI+=nPotI
      nUkDugI2+=nDugI2
      nUkPotI2+=nPotI2
      nDugI:=nPotI:=nUlazK:=nIzlazK:=0
      nDugI2:=nPotI2:=nUlazK2:=nIzlazK2:=0

      select SUBAN
  enddo // konto

?  m
?  "UKUPNO ZA:"+cIdKonto
@  prow(),nCDI SAY ""
if cFmt $ "12"
 @ prow(),pcol()+1 SAY nUkDugI PICTURE PicDEM
 @ prow(),pcol()+1 SAY nUkPotI PICTURE PicDEM
 @ prow(),pcol()+1 SAY nUkDugI-nUkPotI PICTURE PicDEM
endif
if cFmt $ "13"
 @ prow(),pcol()+1 SAY nUkDugI2          PICTURE PicBHD
 @ prow(),pcol()+1 SAY nUkPotI2          PICTURE PicBHD
 @ prow(),pcol()+1 SAY nUkDugI2-nUkPotI2 PICTURE PicBHD
endif
? m

FF

ENDDO // firma

END PRINT
closeret

FUNCTION KonSekS(cNaz)
RETURN IF(gSekS=="D","PREDMET",cNaz)


PROCEDURE IArtPoPogonima()
  O_PARTN         // pogoni
  O_ROBA          // artikli
  O_SIFV
  O_SIFK
  O_SUBAN         // dokumenti

  cIdRoba:=SPACE(LEN(ROBA->id))
  dOd:=CTOD("")
  dDo:=DATE()
  gOstr:="D"; gTabela:=1
  cSaIznosima:="D"
  qqPartner:=""
  // artikal : ulaz, izlaz, cijena

  O_PARAMS
  Private cSection:="7",cHistory:=" ",aHistory:={}
  Params1()
  RPar("c1",@cIdRoba)
  RPar("c2",@dOd)
  RPar("c3",@dDo)
  RPar("c4",@cSaIznosima)
  RPar("c5",@qqPartner)

  qqPartner := PADR(qqPartner,60)

  Box(,7,70)
    @ m_x+2, m_y+2 SAY "Artikal (prazno-svi): " GET cIdRoba VALID EMPTY(cIdRoba) .or. P_Roba(@cIdRoba,2,24) PICT "@!"
    @ m_x+3, m_y+2 SAY "Za period od:" GET dOd
    @ m_x+3, col()+2 SAY "do:" GET dDo
    @ m_x+4, m_y+2 SAY "Prikazati iznose? (D/N)" GET cSaIznosima VALID cSaIznosima $ "DN" PICT "@!"
    @ m_x+5, m_y+2 SAY "Uslov za pogone (prazno-svi)" GET qqPartner PICT "@S30"
    DO WHILE .t.
      READ; ESC_BCR
      aUsl1:=Parsiraj(qqPartner,"IDPARTNER","C")
      IF aUsl1<>NIL; EXIT; ENDIF
    ENDDO
  BoxC()

  qqPartner := TRIM(qqPartner)

  if Params2()
    WPar("c1",cIdRoba)
    WPar("c2",dOd)
    WPar("c3",dDo)
    WPar("c4",cSaIznosima)
    WPar("c5",qqPartner)
  endif
  select params; use

SELECT SUBAN

IF EMPTY(cIdRoba)
  // svi artikli
  // -----------
  Box(,2,30)
    nSlog:=0; nUkupno:=RECCOUNT2()
    cSort1 := "IDROBA"
    cFilt  := "DATDOK>=dOd .and. DATDOK<=dDo "
    IF !EMPTY(qqPartner)
      cFilt += ( ".and." + aUsl1 )
    ENDIF
    INDEX ON &cSort1 TO "TMPMAT" FOR &cFilt EVAL(TekRec()) EVERY 1
  BoxC()

  GO TOP
  if eof(); Msg("Ne postoje trazeni podaci...",6); closeret; endif

  START PRINT CRET

  PRIVATE cIdRoba:="", cArtikal:="", cJMJ:="", nRBr:=0
  PRIVATE nUlaz:=0, nIzlaz:=0, nKol:=0, nDuguje:=0, nPotrazuje:=0, nSaldo:=0

  aKol:={ { "R.BR."        , {|| STR(nRBr,4)+"."}, .f., "C", 5, 0, 1, ++nKol},;
          { "SIFRA"        , {|| cIdRoba        }, .f., "C",10, 0, 1, ++nKol},;
          { "NAZIV ARTIKLA", {|| cArtikal       }, .f., "C",40, 0, 1, ++nKol},;
          { "J.MJ."        , {|| PADC(cJMJ,5)   }, .f., "C", 5, 0, 1, ++nKol},;
          { "ULAZ "+cJMJ   , {|| nUlaz          }, .f., "N",12, 2, 1, ++nKol},;
          { "IZLAZ "+cJMJ  , {|| nIzlaz         }, .f., "N",12, 2, 1, ++nKol} }

  IF cSaIznosima=="D"
    AADD( aKol , { "DUGUJE"   , {|| nDuguje    }, .t., "N",12, 2, 1, ++nKol} )
    AADD( aKol , { "POTRAZUJE", {|| nPotrazuje }, .t., "N",12, 2, 1, ++nKol} )
    AADD( aKol , { "SALDO"    , {|| nSaldo     }, .t., "N",12, 2, 1, ++nKol} )
  ENDIF

  P_10CPI
  ?? gnFirma
  ?
  ? "DATUM  : "+SrediDat(DATE())
  ? "POGONI : "+IF( EMPTY(qqPartner) , "SVI" , TRIM(qqPartner) )

  StampaTabele(aKol,{|| FSvaki2s()},,gTabela,,;
       ,"Specifikacija svih artikala - pregled za period od "+DTOC(dod)+" do "+DTOC(ddo),;
                               {|| FFor2s()},IF(gOstr=="D",,-1),,,,,)
  FF
  END PRINT
ELSE
  // jedan artikal
  // -------------
  Box(,2,30)
    nSlog:=0; nUkupno:=RECCOUNT2()
    cSort1 := "IDPARTNER"
    cFilt  := "IDROBA==cIdRoba .and. DATDOK>=dOd .and. DATDOK<=dDo "
    IF !EMPTY(qqPartner)
      cFilt += ( ".and." + aUsl1 )
    ENDIF
    INDEX ON &cSort1 TO "TMPMAT" FOR &cFilt EVAL(TekRec()) EVERY 1
  BoxC()

  GO TOP
  if eof(); Msg("Ne postoje trazeni podaci...",6); closeret; endif

  START PRINT CRET

  PRIVATE cIdPartner:="", cNPartnera:=""
  PRIVATE nUlaz:=0, nIzlaz:=0, nKol:=0, nDuguje:=0, nPotrazuje:=0, nSaldo:=0

  cJMJ:="("+ROBA->jmj+")"

  aKol:={ { "SIFRA"       , {|| cIdPartner         }, .f., "C", 6, 0, 1, ++nKol},;
          { "PARTNER/MJESTO TROSKA", {|| cNPartnera}, .f., "C",50, 0, 1, ++nKol},;
          { "ULAZ "+cJMJ  , {|| nUlaz              }, .t., "N",12, 2, 1, ++nKol},;
          { "IZLAZ "+cJMJ , {|| nIzlaz             }, .t., "N",12, 2, 1, ++nKol} }

  IF cSaIznosima=="D"
    AADD( aKol , { "DUGUJE"   , {|| nDuguje    }, .t., "N",12, 2, 1, ++nKol} )
    AADD( aKol , { "POTRAZUJE", {|| nPotrazuje }, .t., "N",12, 2, 1, ++nKol} )
    AADD( aKol , { "SALDO"    , {|| nSaldo     }, .t., "N",12, 2, 1, ++nKol} )
  ENDIF

  P_10CPI
  ?? gnFirma
  ?
  ? "DATUM  : "+SrediDat(DATE())
  ? "ARTIKAL: "+cIdRoba+" - "+ROBA->naz

  StampaTabele(aKol,{|| FSvaki1s()},,gTabela,,;
       ,"Specifikacija artikla - pregled po pogonima za period od "+DTOC(dod)+" do "+DTOC(ddo),;
                               {|| FFor1s()},IF(gOstr=="D",,-1),,,,,)
  FF
  END PRINT
ENDIF

CLOSERET


FUNCTION FFor1s()
 cIdPartner:=idpartner
 cNPartnera:=Ocitaj(F_PARTN,idpartner,"TRIM(naz)+' '+TRIM(naz2)")
 nUlaz:=nIzlaz:=nDuguje:=nPotrazuje:=nSaldo:=0
 DO WHILE !EOF() .and. idpartner==cIdPartner
   IF u_i=="1"
     nDuguje += iznos
     nSaldo  += iznos
     nUlaz   += kolicina
   ELSE
     nPotrazuje += iznos
     nSaldo     -= iznos
     nIzlaz     += kolicina
   ENDIF
   SKIP 1
 ENDDO
 SKIP -1
RETURN .t.


PROCEDURE FSvaki1s()
RETURN


FUNCTION FFor2s()
 LOCAL nArr := SELECT()
 ++nRBr
 cIdRoba := idroba
 SELECT ROBA; SEEK cIdRoba
 cArtikal := TRIM(naz)
 cJMJ     := TRIM(jmj)
 SELECT (nArr)
 nUlaz:=nIzlaz:=nDuguje:=nPotrazuje:=nSaldo:=0
 DO WHILE !EOF() .and. idroba==cIdRoba
   IF u_i=="1"
     nDuguje += iznos
     nSaldo  += iznos
     nUlaz   += kolicina
   ELSE
     nPotrazuje += iznos
     nSaldo     -= iznos
     nIzlaz     += kolicina
   ENDIF
   SKIP 1
 ENDDO
 SKIP -1
RETURN .t.


PROCEDURE FSvaki2s()
RETURN

