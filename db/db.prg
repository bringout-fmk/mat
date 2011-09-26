#include "mat.ch"

 
function TDBMatNew()
local oObj

oObj:=TDBMat():new()
oObj:self:=oObj
oObj:cName:="MAT"
oObj:lAdmin:=.f.
return oObj



#include "class(y).ch"
CREATE CLASS TDBMat INHERIT TDB 
	EXPORTED:
	var self
	method skloniSezonu	
	method install	
	method setgaDBFs	
	method ostalef	
	method obaza	
	method kreiraj	
	method konvZn
	method scan

END CLASS


/*! \fn *void TDBMat::skloniSez(string cSezona, bool finverse, bool fda, bool lNulirati, bool fRS)
 *  \brief formiraj sezonsku bazu podataka
 */
 
method skloniSezonu(cSezona, finverse, fda, lNulirati, fRS)
local cScr

save screen to cScr

if fda==nil
  fDA:=.f.
endif
if finverse==nil
  finverse:=.f.
endif
if lNulirati==nil
  lNulirati:=.f.
endif
if fRS==nil
  // mrezna radna stanica , sezona je otvorena
  fRS:=.f.
endif

if fRS // radna stanica
  if file(ToUnix(PRIVPATH+cSezona+"\PRIPR.DBF"))
      // nema se sta raditi ......., pripr.dbf u sezoni postoji !
      return
  endif
  aFilesK:={}
  aFilesS:={}
  aFilesP:={}
endif

if KLevel<>"0"
	MsgBeep("Nemate pravo na koristenje ove opcije")
endif

cls

if fRS
	// mrezna radna stanica
	? "Formiranje DBF-ova u privatnom direktoriju, RS ...."
endif
?
if finverse
 	? "Prenos iz  sezonskih direktorija u radne podatke"
else
	? "Prenos radnih podataka u sezonske direktorije"
endif
?
// privatni
fnul:=.f.
Skloni(PRIVPATH,"PARAMS.DBF",cSezona,finverse,fda,fnul)
Skloni(PRIVPATH,"PRIPR.DBF",cSezona,finverse,fda,fnul)
Skloni(PRIVPATH,"INVENT.DBF",cSezona,finverse,fda,fnul)
Skloni(PRIVPATH,"FMK.INI",cSezona,finverse,fda,fnul)

if fRS
 // mrezna radna stanica!!! , baci samo privatne direktorije
 ?
 ?
 ?
 Beep(4)
 ? "pritisni nesto za nastavak.."

 restore screen from cScr
 return
endif

if lNulirati
	fnul:=.t.
else
	fnul:=.f.
endif  

// kumulativ
Skloni(KUMPATH,"SUBAN.DBF",cSezona,finverse,fda,fnul)
Skloni(KUMPATH,"ANAL.DBF",cSezona,finverse,fda,fnul)
Skloni(KUMPATH,"SINT.DBF",cSezona,finverse,fda,fnul)
Skloni(KUMPATH,"NALOG.DBF",cSezona,finverse,fda,fnul)
Skloni(KUMPATH,"FMK.INI",cSezona,finverse,fda,fnul)

// sifrarnici
fnul:=.f.
Skloni(SIFPATH,"KONTO.DBF", cSezona,finverse,fda,fnul)
Skloni(SIFPATH,"PARTN.DBF", cSezona,finverse,fda,fnul)
Skloni(SIFPATH,"VALUTE.DBF",cSezona,finverse,fda,fnul)
Skloni(SIFPATH,"TARIFA.DBF",cSezona,finverse,fda,fnul)
Skloni(SIFPATH,"TNAL.DBF",  cSezona,finverse,fda,fnul)
Skloni(SIFPATH,"TDOK.DBF",  cSezona,finverse,fda,fnul)
Skloni(SIFPATH,"ROBA.DBF",  cSezona,finverse,fda,fnul)
Skloni(SIFPATH,"ROBA.DBT",  cSezona,finverse,fda,fnul)
Skloni(SIFPATH,"KARKON.DBF",cSezona,finverse,fda,fnul)
Skloni(SIFPATH,"FMK.INI",cSezona,finverse,fda,fnul)

?
?
?

Beep(4)

? "pritisni nesto za nastavak.."

restore screen from cScr
return



/*! \fn *void TDBMat::setgaDBFs()
 *  \brief Setuje matricu gaDBFs 
 */
*void TDBMat::setgaDBFs()
*{
method setgaDBFs()
PUBLIC gaDBFs:={}

AADD(gaDBFs, { F_PARAMS, "PARAMS", P_PRIVPATH  } )
AADD(gaDBFs, { F_PRIPR, "PRIPR", P_PRIVPATH  } )
AADD(gaDBFs, { F_INVENT, "INVENT", P_PRIVPATH  } )
AADD(gaDBFs, { F_PSUBAN, "PSUBAN", P_PRIVPATH  } )
AADD(gaDBFs, { F_PSINT, "PSINT", P_PRIVPATH  } )
AADD(gaDBFs, { F_PANAL, "PANAL", P_PRIVPATH  } )
AADD(gaDBFs, { F_PNALOG, "PNALOG", P_PRIVPATH  } )

AADD(gaDBFs, { F_SUBAN, "SUBAN", P_KUMPATH  } )
AADD(gaDBFs, { F_ANAL, "ANAL", P_KUMPATH  } )
AADD(gaDBFs, { F_SINT, "SINT", P_KUMPATH  } )
AADD(gaDBFs, { F_NALOG, "NALOG", P_KUMPATH  } )

AADD(gaDBFs, { F_KONTO, "KONTO", P_SIFPATH } )
AADD(gaDBFs, { F_PARTN, "PARTN", P_SIFPATH } )
AADD(gaDBFs, { F_VALUTE, "VALUTE", P_SIFPATH } )
AADD(gaDBFs, { F_TARIFA, "TARIFA", P_SIFPATH } )
AADD(gaDBFs, { F_TNAL, "TNAL", P_SIFPATH } )
AADD(gaDBFs, { F_TDOK, "TDOK", P_SIFPATH } )
AADD(gaDBFs, { F_ROBA, "ROBA", P_SIFPATH } )
AADD(gaDBFs, { F_KARKON, "KARKON", P_SIFPATH } )

return


*void TDBMat::install(string cKorisn,string cSifra,variant p3,variant p4,variant p5,variant p6,variant p7)
*{
method install()
ISC_START(goModul,.f.)
return
*}

/*! *void TDBMat::kreiraj(int nArea)
 *  \brief kreirane baze podataka EPDV
 */
 
*void TDBMat::kreiraj(int nArea)
*{
method kreiraj(nArea)
local cImeDbf


if (nArea==nil)
	nArea:=-1
endif

Beep(1)

if (nArea<>-1)
	CreSystemDb(nArea)
endif

CreFmkSvi()
CreRoba()
CreFmkPi()

aDbf:={}
AADD(aDBf,{ 'IDFIRMA'             , 'C' ,   2 ,  0 })
AADD(aDBf,{ 'IDVN'                , 'C' ,   2 ,  0 })
AADD(aDBf,{ 'BRNAL'               , 'C' ,   4 ,  0 })
AADD(aDBf,{ 'DATNAL'              , 'D' ,   8 ,  0 })
AADD(aDBf,{ 'DUG'                 , 'N' ,  15 ,  2 })
AADD(aDBf,{ 'POT'                 , 'N' ,  15 ,  2 })
AADD(aDBf,{ 'DUG2'                , 'N' ,  15 ,  2 })
AADD(aDBf,{ 'POT2'                , 'N' ,  15 ,  2 })
if !file('NALOG.DBF')
        DBCREATE2('NALOG.DBF',aDbf)
endif
if !file(PRIVPATH+'PNALOG.DBF')
        DBCREATE2(PRIVPATH+'PNALOG.DBF',aDbf)
endif
CREATE_INDEX("1","IdFirma+IdVn+BrNal",KUMPATH+"NALOG") // Nalozi
CREATE_INDEX("1","IdFirma",PRIVPATH+"PNALOG") // Nalozi

aDbf:={}
AADD(aDBf,{ 'IDFIRMA'             , 'C' ,   2 ,  0 })
AADD(aDBf,{ 'IDROBA'              , 'C' ,  10 ,  0 })
AADD(aDBf,{ 'IDKONTO'             , 'C' ,   7 ,  0 })
AADD(aDBf,{ 'IDVN'                , 'C' ,   2 ,  0 })
AADD(aDBf,{ 'BRNAL'               , 'C' ,   4 ,  0 })
AADD(aDBf,{ 'RBR'                 , 'C' ,   4 ,  0 })
AADD(aDBf,{ 'IDTIPDOK'            , 'C' ,   2 ,  0 })
AADD(aDBf,{ 'BRDOK'               , 'C' ,   8 ,  0 })
AADD(aDBf,{ 'DATDOK'              , 'D' ,   8 ,  0 })
AADD(aDBf,{ 'U_I'                 , 'C' ,   1 ,  0 })
AADD(aDBf,{ 'KOLICINA'            , 'N' ,  10 ,  3 })
AADD(aDBf,{ 'D_P'                 , 'C' ,   1 ,  0 })
AADD(aDBf,{ 'IZNOS'               , 'N' ,  15 ,  2 })
AADD(aDBf,{ 'IDPartner'            , 'C' ,   6 ,  0 })
AADD(aDBf,{ 'IDZaduz'              , 'C' ,   6 ,  0 })
AADD(aDBf,{ 'IZNOS2'              , 'N' ,  15 ,  2 })
AADD(aDBf,{ 'DatKurs'             , 'D' ,   8 ,  0 })
AADD(aDBf,{ 'K1'                  , 'C' ,   1 ,  0 })
AADD(aDBf,{ 'K2'                  , 'C' ,   1 ,  0 })
AADD(aDBf,{ 'K3'                  , 'C' ,   2 ,  0 })
AADD(aDBf,{ 'K4'                  , 'C' ,   2 ,  0 })
if !file('SUBAN.DBF')
        DBCREATE2('SUBAN.DBF',aDbf)
endif
if !file(PRIVPATH+'PSUBAN.DBF')
        DBCREATE2(PRIVPATH+'PSUBAN.DBF',aDbf)
endif
CREATE_INDEX("1","IdFirma+IdRoba+dtos(DatDok)"        , KUMPATH+"SUBAN")
CREATE_INDEX("2","IdFirma+IdPartner+IdRoba"           , KUMPATH+"SUBAN")
CREATE_INDEX("3","IdFirma+IdKonto+IdRoba+dtos(DatDok)", KUMPATH+"SUBAN")
CREATE_INDEX("4","idFirma+IdVN+BrNal+rbr"             , KUMPATH+"SUBAN")
CREATE_INDEX("5","IdFirma+IdKonto+IdPartner+IdRoba+dtos(DatDok)", ;
	KUMPATH+"SUBAN")
CREATE_INDEX("1","idFirma+idvn+brnal"        , PRIVPATH+"PSUBAN")
CREATE_INDEX("2","idFirma+IdVN+Brnal+IdKonto", PRIVPATH+"PSUBAN")

aDbf:={}
AADD(aDBf,{ 'IDFIRMA'             , 'C' ,   2 ,  0 })
AADD(aDBf,{ 'IDKONTO'             , 'C' ,   7 ,  0 })
AADD(aDBf,{ 'IDVN'                , 'C' ,   2 ,  0 })
AADD(aDBf,{ 'BRNAL'               , 'C' ,   4 ,  0 })
AADD(aDBf,{ 'DATNAL'              , 'D' ,   8 ,  0 })
AADD(aDBf,{ 'RBR'                 , 'C' ,   3 ,  0 })
AADD(aDBf,{ 'DUG'                 , 'N' ,  15 ,  2 })
AADD(aDBf,{ 'POT'                 , 'N' ,  15 ,  2 })
AADD(aDBf,{ 'DUG2'                , 'N' ,  15 ,  2 })
AADD(aDBf,{ 'POT2'                , 'N' ,  15 ,  2 })
if !file('ANAL.DBF')
        DBCREATE2('ANAL.DBF',aDbf)
endif
if !file(PRIVPATH+'PANAL.DBF')
        DBCREATE2(PRIVPATH+'PANAL.DBF',aDbf)
endif
CREATE_INDEX("1","IdFirma+IdKonto+dtos(DatNal)",KUMPATH+"ANAL")  //analiti
CREATE_INDEX("2","idFirma+IdVN+BrNal+IdKonto",KUMPATH+"ANAL")
CREATE_INDEX("1","IdFirma+idvn+brnal+idkonto",PRIVPATH+"PANAL")

aDbf:={}
AADD(aDBf,{ 'IDFIRMA'             , 'C' ,   2 ,  0 })
AADD(aDBf,{ 'IDKONTO'             , 'C' ,   3 ,  0 })
AADD(aDBf,{ 'IDVN'                , 'C' ,   2 ,  0 })
AADD(aDBf,{ 'BRNAL'               , 'C' ,   4 ,  0 })
AADD(aDBf,{ 'DATNAL'              , 'D' ,   8 ,  0 })
AADD(aDBf,{ 'RBR'                 , 'C' ,   3 ,  0 })
AADD(aDBf,{ 'DUG'                 , 'N' ,  15 ,  2 })
AADD(aDBf,{ 'POT'                 , 'N' ,  15 ,  2 })
AADD(aDBf,{ 'DUG2'                , 'N' ,  15 ,  2 })
AADD(aDBf,{ 'POT2'                , 'N' ,  15 ,  2 })
if !file('SINT.DBF')
        DBCREATE2('SINT.DBF',aDbf)
endif
if !file(PRIVPATH+'PSINT.dbf')
        DBCREATE2(PRIVPATH+'PSINT.DBF',aDbf)
endif

CREATE_INDEX("1","IdFirma+IdKonto+dtos(DatNal)",KUMPATH+"SINT")  // sinteti
CREATE_INDEX("2","idFirma+IdVN+BrNal+IdKonto",KUMPATH+"SINT")
CREATE_INDEX("1","IdFirma",PRIVPATH+"PSINT")

if !file(PRIVPATH+'PRIPR.dbf')
        aDbf:={}
        AADD(aDBf,{ 'IDFIRMA'             , 'C' ,   2 ,  0 })
        AADD(aDBf,{ 'IDROBA'              , 'C' ,  10 ,  0 })
        AADD(aDBf,{ 'IDKONTO'             , 'C' ,   7 ,  0 })
        AADD(aDBf,{ 'IDVN'                , 'C' ,   2 ,  0 })
        AADD(aDBf,{ 'BRNAL'               , 'C' ,   4 ,  0 })
        AADD(aDBf,{ 'RBR'                 , 'C' ,   4 ,  0 })
        AADD(aDBf,{ 'IDTIPDOK'            , 'C' ,   2 ,  0 })
        AADD(aDBf,{ 'BRDOK'               , 'C' ,   8 ,  0 })
        AADD(aDBf,{ 'DATDOK'              , 'D' ,   8 ,  0 })
        AADD(aDBf,{ 'U_I'                 , 'C' ,   1 ,  0 })
        AADD(aDBf,{ 'KOLICINA'            , 'N' ,  10 ,  3 })
        AADD(aDBf,{ 'D_P'                 , 'C' ,   1 ,  0 })
        AADD(aDBf,{ 'IZNOS'               , 'N' ,  15 ,  2 })
        AADD(aDBf,{ 'CIJENA'              , 'N' ,  15 ,  3 })
        AADD(aDBf,{ 'IDPartner'           , 'C' ,   6 ,  0 })
        AADD(aDBf,{ 'IDZaduz'             , 'C' ,   6 ,  0 })
        AADD(aDBf,{ 'IZNOS2'              , 'N' ,  15 ,  2 })
        AADD(aDBf,{ 'DATKURS'             , 'D' ,   8 ,  0 })
        AADD(aDBf,{ 'K1'                  , 'C' ,   1 ,  0 })
        AADD(aDBf,{ 'K2'                  , 'C' ,   1 ,  0 })
        AADD(aDBf,{ 'K3'                  , 'C' ,   2 ,  0 })
        AADD(aDBf,{ 'K4'                  , 'C' ,   2 ,  0 })
        DBCREATE2(PRIVPATH+'PRIPR.DBF',aDbf)
endif
CREATE_INDEX("1","idFirma+IdVN+BrNal+rbr",PRIVPATH+"PRIPR")
CREATE_INDEX("2","idFirma+IdVN+BrNal+BrDok+Rbr",PRIVPATH+"PRIPR")
CREATE_INDEX("3","idFirma+IdVN+IdKonto",PRIVPATH+"PRIPR")

if !file(PRIVPATH+'INVENT.dbf')
        aDbf:={}
//        AADD(aDBf,{ 'IDFIRMA'             , 'C' ,   2 ,  0 })
        AADD(aDBf,{ 'IDROBA'              , 'C' ,  10 ,  0 })
        AADD(aDBf,{ 'RBR'                 , 'C' ,   4 ,  0 })
        AADD(aDBf,{ 'BROJXX'              , 'N' ,   8 ,  2 })
        AADD(aDBf,{ 'KOLICINA'            , 'N' ,  10 ,  2 })
        AADD(aDBf,{ 'CIJENA'              , 'N' ,  12 ,  2 })
        AADD(aDBf,{ 'IZNOS'               , 'N' ,  14 ,  2 })
        AADD(aDBf,{ 'IZNOS2'              , 'N' ,  14 ,  2 })
        DBCREATE2(PRIVPATH+'INVENT.DBF',aDbf)
endif
CREATE_INDEX("1","IdRoba",PRIVPATH+"INVENT") // Inventura


if !file(SIFPATH+'KARKON.dbf')
        aDbf:={}
        AADD(aDBf,{ 'ID'                  , 'C' ,  7  ,  0 })
        AADD(aDBf,{ 'TIP_NC'              , 'C' ,  1 ,   0 })
        AADD(aDBf,{ 'TIP_PC'              , 'C' ,  1 ,   0 })
        DBCREATE2(SIFPATH+'KARKON.DBF',aDbf)
endif
CREATE_INDEX("ID","ID",SIFPATH+"KARKON")


return




/*! \fn *void TDBMat::obaza(int i)
 *  \brief otvara odgovarajucu tabelu
 *  
 *  S obzirom da se koristi prvenstveno za instalacijske funkcije
 *  otvara tabele u exclusive rezimu
 */

*void TDBMat::obaza(int i)
*{
method obaza (i)
local lIdIDalje
local cDbfName

lIdiDalje:=.f.


if i==F_SUBAN .or. i==F_ANAL .or. i==F_SINT .or. i==F_NALOG 
	lIdiDalje:=.t.
endif

if i==F_PARAMS .or. i==F_PRIPR .or. i==F_INVENT
	lIdidalje:=.t.
endif

if i==F_PSUBAN .or. i==F_PANAL .or. i==F_PSINT .or. i==F_PNALOG
	lIdidalje:=.t.
endif

if i==F_KONTO .or. i==F_PARTN .or. i==F_ROBA .or. i==F_TDOK .or. i==F_TNAL
	lIdidalje:=.t.
endif

if i==F_VALUTE .or. i==F_TARIFA .or. i==F_KARKON 
	lIdidalje:=.t.
endif

if lIdiDalje
	cDbfName:=DBFName(i,.t.)
	if gAppSrv 
		? "OPEN: " + cDbfName + ".DBF"
		if !File(cDbfName + ".DBF")
			? "Fajl " + cDbfName + ".dbf ne postoji!!!"
			use
			return
		endif
	endif
	
	select(i)
	usex(cDbfName)
else
	use
	return
endif

return


/*! \fn *void TDBMat::ostalef()
 *  \brief Ostalef funkcije (bivsi install modul)
*/

*void TDBMat::ostalef()
method ostalef()

closeret
return



/*! \fn *void TDBePdv::konvZn()
 *  \brief Koverzija znakova
 *  \note sifra: KZ
 */
 
*void TDBePdv::konvZn()
*{
method konvZn()

LOCAL cIz:="7", cU:="8", aPriv:={}, aKum:={}, aSif:={}
LOCAL GetList:={}, cSif:="D", cKum:="D", cPriv:="D"
if !gAppSrv
	IF !SigmaSif("KZ      ")
   		RETURN
 	ENDIF
	Box(,8,50)
  	@ m_x+2, m_y+2 SAY "Trenutni standard (7/8)        " GET cIz   VALID   cIz$"78"  PICT "9"
  	@ m_x+3, m_y+2 SAY "Konvertovati u standard (7/8/A)" GET cU    VALID    cU$"78A" PICT "@!"
  	@ m_x+5, m_y+2 SAY "Konvertovati sifrarnike (D/N)  " GET cSif  VALID  cSif$"DN"  PICT "@!"
  	@ m_x+6, m_y+2 SAY "Konvertovati radne baze (D/N)  " GET cKum  VALID  cKum$"DN"  PICT "@!"
  	@ m_x+7, m_y+2 SAY "Konvertovati priv.baze  (D/N)  " GET cPriv VALID cPriv$"DN"  PICT "@!"
  	READ
  	IF LASTKEY()==K_ESC
		BoxC()
		RETURN
	ENDIF
  	IF Pitanje(,"Jeste li sigurni da zelite izvrsiti konverziju (D/N)","N")=="N"
    		BoxC()
		RETURN
  	ENDIF
 	BoxC()
else
	?
	cKonvertTo:=IzFmkIni("FMK","KonvertTo","78",EXEPATH)
	
	if cKonvertTo=="78"
		cIz:="7"
		cU:="8"
		? "Trenutni standard: " + cIz
		? "Konvertovati u: " + cU 
	elseif cKonvertTo=="87"
		cIz:="8"
		cU:="7"
		? "Trenutni standard: " + cIz
		? "Konvertovati u: " + cU 
	else // pitaj
		?
		@ 10, 2 SAY "Trenutni standard (7/8)        " GET cIz VALID cIz$"78" PICT "9"
		?
		@ 11, 2 SAY "Konvertovati u standard (7/8/A)" GET cU VALID cU$"78A" PICT "@!"
		read
	endif
	cSif:="D"
	cKum:="D"
	cPriv:="D"
endif
 
aKum  := { F_SUBAN, F_NALOG, F_SINT, F_ANAL }
aPriv := { F_PRIPR, F_INVENT }
aSif  := { F_ROBA, F_PARTN, F_KONTO }

 IF cSif  == "N"; aSif  := {}; ENDIF
 IF cKum  == "N"; aKum  := {}; ENDIF
 IF cPriv == "N"; aPriv := {}; ENDIF

KZNbaza(aPriv,aKum,aSif,cIz,cU)

return



/*! \fn *void TDbMat::scan()
 */
*void TDbMat::scan()
*{
method scan
return



