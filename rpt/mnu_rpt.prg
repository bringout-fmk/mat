#include "mat.ch"

function izvjesta()
private opc[7],Izbor

PRIVATE PicDEM:="99999999.99"
PRIVATE PicBHD:="999999999.99"
PRIVATE PicKol:="999999.999"

opc[1]:="1. kartica                                "
opc[2]:="2. specifikacija"
Opc[3]:="3. specifikacija sinteticki"
Opc[4]:="4. porez na realizaciju"
Opc[5]:=IF(gNW=="R","5. materijal po mjestima troska",;
                    "5. ----------------------------")
Opc[6]:="6. cijena artikla po dobavljacima"
Opc[7]:="7. specifikacija artikla po mjestu troska"
Izbor:=1
DO WHILE .T.
   Izbor:=Menu("pregl",opc,Izbor,.f.)
   do case
      case izbor == 0
         exit
      case izbor == 1
         Kartica()
      case izbor == 2
         Specif()
      case izbor == 3
         Specifs()
      case izbor == 4
         PorNar()
      case izbor == 5 .AND. gNW=="R"
         PoMjeTros()     // PREGLED PO MJESTIMA TROSKOVA (RADJENO ZA RUDNIK)
      case izbor == 6
         CArDob()
      case izbor == 7
         IArtPoPogonima()
   endcase
enddo
closeret
return

