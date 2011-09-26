#include "mat.ch"

function kzb()


local   picBHD:='999999999999.99'
local   picDEM:='999999999.99'

O_NALOG
O_SUBAN
O_ANAL
O_SINT

Box("KZB",10,77,.f.)
set cursor off
@ m_x+1,m_y+2 say "* NAZIV      * DUGUJE "+ValPomocna()+"* POTRA@."+ValPomocna()+"* DUGUJE "+ValDomaca()+"   * POTRA@UJE "+ValDomaca()+"*"



select NALOG

go top
nDug:=nPot:=nDug2:=nPot2:=0
DO WHILE !EOF() .and. INKEY()!=27
   nDug+=Dug;   nPot+=Pot
   nDug2+=Dug2;   nPot2+=Pot2
   SKIP
ENDDO
ESC_BCR
@ m_x+3,m_y+2 SAY "      NALOZI"
@ row(),col()+1 SAY nDug PICTURE picDEM
@ row(),col()+1 SAY nPot PICTURE picDEM
@ row(),col()+1 SAY nDug2 PICTURE picBHD
@ row(),col()+1 SAY nPot2 PICTURE picBHD

select SINT
nDug:=nPot:=nDug2:=nPot2:=0
go top
DO WHILE !EOF() .and. INKEY()!=27
   nDug+=Dug; nPot+=Pot
   nDug2+=Dug2; nPot2+=Pot2
   SKIP
ENDDO
ESC_BCR
@ m_x+5,m_y+2 SAY "   SINTETIKA"
@ row(),col()+1 SAY nDug PICTURE picDEM
@ row(),col()+1 SAY nPot PICTURE picDEM
@ row(),col()+1 SAY nDug2 PICTURE picBHD
@ row(),col()+1 SAY nPot2 PICTURE picBHD


select ANAL
nDug:=nPot:=nDug2:=nPot2:=0
go top
DO WHILE !EOF() .and. INKEY()!=27
   nDug+=Dug; nPot+=Pot
   nDug2+=Dug2; nPot2+=Pot2
   SKIP
ENDDO
ESC_BCR
@ m_x+7,m_y+2 SAY "   ANALITIKA"
@ row(),col()+1 SAY nDug PICTURE picDEM
@ row(),col()+1 SAY nPot PICTURE picDEM
@ row(),col()+1 SAY nDug2 PICTURE picBHD
@ row(),col()+1 SAY nPot2 PICTURE picBHD

select SUBAN
nDug:=nPot:=nDug2:=nPot2:=0
go top
DO WHILE !EOF() .and. INKEY()!=27
  if D_P=="1"
   nDug+=Iznos; nDug2+=Iznos2
  else
   nPot+=Iznos; nPot2+=Iznos2
  endif
  SKIP
ENDDO
ESC_BCR
@ m_x+9,m_y+2 SAY "SUBANALITIKA"
@ row(),col()+1 SAY nDug PICTURE picDEM
@ row(),col()+1 SAY nPot PICTURE picDEM
@ row(),col()+1 SAY nDug2 PICTURE picBHD
@ row(),col()+1 SAY nPot2 PICTURE picBHD

Inkey(0)
BoxC()
closeret
