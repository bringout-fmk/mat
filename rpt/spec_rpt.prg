#include "mat.ch"

************************************************************************
// RUDNIK - pregled isporucenog materijala
// po mjestima troskova
************************************************************************
function PoMjeTros()

O_PARTN
O_SUBAN

qqRoba1:=space(60); cRoba1:=SPACE(10)
qqRoba2:=space(60); cRoba2:=SPACE(10)
qqRoba3:=space(60); cRoba3:=SPACE(10)
qqRoba4:=space(60); cRoba4:=SPACE(10)
qqRoba5:=space(60); cRoba5:=SPACE(10)
qqRoba6:=space(60); cRoba6:=SPACE(10)
qqIDVN:=space(30)
dDatOd:=ctod(""); dDatDo:=date(); gOstr:="D"; gTabela:=1

O_PARAMS
private cSection:="5",cHistory:=" "; aHistory:={}
Params1()
RPar("d1",@dDatOd); RPar("d2",@dDatDo)
RPar("O1",@cRoba1); RPar("O2",@cRoba2); RPar("O3",@cRoba3)
RPar("O4",@cRoba4); RPar("O5",@cRoba5); RPar("O6",@cRoba6)
RPar("F1",@qqRoba1); RPar("F2",@qqRoba2); RPar("F3",@qqRoba3)
RPar("F4",@qqRoba4); RPar("F5",@qqRoba5); RPar("F6",@qqRoba6)
RPar("F7",@qqIDVN)

qqRoba1:=PADR(qqRoba1,60); qqRoba2:=PADR(qqRoba2,60); qqRoba3:=PADR(qqRoba3,60)
qqRoba4:=PADR(qqRoba4,60); qqRoba5:=PADR(qqRoba5,60); qqRoba6:=PADR(qqRoba6,60)
qqIDVN:=PADR(qqIDVN,30)


Box(,12,70)
do while .t.
 @ m_X+1,m_Y+15 SAY "NAZIV               USLOV"
 @ m_X+2,m_Y+ 2 SAY "Asortiman 1" GET cRoba1
 @ m_X+2,m_Y+26 GET qqRoba1    pict "@!S30"
 @ m_X+3,m_Y+ 2 SAY "Asortiman 2" GET cRoba2
 @ m_X+3,m_Y+26 GET qqRoba2    pict "@!S30"
 @ m_X+4,m_Y+ 2 SAY "Asortiman 3" GET cRoba3
 @ m_X+4,m_Y+26 GET qqRoba3    pict "@!S30"
 @ m_X+5,m_Y+ 2 SAY "Asortiman 4" GET cRoba4
 @ m_X+5,m_Y+26 GET qqRoba4    pict "@!S30"
 @ m_X+6,m_Y+ 2 SAY "Asortiman 5" GET cRoba5
 @ m_X+6,m_Y+26 GET qqRoba5    pict "@!S30"
 @ m_X+7,m_Y+ 2 SAY "Asortiman 6" GET cRoba6
 @ m_X+7,m_Y+26 GET qqRoba6    pict "@!S30"

 @ m_X+ 9,m_Y+2 SAY "Za period od" GET dDatOD
 @ m_X+ 9,col()+2 SAY "do" GET dDatDo
 @ m_X+10, m_y+2 SAY "Uslov za vrstu naloga" GET qqIDVN PICT "@!"
 @ m_X+11, m_y+2 SAY "Ukljuceno ostranicavanje ? (D/N)" GET gOstr VALID gOstr$"DN" PICT "@!"
 @ m_X+11,m_y+38 SAY "Tip tabele (0/1/2)" GET gTabela VALID gTabela<3.and.gTabela>=0 PICT "9"
 read; ESC_BCR
 aUsl1:=Parsiraj(qqRoba1,"IDROBA")
 aUsl2:=Parsiraj(qqRoba2,"IDROBA")
 aUsl3:=Parsiraj(qqRoba3,"IDROBA")
 aUsl4:=Parsiraj(qqRoba4,"IDROBA")
 aUsl5:=Parsiraj(qqRoba5,"IDROBA")
 aUsl6:=Parsiraj(qqRoba6,"IDROBA")
 aUsl7:=Parsiraj(qqIDVN,"IDVN")
 if aUsl1<>NIL .and. aUsl2<>NIL .and. aUsl3<>NIL .and. aUsl4<>NIL .and.;
    aUsl5<>NIL .and. aUsl6<>NIL .and. aUsl7<>NIL
   exit
 endif
enddo
BoxC()

Params2()
qqRoba1:=trim(qqRoba1); qqRoba2:=trim(qqRoba2); qqRoba3:=trim(qqRoba3)
qqRoba4:=trim(qqRoba4); qqRoba5:=trim(qqRoba5); qqRoba6:=trim(qqRoba6)
qqIDVN:=trim(qqIDVN)

WPar("d1",dDatOd) ; WPar("d2",dDatDo)
WPar("O1",cRoba1) ; WPar("O2",cRoba2) ; WPar("O3",cRoba3)
WPar("O4",cRoba4) ; WPar("O5",cRoba5) ; WPar("O6",cRoba6)
WPar("F1",qqRoba1); WPar("F2",qqRoba2); WPar("F3",qqRoba3)
WPar("F4",qqRoba4); WPar("F5",qqRoba5); WPar("F6",qqRoba6)
WPar("F7",qqIDVN)

select params; use

SELECT SUBAN

Box(,2,30)
  nSlog:=0; nUkupno:=RECCOUNT2()
  cSort1 := "IDPARTNER"
  cFilt  := "DATDOK>=dDatOd .and. DATDOK<=dDatDo .and. Tacno(aUsl7) .and. U_I=='2'"
  INDEX ON &cSort1 TO "TMPMAT" FOR &cFilt EVAL(TekRec()) EVERY 1
BoxC()

GO TOP
if eof(); Msg("Ne postoje trazeni podaci...",6); closeret; endif

START PRINT CRET

PRIVATE cIdPartner:="", cNPartnera:=""
PRIVATE nRoba1:=0, nRoba2:=0, nRoba3:=0, nRoba4:=0, nRoba5:=0, nRoba6:=0

aKol:={ { "SIFRA"       , {|| cIdPartner         }, .f., "C", 6, 0, 1, 1},;
        { "PARTNER/MJESTO TROSKA", {|| cNPartnera}, .f., "C",50, 0, 1, 2},;
        { cRoba1        , {|| nRoba1             }, .t., "N",10, 2, 1, 3},;
        { cRoba2        , {|| nRoba2             }, .t., "N",10, 2, 1, 4},;
        { cRoba3        , {|| nRoba3             }, .t., "N",10, 2, 1, 5},;
        { cRoba4        , {|| nRoba4             }, .t., "N",10, 2, 1, 6},;
        { cRoba5        , {|| nRoba5             }, .t., "N",10, 2, 1, 7},;
        { cRoba6        , {|| nRoba6             }, .t., "N",10, 2, 1, 8} }

P_10CPI
?? gnFirma
?
? "DATUM:",SrediDat(DATE())
? "USLOV ZA VRSTU NALOGA:"+IF(EMPTY(qqIDVN),"SVI NALOZI",TRIM(qqIDVN))

StampaTabele(aKol,{|| FSvaki1()},,gTabela,,;
     ,"Isporuceni asortiman - pregled po kupcima za period od "+DTOC(ddatod)+" do "+DTOC(ddatdo),;
                             {|| FFor1()},IF(gOstr=="D",,-1),,,,,)

END PRINT

CLOSERET


FUNCTION FFor1()
 cIdPartner:=idpartner
 nRoba1:=nRoba2:=nRoba3:=nRoba4:=nRoba5:=nRoba6:=0
 cNPartnera:=Ocitaj(F_PARTN,idpartner,"TRIM(naz)+' '+TRIM(naz2)")
 DO WHILE !EOF() .and. idpartner==cIdPartner
   IF Tacno(aUsl1); nRoba1+=kolicina; ENDIF
   IF Tacno(aUsl2); nRoba2+=kolicina; ENDIF
   IF Tacno(aUsl3); nRoba3+=kolicina; ENDIF
   IF Tacno(aUsl4); nRoba4+=kolicina; ENDIF
   IF Tacno(aUsl5); nRoba5+=kolicina; ENDIF
   IF Tacno(aUsl6); nRoba6+=kolicina; ENDIF
   SKIP 1
 ENDDO
 SKIP -1
RETURN .t.


PROCEDURE FSvaki1()
RETURN


FUNCTION TekRec()
 nSlog++
 @ m_x+1, m_y+2 SAY PADC(ALLTRIM(STR(nSlog))+"/"+ALLTRIM(STR(nUkupno)),20)
 @ m_x+2, m_y+2 SAY "Obuhvaceno: "+STR(cmxKeysIncluded())
RETURN (NIL)


************************************************************************
// OPCINA - pregled cijene artikla po dobavljacima
************************************************************************
PROCEDURE CArDob()

O_ROBA
O_SIFV
O_SIFK
O_PARTN
O_SUBAN

qqIDVN:=space(30)
qqRoba:=""
dDatOd:=ctod(""); dDatDo:=date(); gOstr:="D"; gTabela:=1

O_PARAMS
private cSection:="6",cHistory:=" "; aHistory:={}
Params1()
RPar("d1",@dDatOd); RPar("d2",@dDatDo)
RPar("F7",@qqIDVN)
RPar("c5",@qqRoba)

qqIDVN:=PADR(qqIDVN,30)

Box(, 7,70)
do while .t.
 qqRoba:=padr(qqRoba,10)
 @ m_x+ 1,m_y+2   SAY "Sifra artikla  " GET qqRoba    pict "@!" valid P_Roba(@qqRoba)
 @ m_X+ 3,m_Y+2 SAY "Za period od" GET dDatOD
 @ m_X+ 3,col()+2 SAY "do" GET dDatDo
 @ m_X+ 5, m_y+2 SAY "Uslov za vrstu naloga" GET qqIDVN PICT "@!"
 @ m_X+ 7, m_y+2 SAY "Ukljuceno ostranicavanje ? (D/N)" GET gOstr VALID gOstr$"DN" PICT "@!"
 @ m_X+ 7,m_y+38 SAY "Tip tabele (0/1/2)" GET gTabela VALID gTabela<3.and.gTabela>=0 PICT "9"
 read; ESC_BCR
 aUsl7:=Parsiraj(qqIDVN,"IDVN")
 if aUsl7<>NIL
   exit
 endif
enddo
BoxC()

Params2()
qqIDVN:=trim(qqIDVN)

WPar("d1",dDatOd) ; WPar("d2",dDatDo)
WPar("F7",qqIDVN)
WPar("c5",qqRoba)

select params; use

SELECT SUBAN

Box(,2,30)
  nSlog:=0; nUkupno:=RECCOUNT2()
  cSort1 := "DESCEND(DTOS(DATDOK))+IDPARTNER"
  cFilt  := "DATDOK>=dDatOd .and. DATDOK<=dDatDo .and. Tacno(aUsl7) .and. IDROBA==qqRoba .and. U_I=='1'"
  INDEX ON &cSort1 TO "TMPMAT" FOR &cFilt EVAL(TekRec()) EVERY 1
BoxC()

GO TOP
if eof(); Msg("Ne postoje trazeni podaci...",6); closeret; endif

START PRINT CRET

PRIVATE cIdPartner:="", cNPartnera:="", aDobav:={}

aKol:={ { "SIFRA"       , {|| cIdPartner         }, .f., "C", 6, 0, 1, 1},;
        { "DOBAVLJAC"   , {|| cNPartnera         }, .f., "C",50, 0, 1, 2},;
        { "DATUM"       , {|| DATDOK             }, .f., "D", 8, 0, 1, 3},;
        { "CIJENA"      , {|| IF(kolicina==0,IZNOS,IZNOS/KOLICINA)     }, .f., "N",12, 2, 1, 4} }

P_10CPI
?? gnFirma
?
? "DATUM:",SrediDat(DATE())
? "USLOV ZA VRSTU NALOGA:"+IF(EMPTY(qqIDVN),"SVI NALOZI",TRIM(qqIDVN))

StampaTabele(aKol,{|| FSvaki1()},,gTabela,,;
     ,"Pregled cijena za "+qqRoba+"-"+TRIM(ROBA->naz)+" za period od "+DTOC(ddatod)+" do "+DTOC(ddatdo),;
                             {|| FFor2()},IF(gOstr=="D",,-1),,,,,,.f.)

END PRINT

CLOSERET


FUNCTION FFor2()
 LOCAL lVrati:=.f.
  cIdPartner:=idpartner
  IF ASCAN(aDobav,cIdpartner)==0
    lVrati:=.t.
    AADD(aDobav,cIdPartner)
    cNPartnera:=Ocitaj(F_PARTN,idpartner,"TRIM(naz)+' '+TRIM(naz2)")
  ENDIF
RETURN lVrati


FUNCTION SrediKonta()
  LOCAL aProm := { { "2101"   , "1010" },;
                   { "210101" , "DEL"  },;
                   { "2102"   , "1011" },;
                   { "210201" , "DEL"  },;
                   { "2103"   , "1012" },;
                   { "2104"   , "1013" },;
                   { "2105"   , "DEL"  },;
                   { "2106"   , "DEL"  },;
                   { "210601" , "DEL"  },;
                   { "2107"   , "DEL"  },;
                   { "2109"   , "DEL"  },;
                   { "2200"   , "1020" },;
                   { "2201"   , "DEL"  },;
                   { "2202"   , "1022" },;
                   { "220201" , "DEL"  },;
                   { "2203"   , "1023" },;
                   { "220301" , "DEL"  },;
                   { "2204"   , "DEL"  },;
                   { "2205"   , "1025" },;
                   { "220501" , "DEL"  },;
                   { "2206"   , "DEL"  },;
                   { "2207"   , "DEL"  },;
                   { "2300"   , "1030" },;
                   { "2303"   , "DEL"  },;
                   { "5602"   , "1310" },;
                   { "560201" , "DEL"  },;
                   { "5604"   , "1312" },;
                   { "560401" , "DEL"  },;
                   { "5605"   , "DEL"  },;
                   { "5606"   , "1314" },;
                   { "560601" , "DEL"  },;
                   { "5607"   , "DEL"  },;
                   { "560701" , "DEL"  } }
  O_ROBA
  O_SIFV
  O_SIFK
  O_SINT
  O_ANAL
  O_SUBAN
  SELECT (F_ROBA)
  GO TOP
  DO WHILE !EOF()
    SKIP 1; nRec:=RECNO(); SKIP -1
    nPom:=ASCAN(aProm,{|x| PADR(x[1],7)==IDKONTO})
    IF nPom>0  // zna�i predvi�ena je promjena
      IF aProm[nPom,2]=="DEL"     // brisanje
        DELETE
      ELSE                        // promjena
        Scatter()
        _idkonto:=aProm[nPom,2]
        Gather()
      ENDIF
    ENDIF
    GO (nRec)
  ENDDO
  SELECT (F_SINT)
  GO TOP
  DO WHILE !EOF()
    SKIP 1; nRec:=RECNO(); SKIP -1
    nPom:=ASCAN(aProm,{|x| PADR(x[1],3)==IDKONTO.and.x[2]!="DEL"})
    IF nPom>0  // zna�i predvi�ena je promjena          �
                                                     // �����������������Ŀ
      IF aProm[nPom,2]=="DEL"     // brisanje:ne�e se nikad pojaviti zbog��
        DELETE
      ELSE                        // promjena
        Scatter()
        _idkonto:=aProm[nPom,2]
        Gather()
      ENDIF
    ENDIF
    GO (nRec)
  ENDDO
  SELECT (F_ANAL)
  GO TOP
  DO WHILE !EOF()
    SKIP 1; nRec:=RECNO(); SKIP -1
    nPom:=ASCAN(aProm,{|x| PADR(x[1],7)==IDKONTO.and.x[2]!="DEL"})
    IF nPom>0  // zna�i predvi�ena je promjena          �
                                                     // �����������������Ŀ
      IF aProm[nPom,2]=="DEL"     // brisanje:ne�e se nikad pojaviti zbog��
        DELETE
      ELSE                        // promjena
        Scatter()
        _idkonto:=aProm[nPom,2]
        Gather()
      ENDIF
    ENDIF
    GO (nRec)
  ENDDO
  SELECT (F_SUBAN)
  GO TOP
  DO WHILE !EOF()
    SKIP 1; nRec:=RECNO(); SKIP -1
    nPom:=ASCAN(aProm,{|x| PADR(x[1],7)==IDKONTO.and.x[2]!="DEL"})
    IF nPom>0  // zna�i predvi�ena je promjena          �
                                                     // �����������������Ŀ
      IF aProm[nPom,2]=="DEL"     // brisanje:ne�e se nikad pojaviti zbog��
        DELETE
      ELSE                        // promjena
        Scatter()
        _idkonto:=aProm[nPom,2]
        Gather()
      ENDIF
    ENDIF
    GO (nRec)
  ENDDO
CLOSERET

#ifdef CAX
 function truename(cc)  // sklonjena iz CTP
 return cc
#else
 #ifdef EXT
   function truename(cc)  // sklonjena iz CTP
   return cc
 #endif
#endif



