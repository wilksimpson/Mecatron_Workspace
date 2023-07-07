#Include "protheus.ch"
#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ LjCreCli ³ Autor ³ Wagner Xavier 		³ Data ³		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pega dados do cliente e checa credito					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ LojA010 e LojA220 										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function LjCreCli(cCliente, cLoja, cCliAnt, cLojAnt, oDlg, cStatus, lExecTroca,cbmp,_nVlrTot,aDados,_lNoFin,_nSaldo)
	Local cAlias  := Alias()
	Local cMotivo := "Nada consta"
	Local dTitProt, dChqDevo
	Local oDlgMotCre, oFont
	Local lAprovado := .T.
	Local lAbreDialogo  := .T.
	Local l10ImpCli := ExistBlock("L10IMPCL")
//	Local nX

	lAprovado := .T.
	If cCliente == GetMV( "MV_CLIPAD" )
		If lAbreDialogo
			// Exibe o cliente no rodape da tela de venda
			// com o status da analise de credito atualizado
			cCliAnt := cCliente
			cLojAnt := cLoja
		Else
			cStatus := cMotivo
		EndIf
		lNofin := .f.
		Return lAprovado
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica parametros									   |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCliente   := IIf( cCliente	== NIL, M->LQ_CLIENTE, cCliente )
	cLoja	   := IIf( cLoja 	== NIL, M->LQ_LOJA, cLoja )
	cCliAnt    := IIf( cCliAnt 	== NIL, "", cCliAnt )
	cLojAnt    := IIf( cLojAnt 	== NIL, "", cLojAnt )

// Fica verdadeiro quando esta funcao e chamada do dialogo de troca de mercadorias
// Utilizada apenas para chamar ou nao a funcao Lj010ImpCli
	lExecTroca := IIf( lExecTroca == NIL, .F., lExecTroca )

// Quando este parametro esta ativo:
// 1) Esta funcao esta sendo chamada da Lj010ImpCli, portando nao deve chama-la novamente.
// 2) Nao apresenta o dialogo com o status do cliente.
	lAbreDialogo := .f.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se nÆo ‚ o Cliente / Loja padrƒo              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	_lQry:=.T.
/*/  
	If _lQry
		aStru := SA1->(dbstruct())
		cQuery := "SELECT * FROM SA1010 WHERE  "
		cQuery +=       "A1_COD='"+ccLiente+"' AND "
		cQuery +=       "A1_LOJA='"+cLoja+"' AND "
		cQuery +=		" D_E_L_E_T_<>'*' "
		cQry   := "SA1010A"
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.F.,.T.)
		For nX := 1 To Len(aStru)
			If aStru[nX,2] != "C"
				TcSetField(cQry,aStru[nX,1],aStru[nX,2],aStru[nX,3],aStru[nX,4])
			EndIf
		Next nX

		dbSelectArea(cQry)
	Else
		dbSelectArea("SA1")
	Endif
/*/	
	dbSelectArea("SA1")



	IF EMPTY(SA1->A1_RISCO)
		_cRisco := 'D'
	ELSE
		_cRisco := SA1->A1_RISCO
	ENDIF

	cDescCli := SA1->A1_NOME
	cLoja    := SA1->A1_LOJA
	If _cRisco == "A"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cliente aprovado 									   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cBmp := "BOMBE"
		lAprovado := .T.

	ElseIf _cRisco == "E"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cliente reprovado                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cBmp	  := "BOOM"
		cMotivo := "Risco E - Cliente BLOQUEADO."
		lAprovado := .F.
		_lNoFin := .t.
		lAbreDialogo := .t.

	Else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se o risco for B,C ou D entÆo analisar demais fatores  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cliente reprovado									   ³
		//³ Motivo : O saldo de titulos em aberto ‚ maior que      ³
		//³			 limite de cr‚dito                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//If SA1->A1_LC > 0
		add := LjSaldo(cCliente, cLoja,_nVlrtot,aDados)
		aDados := add[2]
		If !add[1]
			cBmp	  := "BOOM"
			cMotivo := "O saldo de titulos em aberto ‚ maior que o limite de credito."
			lAprovado := .F.
			_lNoFin := .t.
			If _nVlrTot > 0
				lAbreDialogo := .t.
			Endif
		Else
			lAprovado := .T.
			_lNoFin := .f.
		EndIf
	/*/Endif
		If _lQry
			dbSelectArea(cQry)
		Else
			dbSelectArea("SA1")
		Endif
	/*/
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cliente reprovado									   ³
		//³ Motivo : N£mero de dias em atraso maior que o No de	   ³
		//³			 dias permitido pelo parƒmetro.				   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If LjAtraso(cCliente, cLoja)
			cBmp	  := "BOOM"
			cMotivo := "Numero de dias em atraso maior que o numero de dias permitido pelo parametro."
			lAprovado := .F.
			lAbreDialogo := .T.

			_lNofin := .t.
		EndIf
	/*/
		If _lQry
			dbSelectArea(cQry)
		Else
			dbSelectArea("SA1")
		Endif
	/*/
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cliente reprovado									   ³
		//³ Motivo : Data do limite de cr‚dito vencida.            ³
		//ÀÄÄÄÄÄ.ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SA1->A1_VENCLC) .And. SA1->A1_VENCLC < dDatabase
			cBmp	  := "BOMB"
			cMotivo := "Data do limite de credito vencida."
			lAprovado := .F.
			lAbreDialogo := .T.
			_lNoFin := .t.
		EndIf
	/*/
		If _lQry
			dbSelectArea(cQry)
		Else
			dbSelectArea("SA1")
		Endif
	/*/

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cliente reprovado									   ³
		//³ Motivo: J  houveram t¡tulos protestados anteriormente. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SA1->A1_TITPROT > 0
			dTitProt := SA1->A1_DTULTIT
			cBmp		:= "BOOM"
			cMotivo	:= "Ja houveram titulos protestados anteriormente."
			lAbreDialogo := .T.
			lAprovado := .f.
		EndIf
	/*/
		If _lQry
			dbSelectArea(cQry)
		Else
			dbSelectArea("SA1")
		Endif
	/*/
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cliente reprovado									   ³
		//³ Motivo: J  houveram cheques devolvidos anteriormente.  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SA1->A1_CHQDEVO > 0
			dChqDevo := SA1->A1_DTULCHQ
			cBmp		:= "BOOM"
			cMotivo	:= "Ja houveram cheques devolvidos anteriormente."
			lAbreDialogo := .T.
			lAprovado := .f.
		Endif

	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para alterar o texto referente a análise de credito do cliente ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l10ImpCli
		cMotivo := ExecBlock( "L10IMPCLx",.F.,.F.,{cMotivo} )
	Endif

// Se deve abrir o dialogo, quer dizer que nao esta sendo chamada
// da funcao LJ010ImpCli
	If lAbreDialogo

		//
		DEFINE MSDIALOG oDlgMotCre FROM 47,130 TO 475,890;
			TITLE OemToAnsi("Analise de Credito") PIXEL Of oDlg

		DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 10,12 BOLD

		// Resultado
		@ 04,41 TO 141,500 LABEL "Resultado" OF oDlgMotCre PIXEL
		@ 13,44 Say OemToAnsi(cMotivo) SIZE 430,27 OF oDlgMotCre PIXEL FONT oFont COLOR CLR_RED

		@ 4,04 BITMAP RESOURCE cBmp OF oDlgMotCre PIXEL SIZE 32,32 ADJUST When .F. NOBORDER

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Botoes para confirmacao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DEFINE SBUTTON FROM 147, 148 oButton2 TYPE 1 ENABLE OF oDlgMotCre ;
			ACTION (oDlgMotCre:End()) PIXEL

		ACTIVATE MSDIALOG oDlgMotCre CENTERED
		oFont:end()

	Else

		cStatus := cMotivo

	EndIf
	cCliAnt := cCliente
	cLojAnt := cLoja

	//dbSelectArea(cQry)
	dbclosearea()

	dbSelectArea(cAlias)

Return lAprovado

/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o	 ³  LjAtraso	³ Autor ³ Adriano Sacomani   ³ Data ³ 27.12.95 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Checar os titulos em aberto(Atrasados) 						  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso		 ³ LojA010 e LojA220 													  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LjAtraso(cCliente, cLoja)
	Local nNumDias := 0
	Local lRet		:= .F.

	If _lQry

		//If !Empty((cqry)->A1_RISCO)
		nNumDias := GetMV("MV_RISCO"+_cRisco)
		//endif

		If Empty(nNumDias)
			nNumDias:=0
			Return .F.
		Endif

		aStru := SE1->(dbstruct())
		cQuery := "SELECT E1_TIPO,E1_VENCREA FROM SE1010 WHERE  "
		cQuery +=       "E1_CLIENTE='"+ccLiente+"' AND "
		cQuery +=       "E1_LOJA='"+cLoja+"' "
		cQuery +=       " AND D_E_L_E_T_<>'*' AND E1_SALDO>0 "
		cQry1   := "SE1010A"
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry1,.F.,.T.)
		TCSETFIELD(cQry1,"E1_VENCREA","D",8,0)

		dbSelectArea(cQry1)
		dbgotop()
		If !eof()
			While !Eof()
				If (cQry1)->E1_TIPO $ MVRECANT+"/"+MVPROVIS+"/"+MV_CRNEG+"/"+MVABATIM
					dbSkip()
					Loop
				Else
					If dDataBase - (cQry1)->E1_VENCREA <= nNumDias
						lRet := .F.
					Else
						lRet := .T.
						Exit
					EndIf
				EndIf
				dbSkip()
			EndDo
		endif
		dbSelectArea(cQry1)
		dbclosearea()
	Else

		If !Empty(SA1->A1_RISCO)
			nNumDias := GetMV("MV_RISCO"+SA1->A1_RISCO)
		endif

		If Empty(nNumDias)
			nNumDias:=0
			Return .F.
		Endif


		dbSelectArea("SE1")
		dbSetOrder(8)
		dbSeek(cFilial+cCliente+cLoja+"A")
		If Found()
			While !Eof() .And. E1_FILIAL == xFilial() .And. E1_CLIENTE+E1_LOJA+E1_STATUS==cCliente+cLoja+"A"
				If SE1->E1_TIPO $ MVRECANT+"/"+MVPROVIS+"/"+MV_CRNEG+"/"+MVABATIM
					dbSkip()
					Loop
				Else
					If dDataBase - E1_VENCREA <= nNumDias
						lRet := .F.
					Else
						lRet := .T.
						Exit
					EndIf
				EndIf
				dbSkip()
			EndDo
		endif

	Endif

Return lRet


/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o	 ³   LjSaldo	³ Autor ³ Adriano Sacomani   ³ Data ³ 27.12.95 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Checar os titulos em aberto										  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso		 ³ LojA010 e LojA220 													  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LjSaldo(cCliente, cLoja,_nVlrTOT,aDados)
	Local lRet		:= .T.
	Local nSaldoE1 := 0
	Local nValor	:=0
	Local cFormPG	:= ALLTRIM(GETMV("MV_FORBLQ"))
	If _lQry

		aStru := SE1->(dbstruct())
		cQuery := "SELECT E1_SALDO,E1_TIPO FROM SE1010 WHERE  "
		cQuery +=       "E1_CLIENTE='"+ccLiente+"' AND "
		cQuery +=       "E1_LOJA='"+cLoja+"' "
		cQuery +=       " AND D_E_L_E_T_<>'*' AND E1_SALDO>0 "
		cQry2   := "SE1010A"
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry2,.F.,.T.)
		TCSETFIELD(cQry2,"E1_SALDO","N",12,2)


		dbSelectArea("SE1010A")
		dbgotop()
		If !eof()
			While !Eof()
				nValor:=SE1010A->E1_SALDO

				If SE1010A->E1_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM
					nSaldoE1 -= nValor
				elseif SE1010A->E1_TIPO $ cFormPG
					nSaldoE1 += nValor
				EndIf
				dbSkip()
			EndDo
		endif

		If _nVlrTot = 0
			adados += "Limite Credito "+transform(SA1->A1_LC,"@e 9,999.99")+chr(13)
			aDados += "Utilizado      "+transform(nSaldoE1,"@e 9,999.99")+chr(13)
			aDados += "Saldo          "+transform(SA1->A1_LC-nSaldoE1,"@e 9,999.99")+chr(13)
			aDados += "PGTO     "+POSICIONE("SE4",1,XFILIAL("SE4")+SA1->A1_COND,"E4_DESCRI")
			_nSaldo := SA1->A1_LC-nSaldoE1
			If (nSaldoE1) > SA1->A1_LC
				_lNoFin := .t.
				lRet    := .F.
			Else
				lRet := .T.
				_lNoFin := .F.
			EndIf
		Endif

		If _nVlrTot > 0
			_nSaldo := SA1->A1_LC
			_nSaldo -= nSaldoE1
			If _nVlrTot > _nSaldo
				adados := ""
				adados += "Limite de Credito "+transform(_nSaldo,"@e 9,999.99")+chr(13)
				adados += "Saldo Disponível  "+transform(_nSaldo,"@e 9,999.99")+chr(13)
				aDados += "Vlr de Compras    "+transform(_nVlrtot,"@e 9,999.99")+chr(13)
//			aDados += "Saldo        "+transform(_nSaldo-_nVlrTot,"@e 9,999.99")+chr(13)
				aDados += "PGTO     "+POSICIONE("SE4",1,XFILIAL("SE4")+M->LQ_CONDPG,"E4_DESCRI")
				lRet := .F.
			Else
				lRet := .t.

			Endif
		Endif


		dbSelectArea(cQry2)
		dbclosearea()
	Else
		dbSelectArea("SE1")
		dbSetOrder(8)
		dbSeek(cFilial+cCliente+cLoja+"A")
		If Found()
			While !Eof() .And. E1_FILIAL == xFilial() .And. E1_CLIENTE+E1_LOJA==cCliente+cLoja ;
					.and. E1_Status == "A"
				nValor:=xMoeda( SE1->E1_SALDO , SE1->E1_MOEDA , 1 )
				If SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM
					nSaldoE1 -= nValor
				Else
					nSaldoE1 += nValor
				EndIf
				dbSkip()
			EndDo
			adados += "Limite Credito "+transform(SA1->A1_LC,"@e 9,999.99")+chr(13)
			aDados += "Utilizado      "+transform(nSaldoE1+_nVlr,"@e 9,999.99")+chr(13)
			aDados += "Saldo          "+transform(SA1->A1_LC-(nSaldoE1+_nVlr),"@e 9,999.99")+chr(13)
			aDados += "PGTO     "+POSICIONE("SE4",1,XFILIAL("SE4")+SA1->A1_COND,"E4_DESCRI")

			If (nSaldoE1+_nVlr) > SA1->A1_LC
				_lNoFin := .t.
				lRet := .F.
			Else
				lRet := .T.
			EndIf
		Endif
	endif


return({lRet,aDados})
