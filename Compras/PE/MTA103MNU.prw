user function MTA103MNU()

//IF CNIVEL >= 7
    IF funname(0) != "COMXCOL"
        aAdd(aRotina,{OemToAnsi("Reimprime NCC"), "u_RROrcNCC()", 0 , 5, 0, nil})//"Rastr.Contrato"
    ENDIF
//ENDIF

return()

User Function RROrcNCC()
Local aDocDev	:= {}   	// Documento de Devolução
Local aRecSD2	:= {}    	// Recnos de D2
Local aDadosNCC := {}		// Dados de NCC
Local aRecSD1   := {}
AADD(aDocDev,SF1->F1_SERIE)
AADD(aDocDev,SF1->F1_DOC)
AADD(aDocDev,SF1->F1_FORNECE)
AADD(aDocDev,SF1->F1_LOJA)

U_ROrcNCC(aDocDev,aRecSD2,aDadosNCC,aRecSD1)


Return ()
