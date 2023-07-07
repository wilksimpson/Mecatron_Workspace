#include 'protheus.ch'
//******************************
//RETORNA CONTA CONTABIL DA NATUREZA FINANCEIRA AMARRADA A NF DE ENTRADA
//FORMULA C09 - TABELA SM4
//******************************
User Function CTANATDSP
Local _aArea := GetArea()
Local _cDoc := PARAMIXB[1]
Local _cSer := PARAMIXB[2]
Local _cFil := PARAMIXB[3]
Local cAlias:= GetNextAlias()
Local _cRet := ""

BeginSql alias cAlias
	SELECT TOP 1 ED_FILIAL,ED_CODIGO,ED_DESCRIC,ED_CONTA
	FROM %table:SF1% SF1
	INNER JOIN %table:SE2% SE2 ON E2_FILIAL = F1_FILIAL AND E2_PREFIXO = F1_SERIE AND E2_NUM = F1_DUPL AND E2_FORNECE = F1_FORNECE AND E2_LOJA = F1_LOJA AND E2_EMISSAO = F1_EMISSAO AND SE2.%NotDel%
	INNER JOIN %table:SED% SED ON ED_CODIGO = E2_NATUREZ AND F1_FILIAL LIKE '%'+LTRIM(RTRIM(ED_FILIAL))+'%' AND SED.%NotDel%
	WHERE F1_DOC = %Exp:_cDoc% AND F1_FILIAL = %Exp:_cFil% AND F1_SERIE = %Exp:_cSer% AND SF1.%NotDel%
EndSql
If !(cAlias)->(Eof())
	_cRet := (cAlias)->ED_CONTA
Endif
If Select(cAlias) # 0
	(cAlias)->(DbCloseArea())
Endif
RestArea(_aArea)
Return(_cRet)
