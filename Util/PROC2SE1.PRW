#INCLUDE "TOTVS.CH"
#include "PROTHEUS.CH"
#include "RWMAKE.CH"
#INCLUDE "TopConn.ch"

/*/{Protheus.doc} ProcSE1
    (processa e ajusta juros indevidos Conciliação SITEF na SE1 e SE5)
    @type  Class
    @author Wilk Lima
    @since 25/03/2022
    @version 1.0
    /*/


Class xProc2SE1

//	Data _nParc as Number
	Data aArea

	Method new() Constructor
	Method Destroy()

	Method Proc2SE1(xFilial,xLote)
	MetHod GravaLog()

endClass

Method New() Class xProc2SE1
	::aArea := GetArea()
Return Self

Method Destroy() Class xProc2SE1
	RestArea(::aArea)
Return Self

Method Proc2SE1(xFilial,xLote) Class xProc2SE1

	cStrSql := ''
//_cOrigem := '' // usado aqui somente para controle de quem já foi ou não processado.
	_cAlias := GetNextAlias()
//_nParc := 0
	_Vazio := ''
	_nTotalLote := 0
	_nTotalDif  := 0


	BeginSql Alias _cAlias
	SELECT 
	E5_FILIAL,
	E5_FILORIG,
	E5_LOTE,
	E5_PREFIXO,
	E5_NUMERO,
	E5_PARCELA,
	E5_TIPO,
	FIF_VLLIQ VAL_AJUST
	FROM %table:SE5% SE5
	INNER JOIN FIF010 FIF ON FIF_CODFIL=E5_FILORIG AND FIF_PREFIX=E5_PREFIXO 
	AND FIF_NUM=E5_NUMERO AND FIF_PARC=E5_PARCELA AND FIF_TIPO=E5_TIPO AND FIF.%notdel% 
	WHERE SE5.E5_LOTE=%exp:xLote% AND E5_TIPODOC='BA' 
	AND SE5.%notdel% 
	ORDER BY  E5_FILIAL,E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO
	EndSql


	DBSelectArea("SE1")
	DbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	dbseek((_cAlias)->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO))
	DO WHILE (_cAlias)->(!EOF())
		// soma total do lote correto
		_nTotalLote += (_cAlias)->VAL_AJUST

		while SE1->(!EOF())

			if SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) == (_cAlias)->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)

				//ajusta valores na SE1
				Reclock("SE1",.F.)
				SE1->E1_VALOR  := (_cAlias)->VAL_AJUST
				SE1->E1_VLCRUZ := (_cAlias)->VAL_AJUST
				SE1->E1_VALLIQ := (_cAlias)->VAL_AJUST
				SE1->E1_VALJUR := 0
				SE1->E1_DESCONT:= 0
				SE1->(MsUnlock())

				// AJUSTA VALOR DA BAIXA NO SE5
				QRY_UPD2 := ''
				QRY_UPD2 += " UPDATE SE5010 SET E5_VALOR = "+CValToChar((_cAlias)->VAL_AJUST)+" "
				QRY_UPD2 += " , E5_VLMOED2 = "+CValToChar((_cAlias)->VAL_AJUST)+" "
				QRY_UPD2 += " , E5_VLJUROS=0 , E5_VLDESCO=0 "
				QRY_UPD2 += " WHERE D_E_L_E_T_<>'*' AND E5_FILIAL='"+xFilial+"' AND E5_LOTE='"+xLote+"' AND E5_TIPODOC='BA' AND E5_RECPAG='R' "
				QRY_UPD2 += " AND  E5_PREFIXO = '"+((_cAlias)->E5_PREFIXO)+"' "
				QRY_UPD2 += " AND  E5_NUMERO = '"+((_cAlias)->E5_NUMERO)+"' "
				QRY_UPD2 += " AND  E5_PARCELA = '"+((_cAlias)->E5_PARCELA)+"' "
				QRY_UPD2 += " AND  E5_TIPO = '"+((_cAlias)->E5_TIPO)+"' "
				TCSqlExec(QRY_UPD2)
				EXIT
			ENDIF
			SE1->(DbSkip())
		end

		//SE1->(DbSkip())
		(_cAlias)->(DbSkip())

	ENDDO

	(_cAlias)->(DbCloseArea())
	SE1->(DbCloseArea())

	// DELETA JUROS GERADO NA CONCILIACAO
	QRY_UPD := ''
	QRY_UPD += " UPDATE SE5010 SET D_E_L_E_T_='*' "
	QRY_UPD += " WHERE D_E_L_E_T_<>'*' AND E5_FILIAL='"+xFilial+"' AND E5_LOTE='"+xLote+"' AND E5_TIPODOC='JR' "
	TCSqlExec(QRY_UPD)

	// DELETA DESCONTO GERADO NA CONCILIACAO
	QRY_UPD := ''
	QRY_UPD += " UPDATE SE5010 SET D_E_L_E_T_='*' "
	QRY_UPD += " WHERE D_E_L_E_T_<>'*' AND E5_FILIAL='"+xFilial+"' AND E5_LOTE='"+xLote+"' AND E5_TIPODOC='DC' "
	TCSqlExec(QRY_UPD)

	// AJUSTA TOTAL DO LOTE
	QRY_UPD3 := ''
	QRY_UPD3 += " UPDATE SE5010 SET E5_VALOR = "+CValToChar(_nTotalLote)+" "
	QRY_UPD3 += " WHERE D_E_L_E_T_<>'*' AND E5_FILIAL='"+xFilial+"' AND E5_LOTE='"+xLote+"' AND E5_TIPODOC='VL' "
	QRY_UPD3 += " AND E5_NATUREZ ='NATMOVR' "
	TCSqlExec(QRY_UPD3)

Return Self


