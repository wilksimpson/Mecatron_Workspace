User Function FA200FIL()
	Local aValores := ParamIxb
	Local _nRecno   := 0
	Local _lRet 	:= .F.

	// busca usando idcnab
   	DbSelectArea("SE1")
	dbSetOrder(16)
	IF dbSeek(xFilial("SE1")+Left(aValores[1],10))
		_nRecno := SE1->(RECNO())
		_lRet 	:= .T.
	ENDIF

	// Se ainda não tiver sido localizado, faz mais uma busca.
	if _lRet == .F.
		DbSelectArea("SE1")
		dbSetOrder(16)
		IF dbSeek(xFilial("SE1")+Left(aValores[4],10))
		ParamIxb[1] := Left(aValores[4],10)
		_nRecno := SE1->(RECNO())
		ENDIF
	ENDIF 

	// se foi localizado, então posiciona atraves do recno.
	if _nRecno > 0
		dbGoto(_nRecno)
	ENDIF

	
Return
