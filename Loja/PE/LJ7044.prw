USER FUNCTION LJ7044()
	local _nTab := paramixb[1]
	local _lret := .f.

	If _nTab >= 1 .AND. _nTab <= 2
		_lret := .T.
	else
		_lret := .F.
	endif

Return(_lRet)


USER FUNCTION FTVD7044()

Return LJ7044()
