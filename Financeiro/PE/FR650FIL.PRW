User Function FR650FIL()
	Local lRet := .F.
	Local aValores := ParamIxb[01]

	// VERIFICA SE EST� RETORNANDO NO ARQUIVO O IDCNAB NA POSICAO 4
	DbSelectArea("SE1")
	dbSetOrder(16)
	IF dbSeek(xFilial("SE1")+Left(aValores[1],10))
		lRet := .T.
	ENDIF

	// SE AINDA N�O TIVER LOCALIZADO O T�TULO FAZ MAIS UMA BUSCA USANDO POSICAO UM DO A VALORES
	if lRet == .F.
		DbSelectArea("SE1")
		dbSetOrder(16)
		IF dbSeek(xFilial("SE1")+Left(aValores[4],10))
			CNUMTIT := Left(aValores[4],10)
			lRet := .T.
		ENDIF
	ENDIF
	//SE1->(dbSetOrder(16),dbSeek(xFilial("SE1")+Left(aValores[1],10)))

Return lRet
