#include "mat.ch"


function TMatModNew()
local oObj

oObj:=TMatMod():new()

oObj:self:=oObj
return oObj


#include "class(y).ch"
CREATE CLASS TMatMod INHERIT TAppMod
	EXPORTED: 
	var oSqlLog
	method setGVars
	method mMenu
	method mMenuStandard
	method sRegg
	method initdb
	method srv
END CLASS


*void TMatMod::initdb()
method initdb()
::oDatabase:=TDBMatNew()
return NIL



/*! \fn *void TMatMod::mMenu()
 *  \brief Osnovni meni MAT modula
 *  \todo meni prebaciti na Menu_SC!
 */

*void TMatMod::mMenu()
*{
method mMenu()

PID("START")

close all

SETKEY(K_SH_F1,{|| Calc()})

CheckROnly(KUMPATH + "\SUBAN.DBF")

O_SUBAN
select suban
TrebaRegistrovati(3)
use

close all

@ 1,2 SAY padc( gNFirma, 50, "*")
@ 4,5 SAY ""

::mMenuStandard()

::quit()

return nil



/*! \fn *void TMatMod::mStandardMenu()
 *  \brief Osnovni meni MAT modula
 *  \todo meni prebaciti na Menu_SC!
 */

*void TePDVMod::mMenuStandard()
*{
method mMenuStandard()

private Izbor:=1
private opc:={}
private opcexe:={}

say_fmk_ver()

AADD(opc, "1. unos/ispravka dokumenata               ")

if (ImaPravoPristupa(goModul:oDataBase:cName,"DOK","EDIT"))
	AADD(opcexe, {|| knjiz()})
else
	AADD(opcexe, {|| MsgBeep(cZabrana)})
endif

AADD(opc, "2. izvjestaji")
if (ImaPravoPristupa(goModul:oDataBase:cName,"RPT","MNU"))
	AADD(opcexe, {|| izvjesta()})
else
	AADD(opcexe, {|| MsgBeep(cZabrana)})
endif


AADD(opc, "3. kontrola zbira datoteka")
if (ImaPravoPristupa(goModul:oDataBase:cName,"DOK","KZB"))
	AADD(opcexe, {|| kzb()})
else
	AADD(opcexe, {|| MsgBeep(cZabrana)})
endif

AADD(opc, "4. stampa datoteke naloga")
AADD(opcexe, {|| stdatn()})

AADD(opc, "5. stampa proknjizenih naloga")
AADD(opcexe, {|| stonal()})

AADD(opc, "6. inventura")
AADD(opcexe, {|| invent()})

AADD(opc, "F. prenos fakt->mat")
AADD(opcexe, {|| fakmat()})

AADD(opc, "G. generacija dokumenta pocetnog stanja")
AADD(opcexe, {|| prenosmat()})


AADD(opc, "------------------------------------")
AADD(opcexe, {|| nil})

AADD(opc, "S. sifrarnici")
AADD(opcexe, {|| m_sif()})

AADD(opc, "------------------------------------")
AADD(opcexe, {|| nil})

AADD(opc, "P. povrat naloga u pripremu")
if (ImaPravoPristupa(goModul:oDataBase:cName, "DB", "POVRAT"))
	AADD(opcexe, {|| povrat()})
else
	AADD(opcexe, {|| MsgBeep(cZabrana)})
endif


AADD(opc, "9. administracija baze podataka")
if (ImaPravoPristupa(goModul:oDataBase:cName, "DB", "ADMIN"))
	AADD(opcexe, {|| m_adm()})
else
	AADD(opcexe, {|| MsgBeep(cZabrana)})
endif

AADD(opc, "------------------------------------")
AADD(opcexe, {|| nil})


AADD(opc, "X. parametri")

if (ImaPravoPristupa(goModul:oDataBase:cName,"PARAM","ALL"))
	AADD(opcexe, {|| m_params()})
else
	AADD(opcexe, {|| MsgBeep(cZabrana)})
endif

Menu_SC("gmat",.t., .f.)

return
*}


*void TFinMod::sRegg()
*{
method sRegg()
sreg("MAT","MAT")
return
*}


*void TMatMod::srv()
*{
method srv()
return
*}


/*! \fn *void TMatMod::setGVars()
 *  \brief opste funkcije Mat modula
 */

*void TMatMod::setGVars()
*{

method setGVars()

SetFmkSGVars()
SetFmkRGVars()

private cSection:="1"
private cHistory:=" "
private aHistory:={}

public gDirPor:=""
public gFirma:="10"
public gNalPr:="41#42"
public gCijena:=" "
public gKonto:="N"
public KursLis:="1"
public gpicdem:="9999999.99"
public gpicdin:="999999999999"
public gPicKol:="999999.999"
public gBaznaV:="P"
public g2Valute:="D"
public gPotpis:="N"

O_PARAMS
private cSection:="1",cHistory:=" "; aHistory:={}

public gNFirma:=space(20)  // naziv firme
public gDatNal:="N"
public gKupZad:="N"
public gNW:="D"  // new vawe
public gSekS:="N"

RPar("dp",@gDirPor)
RPar("fi",@gFirma)
Rpar("Bv",@gBaznaV)
Rpar("2v",@g2Valute)
RPar("np",@gNalPr)
RPar("ci",@gCijena)
RPar("pe",@gpicdem)
RPar("pd",@gpicdin)
RPar("pk",@gpickol)
Rpar("fn",@gNFirma)
Rpar("dn",@gDatNal)
Rpar("nw",@gNW)
Rpar("ss",@gSekS)
RPar("kd",@gKupZad)
RPar("ko",@gKonto)


if empty(gNFirma)
  Box(,1,50)
    Beep(1)
    @ m_x+1,m_y+2 SAY "Unesi naziv firme:" GET gNFirma pict "@!"
    read
  BoxC()
  WPar("fn",gNFirma)
endif

if empty(gDirPor)
  gDirPor:=strtran(cDirPriv,"MAT","KALK")+"\"
  WPar("dp",gDirPor)
endif

select params
use

::super:setTGVars()

public gModul
public gTema
public gGlBaza

gModul:="MAT"
gTema:="OSN_MENI"
gGlBaza:="SUBAN.DBF"

public cZabrana:="Opcija nedostupna za ovaj nivo !!!"

return



