#INCLUDE "Protheus.ch"

/*/{Protheus.doc} FA740BRW
description: Exclusão Cart. Descontada.
@type function
@version  
@author wilks
@since 18/04/2022
@return variant, return_description
/*/

User Function FA740BRW()
	Local aBotao := {}


	aAdd(aBotao, {'Exclusão Cart. Descontada',"U_ExcDesc",   0 , 1    })
	aAdd(aBotao, {'Trans Cart. Descontada P/ Simples',"U_TranfSim",   0 , 1    })


Return(aBotao)


// Exclusão Baixa carteira Descontada.
user function ExcDesc()
	Local aAreaAnt := GETAREA()
	Local _cFilial := SE1->E1_FILIAL
	Local _cPrefix := SE1->E1_PREFIXO
	Local _cNum    := SE1->E1_NUM
	Local _cParcel := SE1->E1_PARCELA
	Local _cTipo   := SE1->E1_TIPO
	Local _cClifor := SE1->E1_CLIENTE
	Local _cLoja   := SE1->E1_LOJA
	local cArqind  := GetNextAlias()
	local cArqind2  := GetNextAlias()
	Local _lContin := .F.
	Local QRY_UPD  := ""
	Local QRY_UPD2 := ""
	Local cQuery   := ""
	Local cQuery3   := ""

	IF SE1->E1_SITUACA<>'2'
		MsgAlert(" Título não está na carteira descontada ", " Situação ")
		Return
	else
		_lContin := .T.
	ENDIF

	cQuery3 := " SELECT E5_RECONC FROM "+RETSQLNAME("SE5")+" SE5 WHERE D_E_L_E_T_ <>'*' "
	cQuery3 += " AND E5_FILIAL = '"+_cFilial+"' "
	cQuery3 += " AND E5_PREFIXO = '"+_cPrefix+"' "
	cQuery3 += " AND E5_NUMERO = '"+_cNum+"' "
	cQuery3 += " AND E5_PARCELA = '"+_cParcel+"' "
	cQuery3 += " AND E5_TIPO = '"+_cTipo+"' "
	cQuery3 += " AND E5_CLIFOR = '"+_cClifor+"' "
	cQuery3 += " AND E5_LOJA = '"+_cLoja+"'  "
	cQuery3 += " AND E5_RECONC='x' "
	cQuery3 += " GROUP BY E5_RECONC  "
	DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery3), cArqind2, .T., .F. )

	WHILE !(cArqind2)->( EOF())
		if (cArqind2)->E5_RECONC == 'x'
			MsgAlert(" Atenção, Movimento Conciliado, favor estornar conciliação primeiro. ", " Situação ")
			return
		else
			_lContin := .T.
		ENDIF
		(cArqind2)->(DbSkip())
	ENDDO

	cQuery := " SELECT count(1) as QTDBX FROM "
	cQuery += " ( SELECT E5_SEQ FROM "+RETSQLNAME("SE5")+" SE5 WHERE D_E_L_E_T_ <>'*' "
	cQuery += " AND E5_FILIAL = '"+_cFilial+"' "
	cQuery += " AND E5_PREFIXO = '"+_cPrefix+"' "
	cQuery += " AND E5_NUMERO = '"+_cNum+"' "
	cQuery += " AND E5_PARCELA = '"+_cParcel+"' "
	cQuery += " AND E5_TIPO = '"+_cTipo+"' "
	cQuery += " AND E5_CLIFOR = '"+_cClifor+"' "
	cQuery += " AND E5_LOJA = '"+_cLoja+"'  "
	cQuery += " GROUP BY E5_SEQ ) AS TMP "
	DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cArqind, .T., .F. )

	if (cArqind)->QTDBX > 1
		MsgAlert(" Atenção, título sofreu mais de uma baixa, por segurança, não é possível excluir a antecipação. ", " Situação ")
		return
	else
		_lContin := .T.
	ENDIF


	IF _lContin == .T.

		// LIMPA CAMPOS DA CARTEIRA DESCONTADA
		RecLock("SE1", .F.)
		SE1->E1_PORTADO := ""
		SE1->E1_AGEDEP  := ""
		SE1->E1_SITUACA := "0"
		SE1->E1_SALDO   := SE1->E1_VALOR
		SE1->E1_DESCONT := 0
		SE1->E1_JUROS   := 0
		SE1->E1_VALLIQ  := 0
		SE1->E1_CONTA   := ""
		SE1->E1_STATUS  := "A"
		MsUnlock()


		// Deleta registro de trasnferencia.
		QRY_UPD2 := " DELETE FROM SEA010  "
		QRY_UPD2 += " WHERE D_E_L_E_T_<>'*' AND EA_SITUACA='2' AND EA_CART='R' "
		QRY_UPD2 += " AND EA_FILIAL= '"+_cFilial+"' "
		QRY_UPD2 += " AND EA_PREFIXO= '"+_cPrefix+"' "
		QRY_UPD2 += " AND EA_NUM= '"+_cNum+"' "
		QRY_UPD2 += " AND EA_PARCELA= '"+_cParcel+"' "
		QRY_UPD2 += " AND EA_TIPO= '"+_cTipo+"' "
		TCSqlExec(QRY_UPD2)


		// deleta registros de baixa.
		QRY_UPD := " UPDATE SE5010 SET D_E_L_E_T_='*' "
		QRY_UPD += " WHERE D_E_L_E_T_<>'*'  "
		QRY_UPD += " AND E5_FILIAL = '"+_cFilial+"' "
		QRY_UPD += " AND E5_PREFIXO = '"+_cPrefix+"' "
		QRY_UPD += " AND E5_NUMERO  = '"+_cNum+"' "
		QRY_UPD += " AND E5_PARCELA = '"+_cParcel+"' "
		QRY_UPD += " AND E5_TIPO = '"+_cTipo+"' "
		QRY_UPD += " AND E5_CLIFOR = '"+_cClifor+"' "
		QRY_UPD += " AND E5_LOJA = '"+_cLoja+"' "
		TCSqlExec(QRY_UPD)
	ENDIF



	RESTAREA(aAreaAnt)   // Returns previous environment.
Return


// Transf. carteira Descontada para carteira simples.
user function TranfSim()
	Local aAreaAnt := GETAREA()
	Local _cFilial := SE1->E1_FILIAL
	Local _cPrefix := SE1->E1_PREFIXO
	Local _cNum    := SE1->E1_NUM
	Local _cParcel := SE1->E1_PARCELA
	Local _cTipo   := SE1->E1_TIPO
	Local _cClifor := SE1->E1_CLIENTE
	Local _cLoja   := SE1->E1_LOJA
	local cArqind  := GetNextAlias()
	Local _lContin := .F.
	Local QRY_UPD2 := ""
	Local cQuery   := ""

	IF SE1->E1_SITUACA<>'2'
		MsgAlert(" Título não está na carteira descontada ", " Situação ")
		Return
	else
		_lContin := .T.
	ENDIF


	IF SE1->E1_VALOR<>SE1->E1_SALDO
		MsgAlert(" Antes de realizar transferencia da carteira descontada para carteira simples, favor efetuar a exclusão da baixa. ", " Situação ")
		Return
	else
		_lContin := .T.
	ENDIF

	cQuery := " SELECT count(1) as QTDBX FROM "
	cQuery += " ( SELECT E5_SEQ FROM "+RETSQLNAME("SE5")+" SE5 WHERE D_E_L_E_T_ <>'*' "
	cQuery += " AND E5_FILIAL = '"+_cFilial+"' "
	cQuery += " AND E5_PREFIXO = '"+_cPrefix+"' "
	cQuery += " AND E5_NUMERO = '"+_cNum+"' "
	cQuery += " AND E5_PARCELA = '"+_cParcel+"' "
	cQuery += " AND E5_TIPO = '"+_cTipo+"' "
	cQuery += " AND E5_CLIFOR = '"+_cClifor+"' "
	cQuery += " AND E5_LOJA = '"+_cLoja+"'  "
	cQuery += " GROUP BY E5_SEQ ) AS TMP "
	DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cArqind, .T., .F. )


	if (cArqind)->QTDBX > 1
		MsgAlert(" Atenção, título sofreu mais de uma baixa, por segurança, não é possível transferir para carteira Simples. ", " Situação ")
		return
	else
		_lContin := .T.
	ENDIF


	IF _lContin == .T.

		// LIMPA CAMPOS DA CARTEIRA DESCONTADA
		RecLock("SE1", .F.)
		SE1->E1_PORTADO := ""
		SE1->E1_AGEDEP  := ""
		SE1->E1_SITUACA := "0"
		SE1->E1_DESCONT := 0
		SE1->E1_JUROS   := 0
		SE1->E1_VALLIQ  := 0
		SE1->E1_CONTA   := ""
		SE1->E1_STATUS  := "A"
		MsUnlock()


		// Deleta registro de trasnferencia.
		QRY_UPD2 := " DELETE FROM SEA010  "
		QRY_UPD2 += " WHERE D_E_L_E_T_<>'*' AND EA_SITUACA='2' AND EA_CART='R' "
		QRY_UPD2 += " AND EA_FILIAL= '"+_cFilial+"' "
		QRY_UPD2 += " AND EA_PREFIXO= '"+_cPrefix+"' "
		QRY_UPD2 += " AND EA_NUM= '"+_cNum+"' "
		QRY_UPD2 += " AND EA_PARCELA= '"+_cParcel+"' "
		QRY_UPD2 += " AND EA_TIPO= '"+_cTipo+"' "
		TCSqlExec(QRY_UPD2)

	ENDIF



	RESTAREA(aAreaAnt)   // Returns previous environment.
Return

