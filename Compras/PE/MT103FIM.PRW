User Function MT103FIM() 
    Local nOpcao := PARAMIXB[1]   // op��o Escolhida pelo usuario no aRotina 
    Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a opera��o de grava��o da NFECODIGO DE APLICAÇÃO DO USUARIO
 
    IF SF1->F1_TIPO=="D" .and. nopcao=3 .and. nconfirma=1
        IF funname(0) != "COMXCOL"
            //U_IMPNCC()
            U_RROrcNCC()
          //  U_RROrcNCC()
        ENDIF

    ENDIF
 

Return (NIL)
