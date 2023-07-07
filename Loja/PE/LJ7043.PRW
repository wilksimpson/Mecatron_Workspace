USER FUNCTION LJ7043()
	Local _lret := .T.
	local _nTab := paramixb[1]

	//desativa mudança de preço de tabela diretamente no item ou pelo atalho Ctrl + C
	If _nTab >= 1 .AND. _nTab <= 2
		_lret := .T.
	else
		_lret := .F.
	endif

Return(_lRet)


USER FUNCTION FTVD7043()

Return LJ7043()
