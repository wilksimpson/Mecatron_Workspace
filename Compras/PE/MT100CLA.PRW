User Function MT100CLA()
	Local _cFil	:= SF1->F1_FILIAL
	Local _cDoc	:= SF1->F1_DOC
	Local _cSer	:= SF1->F1_SERIE
	Local _cFor	:= SF1->F1_FORNECE
	Local _cLoja:= SF1->F1_LOJA
	Local _cNaturez := POSICIONE("SA2",1,XFILIAL("SA2")+_cFor+_cLoja,"A2_NATUREZ")
	aAreaSF1 := SF1->(GetArea())
	aAreaSD1 := SD1->(GetArea())
// Autor: Wilk Lima 21/07/2020
// Objetivo: carregar natureza financeira fo fornecedor.
// Objetivo: carregar descrição do produto se vazio.

	// Grava codigo do usuario que está classificando o DOC
	RECLOCK("SF1",.F.)
	SF1->F1_USECLAS := RetCodUsr()
	MsUnlock()

	//Preenche a TES do produto X fornecedor na classificação do documento de entrada.
	DBSelectArea("SD1")
	DBSetOrder(1) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	IF DBSeek(_cFil+_cDoc+_cSer+_cFor+_cLoja)
		WHILE !EOF() .AND. _cFil==SD1->D1_FILIAL;
				.AND. _cDoc==SD1->D1_DOC .AND. _cSer==SD1->D1_SERIE;
				.AND. _cFor==SD1->D1_FORNECE .AND. _cLoja==SD1->D1_LOJA .AND. EMPTY(SD1->D1_TES)

			RecLock("SD1",.F.)
			//SD1->D1_TES= POSICIONE("SA5",2,XFILIAL("SA5")+SD1->D1_COD+_cFor+_cLoja,"A5_TE")
			//SD1->D1_TEC= POSICIONE("SB1",1,XFILIAL("SB1")+SD1->D1_COD,"B1_POSIPI")
			//SD1->D1_CLASFIS= SubStr(SD1->D1_CLASFIS,1,1)+POSICIONE("SF4",1,XFILIAL("SF4")+SD1->D1_TES,"F4_SITTRIB")
			IF EMPTY(SD1->D1_DESCRI)
				SD1->D1_DESCRI = POSICIONE("SB1",1,XFILIAL("SB1")+SD1->D1_COD,"B1_DESC")
			ENDIF
			MsUnLock()
			//MaFisRef("IT_TES","MT100",SD1->D1_TES)
			GetDRefresh()
			SD1->(DbSkip())
		ENDDO
	ENDIF

	IF !EMPTY(_cNaturez)
		CNATUREZA := _cNaturez
	ENDIF

	RestArea(aAreaSF1)
	RestArea(aAreaSD1)

Return .T.
