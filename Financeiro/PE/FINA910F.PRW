#Include 'Protheus.ch'

/*/{Protheus.doc} User Function FINA910F
    (Ajusta Array com os dados do Banco, Agência e Conta Corrente a serem gravadas na tabela SE1 e SE5.)
    (No arquivo conciliação sitef, é enviado conta com o digito, porém no protheus o cadastro é feito somente com o numero da conta.)
    @type  Function
    @author Wilk Lima
    @since 16/01/2022
    @version 1.0
    @return aRet, Array, banco Agencia e Conta a gravar na baixa da conciliação SITEF.
    @example
    (examples)
    @see (links_or_references)
    /*/

User function FINA910F()
	Local aRet   := PARAMIXB


	if VALTYPE(aRet)=="A"
        // ITAU BELEM
		if aRet[1]=="341" .AND. RIGHT(aRet[2],4)=="1580" .AND. RIGHT(alltrim(aRet[3]),6)=="409819"
			aRet[1] := PADR("341",TamSX3("A6_COD")[1]) // Numero do banco que serah gravado na SE1->E1_PORTADO
			aRet[2] := PADR("1580",TamSX3("A6_AGENCIA")[1]) // Numero da agencia que serah gravada no campo SE1->E1_AGENCIA
			aRet[3] := PADR("40981",TamSX3("A6_NUMCON")[1]) // Numero da conta corrente
		endif
        // ITAU MATRIZ
        if aRet[1]=="341" .AND. RIGHT(aRet[2],4)=="1580" .AND. RIGHT(alltrim(aRet[3]),6)=="242574"
			aRet[1] := PADR("341",TamSX3("A6_COD")[1]) // Numero do banco que serah gravado na SE1->E1_PORTADO
			aRet[2] := PADR("1580",TamSX3("A6_AGENCIA")[1]) // Numero da agencia que serah gravada no campo SE1->E1_AGENCIA
			aRet[3] := PADR("24257",TamSX3("A6_NUMCON")[1]) // Numero da conta corrente
		endif
        // ITAU MARITUBA
        if aRet[1]=="341" .AND. RIGHT(aRet[2],4)=="1580" .AND. RIGHT(alltrim(aRet[3]),6)=="384004"
			aRet[1] := PADR("341",TamSX3("A6_COD")[1]) // Numero do banco que serah gravado na SE1->E1_PORTADO
			aRet[2] := PADR("1580",TamSX3("A6_AGENCIA")[1]) // Numero da agencia que serah gravada no campo SE1->E1_AGENCIA
			aRet[3] := PADR("38400",TamSX3("A6_NUMCON")[1]) // Numero da conta corrente
		endif
        // ITAU PARAUPEBAS
        if aRet[1]=="341" .AND. RIGHT(aRet[2],4)=="7780" .AND. RIGHT(alltrim(aRet[3]),6)=="209099"
			aRet[1] := PADR("341",TamSX3("A6_COD")[1]) // Numero do banco que serah gravado na SE1->E1_PORTADO
			aRet[2] := PADR("7780",TamSX3("A6_AGENCIA")[1]) // Numero da agencia que serah gravada no campo SE1->E1_AGENCIA
			aRet[3] := PADR("20909",TamSX3("A6_NUMCON")[1]) // Numero da conta corrente
		endif
	ENDIF


Return aRet
