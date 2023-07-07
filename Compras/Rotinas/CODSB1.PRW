USER FUNCTION CODSB1()

LOCAL _cCod := space(15)
LOCAL aAreaAnt := GETAREA()
Local cArqind := GetNextAlias()
Local cCodIni := '000001'
Local cCodFim := '06920600'
//Static cMayUse


    //Construindo a consulta
    BeginSql Alias cArqind
        //COLUMN CAMPO AS DATE //Deve se usar isso para transformar o campo em data
           
        SELECT TOP 1 
		B1_COD   
        FROM
            %table:SB1% SB1 
        WHERE
            B1_FILIAL  = %xFilial:SB1%
            AND SB1.%notDel%
			AND SB1.B1_COD BETWEEN %exp:cCodIni% and %exp:cCodFim%
		ORDER BY B1_COD DESC
    EndSql

IF !empty((cArqind)->B1_COD) 
	_cCod:= strzero(val((cArqind)->b1_cod)+1,6)
	cMay := Alltrim(xFilial("SB1"))+_cCod
	FreeUsedCode()
	SB1->(DbSetOrder(1))
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Se dois orcamentos iniciam ao mesmo tempo a MayIUseCode impede que ambos utilizem o mesmo numero.�
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	nTent := 0
	While SB1->(DbSeek(xFilial("SB1")+_CCOD)) .OR. !MayIUseCode(cMay)
		If ++nTent > 20
			Final("Impossivel gerar numero sequencial de produto correto. Informe ao administrador do sistema.")  //
		EndIf
		_cCod:= strzero(val(_cCod)+1,6)
		FreeUsedCode()
		cMay := Alltrim(xFilial("SB1"))+_cCod
	End
	
	ELSE 
	_cCod:= '000001'
ENDIF

M->B1_COD:=_CCOD
dbCloseArea()
RESTAREA(aAreaAnt)   // Retorna o ambiente anterior
RETURN(_CCOD)
