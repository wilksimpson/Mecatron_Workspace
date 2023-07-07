User Function MT103FIM() 
    Local nOpcao := PARAMIXB[1]   // opção Escolhida pelo usuario no aRotina 
    Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFECODIGO DE APLICAÃ‡ÃƒO DO USUARIO
 
    IF SF1->F1_TIPO=="D" .and. nopcao=3 .and. nconfirma=1
        IF funname(0) != "COMXCOL"
            //U_IMPNCC()
            U_RROrcNCC()
          //  U_RROrcNCC()
        ENDIF

    ENDIF
 

Return (NIL)
