#include "rwmake.ch"
#include "topconn.ch"

User Function LJ7026() 
Local cQry  := ""   
Private _cArea := GetArea()

cQry := "SELECT * "
cQry += "FROM " + RETSQLNAME("SE1") + " "
IF SUPERGETMV("MV_LJNCCFI", .F., .F.) // VERIFICA SE ESTÁ HABILITADO COMPARTILHAMENTO DE NCC ENTRE FILIAIS.
cQry += "WHERE SUBSTRING(E1_FILIAL,1,2) = '"+xFilial('SA1')+"' AND "
ELSE
cQry += "WHERE E1_FILIAL = '"+  xFilial('SE1') + "' AND "
ENDIF
cQry += "(E1_TIPO = 'RA ' OR E1_TIPO = 'NCC') AND "
cQry += "E1_CLIENTE = '" + M->LQ_CLIENTE + "' AND "
cQry += "E1_LOJA = '" + M->LQ_LOJA + "' AND "
cQry += "E1_SALDO > 0 AND " 
cQry += "D_E_L_E_T_ = '' "
cQry += "ORDER BY E1_NUM, E1_EMISSAO"

TCQUERY cQry NEW ALIAS "QRY"

DbSelectArea("QRY")

While (QRY->(EOF()) == .F.)
    
    aAdd(aNCCItens,{.F.,;
                    QRY->E1_SALDO,;
                    QRY->E1_NUM,;
                    STOD(QRY->E1_EMISSAO),;
                    QRY->R_E_C_N_O_,;
                    QRY->E1_SALDO,;
                    SUPERGETMV("MV_MOEDA1"),;
                    QRY->E1_MOEDA,;
                    QRY->E1_PREFIXO,;
                    QRY->E1_PARCELA,;
                    QRY->E1_TIPO,;
                    QRY->E1_FILIAL})

    QRY->(DbSkip())
End  

QRY->(DbCloseArea())
RestArea(_cArea)
    
Return
