#Include "Protheus.ch"
#include "TopConn.ch"
#INCLUDE "COLORS.CH"
#include "rwmake.ch"
#include "tbiconn.ch"
#INCLUDE "MSOLE.CH"
/*/
Ponto de entrada na finalização da venda para validações adicionais do cliente.
/*/
user function LJ7001()
	Local aArea := GetArea()
	Local TemProd := aCols[1][2]
	Local i
	Local _lRET:=.T.
	Local _lAprazo:=.f.
	Local _lDebito := .F.
	Local _lCredito := .F.
	Local _lDin := .f.
	Local _nTotPag := 0
	Local _nValor := 0
//	Local nPosProd			:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_PRODUTO"})][2] 		// Posicao da codigo do produto
//	Local nPosQtd			:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_QUANT"})][2] 		// Posicao da codigo do produto
//	Local nPosDtReserva		:= Ascan(aPosCpoDet,{|x| Alltrim(Upper(x[1])) == "LR_RESERVA"})				// Posicao do codigo da reserva
//	Local nPosDtLojaRes		:= Ascan(aPosCpoDet,{|x| Alltrim(Upper(x[1])) == "LR_LOJARES"})				// Posicao do codigo da reserva
//	Local nPosDtLocal  		:= Ascan(aPosCpoDet,{|x| Alltrim(Upper(x[1])) == "LR_LOCAL"})					// Posicao do local (armazem)
//	Local nPosItem			:= aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_ITEM"})][2]		    // Posicao do Codigo do item
//	Local nTamLR_RESERVA	:= TamSx3("LR_RESERVA")[1]													// Tamanho do campo LR_RESERVA
//	Local nTamLR_LOJARES	:= TamSx3("LR_LOJARES")[1]													// Tamanho do campo LR_LOJARES
	Local nPosTAB    	:= AsCan(aposcpodet,{|x|Alltrim(x[1])="LR_PRCTAB"})
	Local _nPosvLUNT 	:= AsCan(aheader,{|x|Alltrim(x[2])="LR_VRUNIT"})
//	Local _cMsg := ""

	if !empty(TemProd)//DESATIVA P.E PARA recebimentos
		//NAO PERMITE DIFERENCA DE PREÇO TABELA COM O PREÇO DO ORCAMENTO
		FOR i:=1 TO LEN(ACOLS)
			If !aCols[i][Len(aCols[i])]
				IF acols[i,_nPosvLUNT] != acolsdet[i,nPosTAB]
					acolsdet[i,nPosTAB] := acols[i,_nPosvLUNT]
				ENDIF
			Endif
		NEXT

		IF PARAMIXB[1]==2
			// desobriga conferencia nas filiais.
			if M->LQ_LIBERAD <'3' .AND. XFILIAL("SL1") $ GETMV("MV_FILCONF")
				MsgInfo("Orçamento não está liberado","Atenção")
				Return .F.
			endif

		ENDIF
	ENDIF

	IF !empty(TemProd)//DESATIVA P.E PARA recebimentos.

		/*/LIMPA RESERVAS ANTERIORES DO ORCAMENTO
		for i := 1 to len(aCols)
			if !acols[i,len(aCols[i])] // Deletado
				Lj7CancRes(	  {{aColsDet[i][nPosDtReserva]	,;	// Numero da Reserva
				aColsDet[i][nPosDtLojaRes]		,;	// Codigo da loja da reserva
				aCols[i][nPosProd]				,;	// Codigo do produto
				aColsDet[i][nPosDtLocal]			,;	// Codigo do local (armazem)
				NIL									,; 	//
				aCols[i][nPosItem]				}} )// Item
				aColsDet[i][nPosDtReserva] := Space( nTamLR_RESERVA )
				aColsDet[i][nPosDtLojaRes] := Space( nTamLR_LOJARES )
			endif
		next
		Lj7AtuResOrc(M->LQ_NUM, .T.)
		/*/


		IF M->LQ_LIBERAD < "4" .and. PARAMIXB[1]==1

			if MSGYESNO( "Enviar Orçamento para separação", "Separação")
				//EFETUA NOVA RESERVA
				M->LQ_LIBERAD := "2"
				//LJ7BtnRes( 1 )
				//VERIFICA SE A RESERVA FOI EFETUADA
				/*/NAO PERMITE CONTINUAR UMA PRE VENDA SEM RESERVA
				for i := 1 to len(aCols)
					if !acols[i,len(aCols[i])] .AND. EMPTY(aColsDet[i][nPosDtReserva] )
						dbSelectArea("SB2")
						dbsetorder(1)
						IF dbSeek(xFilial("SB2") + aCols[i][nPosProd] + aColsDet[i][nPosDtLocal])
							IF SaldoSb2() < aCols[i][nPosQtd]
								_cMsg += "Item: "+aCols[i][nPosItem]+" - Produto:"+aCols[i][nPosProd]+CHR(13)
							ENDIF
							_bRet := .F.

						ENDIF

					endif
				next /*/
			ENDIF
		ENDIF

		//IF !EMPTY(_cMsg)
		//	Alert("Orçamento nao pode ser salva pois os seguintes produtos estao sem estoque para reserva"+CRLF+_cMsg)
		//ENDIF



		IF !lfiscal .AND. !IsInCallStack('LJ7CPGRVOR')
			//	U_ATUAPRECO()
			//	If Empty(M->LQ_CONDPG)
			//		M->LQ_CONDPG := SuperGetMV("MV_CONDPAD")
			//	EndIf
			//LJ7VldCond( M->LQ_CONDPG , @cDescCondPg, @oDescCondPg, @oPgtos, "" )
			//Lj7lAtuCond( .T. )
			//Lj7CondPg( 2, M->LQ_CONDPG,, ( ! nNCCUsada > 0 ))
			Lj7AjustaTroco()

			If lVisuSint
				oPgtosSint:Refresh()
			EndIf

			oPgtos:Refresh()
		ENDIF

		for i := 1 to len(aPgtos)
			_nTotPag += aPgtos[i][2]
			if ALLTRIM(aPgtos[i][3]) = 'R$'
				_lDin := .t.
			endif
			if ALLTRIM(aPgtos[i][3]) = 'CD'
				_lDebito := .t.
			endif
			if ALLTRIM(aPgtos[i][3]) = 'CC'
				_lCredito := .t.
			endif

			If (alltrim(aPgtos[i][3]) $ ALLTRIM(GETMV("MV_FORBLQ")))
				_lAprazo := .t.
				_nValor += aPgtos[i][2]
			Endif

		next
		IF aDesconto[3] > 0.10 //10 CENTAVOS É PERMITIDO PARA QUALQUER FORMA DE PAGAMENTO
			_cGrpVen := POSICIONE("SA1",1,XFILIAL("SA1")+M->LQ_CLIENTE+M->LQ_LOJA,"A1_GRPVEN")
			IF _cGrpVen != "000001" //QUANDO NAO FOR DO GRUPO
				IF aDesconto[2] > 0 .AND. (_lAprazo .OR. _lCredito)
					If !FWAuthSuper(__cUserId)
						Alert("Venda a prazo não permite desconto")
						Return .f.
					ENDIF
				ENDIF
				IF aDesconto[2] > 3.5 .AND. _lDebito
					If !FWAuthSuper(__cUserId)
						Alert("Venda a debito não permite desconto maior que 3.5%")
						Return .f.
					ENDIF
				ENDIF
			ENDIF

		ENDIF


		If _lAprazo
			IF alltrim(M->LQ_CLIENTE) == alltrim(GETMV("MV_CLIPAD"))
				alert("Venda a Prazo nao pode ser efetuada para Cliente Padrao")
				_LRET:=.f.
			ELSE
				_lBloq:=U_LJ701CLI(M->LQ_CLIENTE,M->LQ_LOJA,_NvALOR)
				If !_lBloq .AND. _lRet .AND. PARAMIXB[1]==2
					_LRET:=_lBloq

					If !FWAuthSuper(__cUserId)
						Alert("Necessario senha do supervisor para realizar a liberação do cliente.")
						Return .f.
					ELSE
						_LRET:=.T.

					ENDIF

				Endif
			ENDIF
		endif

		RestArea(aArea)


	ENDIF //FUNNAME


RETURN(_lRET)

user function FTVD7001()

RETURN U_LJ7001()
