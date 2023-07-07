#INCLUDE "totvs.ch"
//=====================================================================
//Programa.: Lj7002 
//Autor....: Jose Carlos A Dias Fº
//Data.....: 14/04/1
//Descricao:Ponto de Entrada no Final do Venda Assistida Apos Gravacao
//=====================================================================
//Parametros: ParamIXB[1] - Tipo de Fechamento
//			1 - Orcamento
//			2 - Venda
//			3 - Pedido
//=====================================================================
User Function Lj7002() //
	Local _aArea 	:= GetArea()
	Local _nTipo 	:= PARAMIXB[1]
	Local _lReceb   := IIF(lRecebe=Nil,.F.,lRecebe)
	Local _nOpc		:= 0
	Local _lRet		:= .T.
	Local TemProd := aCols[1][2]
	Local aTitulos	:= {}
//Local _nRecL1 	:= SL1->(Recno())
//============================================
//Parametros que definem os tipos de Natureza
//Ambiente: SIGALOJA
//============================================
//MV_NATDINH	Natureza DINHEIRO
//MV_NATCHEQ	Natureza CHEQUE
//MV_NATCART	Natureza CARTAO DE CREDITO 
//MV_NATTEF		Natureza CARTAO DE DEBITO AUTOMATICO
//MV_NATFIN		Natureza FINANCIADO
//MV_NATVALE	Natureza VALES
//MV_NATCONV	Natureza CONVENIO
//MV_NATOUTR	Natureza OUTRAS
//MV_NATCRED	Natureza CREDITO
//MV_NATNCC		Natureza NOTA DE CREDITO
//MV_NATRECE	Natureza RECEBIMENTO
//MV_NATDEV		Natureza DEV./TROCA
//MV_NATTROC	Natureza TROCO
//============================================
//Dias -  Para nao gerar erro no recebimento de parcelas ctrl+D - SIGALOJA
	If !_lReceb .and. !empty(TemProd)
		IF Alltrim(SL1->L1_FORMPG) $ 'BO|BOL' .And. _nTipo = 2
			//_nOpc := Aviso('Deseja Imprimir os Boletos?','Selecionar Sim, para imprimir agora, ou não para emitir em outro momento.',{'&Sim.','&Nao'},1 )
			//If _nOpc = 1
				//Montagem da Funcao de Impressao dos Boletos
				DbSelectArea("SE1")
				SE1->(DbSetOrder(1))
				If SE1->(DbSeek(xFilial("SE1")+SL1->L1_SERIE+SL1->L1_DOC)) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
					WHILE !SE1->(Eof()) .and. xFilial("SE1")+SL1->L1_SERIE+SL1->L1_DOC = SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM
						IF ALLTRIM(SE1->E1_TIPO) $ 'BO|BOL'
							aAdd(aTitulos, {;
								.T.,;					// 1=Mark
							SE1->E1_PREFIXO,;		// 2=Prefixo do TÃ­tulo
							SE1->E1_NUM,;			// 3=NÃºmero do TÃ­tulo
							SE1->E1_PARCELA,;		// 4=Parcela do TÃ­tulo
							SE1->E1_TIPO,;			// 5=Tipo do TÃ­tulo
							SE1->E1_NATUREZ,;		// 6=Natureza do TÃ­tulo
							SE1->E1_CLIENTE,;		// 7=Cliente do tÃ­tulo
							SE1->E1_LOJA,;			// 8=Loja do Cliente
							SE1->E1_NOMCLI,;		// 9=Nome do Cliente
							SE1->E1_EMISSAO,;		//10=Data de EmissÃ£o do TÃ­tulo
							SE1->E1_VENCTO,;		//11=Data de Vencimento do TÃ­tulo
							SE1->E1_VENCREA,;		//12=Data de Vencimento Real do TÃ­tulo
							SE1->E1_VALOR,;			//13=Valor do TÃ­tulo
							SE1->E1_HIST,;			//14=HistÃ³tico do TÃ­tulo
							SE1->(RECNO()),;		//15=NÃºmero do registro no arquivo
							SE1->E1_NUMBCO ;		//16=Nosso NÃºmero
							})
						ENDIF
						SE1->(DbSkip())
					Enddo
				Endif
				If Len(aTitulos) > 0
					LjMsgRun("Imprimindo Boletos","Aguarde...",{|| U_ImpBol(aTitulos)})
				Endif
			//Endif
		Endif
	Endif
	If (_nTipo = 1) .And. Empty(SL1->L1_STORC)
		_nOpc:= Aviso("Impressão Orcamento","Imprime Orcamento?",{"Nao Fiscal","A4","Cancela"}) 
		If _nOpc = 1
			U_RImpOrc()
		ELSEIF _nOpc = 2
			U_Orcam_MC()
		Endif
	Endif
// Força gravação do Tipo de Frete, caso sistema não grave automaticamente.
	If Empty(SL1->L1_TPFRET) .AND. (M->LQ_TPFRET=='0' .OR. M->LQ_TPFRET=='S')
		RecLock("SL1",.f.)
		SL1->L1_TPFRET := 'S'
		MsuNlock()
	Endif

	IF !_lReceb .AND. !LFISCAL .AND. PARAMIXB[1] == 1 .AND. SL1->L1_LIBERAD != "1"
		U_RImpSep()
		msgInfo("Guia de separacao enviada")
	ENDIF

	if _nTipo == 2 .AND. !EMPTY(SL1->L1_DOC)
		RecLock("SL1",.f.)
		SL1->L1_LIBERAD := '4'
		MsuNlock()
	ENDIF

	If !_lReceb .and. _nTipo == 2 .and. M->LQ_LIBERAD < '3'
			ALERT("Orçamento não foi liberado pelo estoque.")
			_lRet := .F.
	ENDIF
	
	RestArea(_aArea)
Return(_lRet)

User Function FTVD7002() 
Return U_Lj7002()
