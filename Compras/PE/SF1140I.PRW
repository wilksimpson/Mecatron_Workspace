USER FUNCTION SF1140I ()
Local params1 := PARAMIXB[1]
//Local params1 := PARAMIXB[2]
Local _cArea := GetArea()

    IF params1
    RECLOCK("SF1",.F.)
    SF1->F1_USEPREN := RetCodUsr()
    IF EMPTY(SF1->F1_NOMFOR)
        SF1->F1_NOMFOR := POSICIONE("SA2",1,XFILIAL("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_NOME")
    ENDIF
	MsUnlock()
    ENDIF

Restarea(_cArea)
Return
