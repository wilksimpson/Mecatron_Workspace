#Include "Protheus.ch"
#Include "rwmake.ch"

 /* ajusta rotina de conciliação automatica para não compor digito verificador da conta na conta bancaria */

User Function Fa473Cta()
	Local _cBanco   := ''
	Local _cAgencia := ''
	Local _cConta   := ''
	Local aRet := {}
	Local _InfoAg   := MV_PAR03
	Local _InfoCta  := MV_PAR04
	Local _DVCTA    := ''

	IF TYPE ('Paramixb') <> "U"
		_cBanco   := Paramixb[1]
		_cAgencia := Paramixb[2]
		_cConta   := Paramixb[3]
		_DVCTA    := POSICIONE("SA6",1,XFILIAL("SA6")+_cBanco+_InfoAg+_InfoCta,"A6_DVCTA")
	ENDIF

	// ajusta conta retirando digito
	if INCLUI = .T. .and. _cBanco == '341'  // tratamento para banco itaú
		_cConta := substr(_cConta,1,5)
		aRet := {_cBanco,_cAgencia, _cConta}
	elseif  _DVCTA>" " .AND. ALLTRIM(_InfoCta)$ALLTRIM(_cConta) // tratamento para utros bancos
		_cConta := _InfoCta
		aRet := {_cBanco,_cAgencia, _cConta}
	else
		aRet := Paramixb
	ENDIF

Return aRet
