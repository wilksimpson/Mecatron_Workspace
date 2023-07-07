#include "protheus.ch"

USER FUNCTION PE01NFESEFAZ()
	Local aProd     := PARAMIXB[1]
	Local cMensCli  := PARAMIXB[2]
	Local cMensFis  := PARAMIXB[3]
	Local aDest     := PARAMIXB[4]
	Local aNota     := PARAMIXB[5]
	Local aInfoItem := PARAMIXB[6]
	Local aDupl     := PARAMIXB[7]
	Local aTransp   := PARAMIXB[8]
	Local aEntrega  := PARAMIXB[9]
	Local aRetirada := PARAMIXB[10]
	Local aVeiculo  := PARAMIXB[11]
	Local aReboque  := PARAMIXB[12]
	Local aNfVincRur:= PARAMIXB[13]
	Local aEspVol   := PARAMIXB[14]
	Local aNfVinc   := PARAMIXB[15]
	Local AdetPag   := PARAMIXB[16]
	Local aObsCont  := PARAMIXB[17]
	Local aProcRef  := PARAMIXB[18]
	Local aRetorno      := {}
	//Local cMsg          := ""
	Local _cPedido  := SD2->D2_PEDIDO
	Local _cOrigem  := SD2->D2_ORIGLAN
	Local nX
	Local nY
	Local nZ
	Local nV
	Local _nNCC := 0

	IF aNota[5] == "D" .AND. aNota[1] == "2  " .AND. LEN(aNfVinc) == 0
		//QUANDO FOR DEVOLUCAO SERIE 3 SEM VINCULO
		For nX := 1 To Len(aProd)
			dbSelectArea("SD1")
			dbSetOrder(1)
			If dbSeek(xFilial("SD1")+aNota[2]+aNota[1]+aNota[7]+aNota[8]+aProd[nX][2])
				IF !EMPTY(SD1->D1_CHNFORI)
					aAdd( aNfVinc, { SD1->D1_DATORI, SD1->D1_SERIORI, SD1->D1_NFORI,;
						POSICIONE("SA1",1,XFILIAL("SA1")+aNota[7]+aNota[8],"A1_CGC"),;
						POSICIONE("SA1",1,XFILIAL("SA1")+aNota[7]+aNota[8],"A1_EST"),;
						"SPED", SD1->D1_CHNFORI, 0,"","",0,"","" })
				ENDIF
			ENDIF
		Next
		if len(AdetPag)>0 // ajusta a tag tPag para não ocorrer rejeição 871.
			if AdetPag[1,1]<>'90'
				AdetPag[1,1] := '90'
			endif
		ENDIF
	endif


	if !empty(_cPedido) .AND. aNota[5] == "N"
		dbSelectArea("SC5")
		dbSetOrder(1)
		MsSeek(xFilial("SC5")+_cPedido)

		IF !EMPTY(SC5->C5_OBS)
			cMensCli += AllTrim(SC5->C5_OBS)
		ENDIF

		IF !EMPTY(SC5->C5_PLACA1)
			aadd(aVeiculo,SC5->C5_PLACA1)
			aadd(aVeiculo,"") //ESTADO
			aadd(aVeiculo,"")//RNTC
		ENDIF

		aDest[2] := SC5->C5_CLIENTE+" "+alltrim(aDest[2])

	endif

	if _cOrigem $ 'VD/LO' .AND. aNota[5] == "N"

		dbSelectArea("SL1")
		dbSetOrder(2) //L1_FILIAL+L1_SERIE+L1_DOC+L1_PDV
		MsSeek(SD2->D2_FILIAL+SD2->D2_SDOC+SD2->D2_DOC)

		aDest[2] := SD2->D2_CLIENTE+" "+alltrim(aDest[2])

		cMensCli += " Orçamento: "
		cMensCli += SL1->L1_NUM+chr(13)

		// ACRESCENTA INFORMAÇÃO DO VENDEDOR NA OBS DA NF
		IF !EMPTY(SL1->L1_VEND)
			cMensCli += " Representante: "
			cMensCli += ALLTRIM(POSICIONE("SA3",1,XFILIAL("SA3")+SL1->L1_VEND,"A3_NOME"))
			cMensCli += ". "+chr(13)
		ENDIF

		// ACRESCENTA OBSERVAÇÃO NA NF
		IF !EMPTY(SL1->L1_OBS)
			cMensCli += AllTrim(SL1->L1_OBS)
		ENDIF

		IF !EMPTY(SL1->L1_PEDCLI)
			cMensCli += " Pedido de Compra do cliente: "+ALLTRIM(SL1->L1_PEDCLI)
		ENDIF

		// COMPLEMENTA DESCRIÇÃO DO PRODUTO COM NÚMERO DE SÉRIE E TAG DO PRODUTO
		dbSelectArea("SL2")
		dbSetOrder(1) //L1_FILIAL+L1_SERIE+L1_DOC+L1_PDV
		dbGoTop()
		IF MsSeek(SL1->L1_FILIAL+SL1->L1_NUM)
			While !SL2->(Eof()) .And.  SL1->L1_FILIAL==SL2->L2_FILIAL .AND. SL1->L1_NUM==SL2->L2_NUM

				FOR nX := 1 To len(aProd)

					if aProd[nX,2]==SL2->L2_PRODUTO .and. aProd[nX,39]==SL2->L2_ITEM
						IF !EMPTY(SL2->L2_VDOBS)
							aProd[nX,4] := ALLTRIM(aProd[nX,4])+' '+SL2->L2_VDOBS
						ENDIF
						IF !EMPTY(SL2->L2_NSERIE)
							aProd[nX,4] := ALLTRIM(aProd[nX,4])+' S/N '+ALLTRIM(SL2->L2_NSERIE)
						ENDIF
						IF !EMPTY(SL1->L1_PEDCLI)
							aProd[nX,38] := ALLTRIM(SL1->L1_PEDCLI)
						ENDIF
						EXIT
					ENDIF

				NEXT nX

				dbSkip()
			EndDo
		ENDIF

		// complementa gravação da forma de pagamento do loja para NCC
		FOR nZ := 1 to  LEN(AdetPag)
			IF AdetPag[nZ,1]=='05'
				AdetPag[nZ,9]:='Credito Loja'
				_nNCC +=  val(AdetPag[nZ,2])
			ENDIF
		NEXT nZ

		// complementa tag duplicatas na impressão do danfe.
		FOR nV := 1 to len(aDupl)
			if _nNCC > 0
				aadd(aDupl,{'Credito Loja',anota[3],_nNCC})
				cMensCli += " "+chr(13)
				cMensCli += ' Abatimento ref. crédito no valor de '+cValToChar(_nNCC)
			ENDIF
		NEXT nV

	endif


	// troca código interno do produto pela referencia.
	FOR nY := 1 To len(aProd)
		aProd[nY,2] := IF(POSICIONE('SB1',1,XFILIAL('SB1')+aProd[nY,2],'B1_REFER')>' ',SB1->B1_REFER,aProd[nY,2])
	NEXT nY

//O retorno deve ser exatamente nesta ordem e passando o conteúdo completo dos arrays
//pois no rdmake nfesefaz é atribuido o retorno completo para as respectivas variáveis
//Ordem:
//      aRetorno[1] -> aProd
//      aRetorno[2] -> cMensCli
//      aRetorno[3] -> cMensFis
//      aRetorno[4] -> aDest
//      aRetorno[5] -> aNota
//      aRetorno[6] -> aInfoItem
//      aRetorno[7] -> aDupl
//      aRetorno[8] -> aTransp
//      aRetorno[9] -> aEntrega
//      aRetorno[10] -> aRetirada
//      aRetorno[11] -> aVeiculo
//      aRetorno[12] -> aReboque
//      aRetorno[13] -> aNfVincRur
//      aRetorno[14] -> aEspVol
//      aRetorno[15] -> aNfVinc
//      aRetorno[16] -> AdetPag
//      aRetorno[17] -> aObsCont 
//      aRetorno[18] -> aProcRef 

	aadd(aRetorno,aProd)
	aadd(aRetorno,cMensCli)
	aadd(aRetorno,cMensFis)
	aadd(aRetorno,aDest)
	aadd(aRetorno,aNota)
	aadd(aRetorno,aInfoItem)
	aadd(aRetorno,aDupl)
	aadd(aRetorno,aTransp)
	aadd(aRetorno,aEntrega)
	aadd(aRetorno,aRetirada)
	aadd(aRetorno,aVeiculo)
	aadd(aRetorno,aReboque)
	aadd(aRetorno,aNfVincRur)
	aadd(aRetorno,aEspVol)
	aadd(aRetorno,aNfVinc)
	aadd(aRetorno,AdetPag)
	aadd(aRetorno,aObsCont)
	aadd(aRetorno,aProcRef)

RETURN aRetorno
