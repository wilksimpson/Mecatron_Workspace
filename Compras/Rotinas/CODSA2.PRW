USER FUNCTION CODSA2()

LOCAL _cCod := space(6)
LOCAL aAreaAnt := GETAREA()
Local cArqind := GetNextAlias()
Local cIni := "000001"
Local cFim := "999999"
//Static cMayUse


    //Construindo a consulta
    BeginSql Alias cArqind
        //COLUMN CAMPO AS DATE //Deve se usar isso para transformar o campo em data
           
        SELECT TOP 1 
		A2_COD   
        FROM
            %table:SA2% SA2 
        WHERE
            A2_FILIAL  = %xFilial:SA2%
			AND SA2.A2_COD BETWEEN %exp:cIni% and %exp:cFim%
            AND SA2.%notDel%
		ORDER BY A2_COD DESC
    EndSql

IF !empty((cArqind)->A2_COD) 
	_cCod:= strzero(val((cArqind)->A2_COD)+1,6)
	cMay := Alltrim(xFilial("A2_COD"))+_cCod
	FreeUsedCode()
	SA2->(DbSetOrder(1))
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Se dois orcamentos iniciam ao mesmo tempo a MayIUseCode impede que ambos utilizem o mesmo numero.�
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	nTent := 0
	While SA2->(DbSeek(xFilial("SA2")+_CCOD)) .OR. !MayIUseCode(cMay)
		If ++nTent > 20
			Final("Impossivel gerar numero sequencial de produto correto. Informe ao administrador do sistema.")  //
		EndIf
		_cCod:= strzero(val(_cCod)+1,6)
		FreeUsedCode()
		cMay := Alltrim(xFilial("SA2"))+_cCod
	End
	
	ELSE 
	_cCod:= '000001'
ENDIF

M->A2_COD:=_CCOD
dbCloseArea()
RESTAREA(aAreaAnt)   // Retorna o ambiente anterior
RETURN(_CCOD)
