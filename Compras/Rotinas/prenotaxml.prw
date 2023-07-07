/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PRENOTAº Autor ³ Luiz Alberto º Data ³ 29/10/10 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Leitura e Importacao Arquivo XML para geração de Pre-Nota  º±±
±±º          ³                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Pelican Textil                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//-- Ponto de Entrada para incluir botão na Pré-Nota de Entrada

#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"


User Function PreNotaXML


	Local nX := 0
	Private CPERG   	:="NOTAXML"
	Private Caminho 	:= "importadorxml\lidos"
	Private cArqs 		:= "importadorxml\lidos\*.XML"
	Private cCaminho 	:= "importadorxml\lidos"
	Private _cMarca   := GetMark()
	Private aFields   := {}
	Private cArq
	Private aFields2  := {}
	Private cArq2
	Private cCbarra
	Private cEOL := CHR(13)+CHR(10)
	PRIVATE cFile := ""
	PRIVATE cFile2 := ""
	Private cVpNF:= .T.
	Private _lReleitura:=.f.


	aFile := Directory(cArqs)

	nTipo := 1

	cCodBar := Space(100)
	IF FunName()=="SPEDMANIFE"
		cCodBar := C00->C00_CHVNFE
	ENDIF

	DEFINE MSDIALOG _oPT00005 FROM  50, 050 TO 400,500 TITLE OemToAnsi('Automatiza Amarração de Produtos X Fornecedor') PIXEL	// "Movimenta‡„o Banc ria"

	//@ 003,005 Say OemToAnsi("Cod Barra NFE") Size 040,030
	@ 020,005 Say OemToAnsi("Tipo Nota Entrada:") Size 070,030

	//@ 003,060 Get cCodBar  Picture "@!S80" Valid (AchaFile(@cCodBar),If(!Empty(cCodBar),_oPT00005:End(),.t.))  Size 150,030
	@ 020,060 RADIO oTipo VAR nTipo ITEMS "Normal"  SIZE 70,10 OF _oPT00005

	@ 037,005 Say OemToAnsi("Buscar Nota Fiscal") Size 070,030
	@ 037,060 Get cCodBar  F3 "CKOCOL" Size 150,030


	//"Nota Normal","Nota Beneficiamento","Nota Devolução"
	//@ 135,060 Button OemToAnsi("Ler Xml") Size 036,016 Action (GetArq(@cCodBar),_oPT00005:End())
	@ 135,110 Button OemToAnsi("Ok")  Size 036,016 Action (_oPT00005:End())
	@ 135,160 Button OemToAnsi("Sair")   Size 036,016 Action Fecha()

	Activate Dialog _oPT00005 CENTERED

	MV_PAR01 := nTipo

	IF !EMPTY(cCodBar)
		cFile := Padr(alltrim(cCodBar)+".xml",TamSx3("CKO_ARQXML")[1])
		cFile2 := Padr(alltrim(cCodBar)+".XML",TamSx3("CKO_ARQXML")[1])
	ELSE
		MsgInfo("Informe o arquivo a ser tratado.","Atenção")
		Return
	ENDIF

	DbSelectArea("CKO")
	DbsetOrder(5)
	IF DbSeek(cFile)
		cBuffer := CKO->CKO_XMLRET
	ELSEIF DbSeek(cFile2)
		cBuffer := CKO->CKO_XMLRET
	ELSE
		MsgInfo("Arquivo não localizado, verifique se a chave está correta.","Atenção")
		Return
	ENDIF

	cAviso := ""
	cErro  := ""
	oNfe := XmlParser(cBuffer,"_",@cAviso,@cErro)
	Private oNF
	private     _lCte:=.f.

	If Type("oNFe:_NfeProc")<> "U"
		oNF := oNFe:_NFeProc:_NFe
	elseif Type("oNFe:_cteProc")<> "U"
		_lCte:=.t.
		_lTrfArq:=.f.
	Else
		oNF := oNFe:_NFe
	Endif
	If !_lCte

		Private oEmitente  := oNF:_InfNfe:_Emit
		Private oIdent     := oNF:_InfNfe:_IDE
		Private oDestino   := oNF:_InfNfe:_Dest
		Private oTotal     := oNF:_InfNfe:_Total
		Private oTransp    := oNF:_InfNfe:_Transp
		Private oDet       := oNF:_InfNfe:_Det
		Private _cChv       := onf:_infnfe:_id:text
		private _cVersao := oNF:_InfNfe:_versao:text
		Private oICM		:= nil

		If Type("oNF:_InfNfe:_ICMS")<> "U"
			oICM       := oNF:_InfNfe:_ICMS
		Endif
		Private oFatura    := IIf(Type("oNF:_InfNfe:_Cobr")=="U",Nil,oNF:_InfNfe:_Cobr)
		Private cEdit1	   := Space(15)
		Private _DESCdigit := space(55)
		Private _NCMdigit  := space(8)
		Private  cFornecN
		Private  cLojaN
		Private  cNotaN := Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)
		Private  cNfinnfe := Alltrim(OIdent:_finNFe:TEXT)
		Private _lAtuTodos := .F.



		Private  cSerieN:= IIF(VAL(OIdent:_serie:TEXT)==0,"000",Padr(OIdent:_serie:TEXT,3))
		Private  cDesconto:= Val(oNF:_InfNfe:_total:_ICMSTot:_vDesc:TEXT)

		oDet := IIf(ValType(oDet)=="O",{oDet},oDet)
		// Validações -------------------------------
		// -- CNPJ da NOTA = CNPJ do CLIENTE ? oEmitente:_CNPJ
		If cNfinnfe = "1" //.and. nTipo = 1
			cTipo := "N"
		ElseIF MV_PAR01 = 2 //9.or. ntipo = 2
			cTipo := "B"
		ElseIF cNfinnfe = "4"
			cTipo := "D"
		Endif


		// CNPJ ou CPF

		cCgc := AllTrim(IIf(Type("oEmitente:_CPF")=="U",oEmitente:_CNPJ:TEXT,oEmitente:_CPF:TEXT))

		If cNfinnfe <> "4" // Nota Normal Fornecedor
			If !SA2->(dbSetOrder(3), dbSeek(xFilial("SA2")+cCgc))
				MsgAlert("CNPJ Origem Não Localizado - Verifique " + cCgc)
				Return
			Endif
			cFornecN:= SA2->A2_COD
			cLojaN  := SA2->A2_LOJA
		Else
			If !SA1->(dbSetOrder(3), dbSeek(xFilial("SA1")+cCgc))
				MsgAlert("CNPJ Origem Não Localizado - Verifique " + cCgc)
				Return
			Endif
		Endif


		public	aItens := {}


		_cChv := strtran(_cChv,"NFe","")


		_lTrfArq=.t.

		For nX := 1 To Len(oDet)
			cEdit1 := Space(15)
			_DESCdigit :=space(55)
			_NCMdigit  :=space(8)

			cProduto:=PadR(AllTrim(oDet[nX]:_Prod:_cProd:TEXT),20)
			xProduto:=cProduto
			_cCodBar := PadR(AllTrim(oDet[nX]:_Prod:_cEan:TEXT),15)
			_cCodbar := iF(LEFT(_cCodBar,1)="0",PADR(SUBSTR(_cCodBar,2,14),15),_cCodBar)
			cNCM:=oDet[nX]:_Prod:_NCM:TEXT

			oDetICMS := oDet[nX]:_Imposto:_ICMS
			_Origem := ""
			if type('oDetICMS:_ICMS00:_ORIG:TEXT') <>"U"
				_Origem := oDetICMS:_ICMS00:_ORIG:TEXT
			elseif type('oDetICMS:_ICMS10:_ORIG:TEXT') <>"U"
				_Origem := oDetICMS:_ICMS10:_ORIG:TEXT
			elseif type('oDetICMS:_ICMS20:_ORIG:TEXT') <>"U"
				_Origem := oDetICMS:_ICMS20:_ORIG:TEXT
			elseif type('oDetICMS:_ICMS40:_ORIG:TEXT') <>"U"
				_Origem := oDetICMS:_ICMS40:_ORIG:TEXT
			elseif type('oDetICMS:_ICMS41:_ORIG:TEXT') <>"U"
				_Origem := oDetICMS:_ICMS41:_ORIG:TEXT
			elseif type('oDetICMS:_ICMS50:_ORIG:TEXT') <>"U"
				_Origem := oDetICMS:_ICMS50:_ORIG:TEXT
			elseif type('oDetICMS:_ICMS51:_ORIG:TEXT') <>"U"
				_Origem := oDetICMS:_ICMS51:_ORIG:TEXT
			elseif type('oDetICMS:_ICMS60:_ORIG:TEXT') <>"U"
				_Origem := oDetICMS:_ICMS60:_ORIG:TEXT
			elseif type('oDetICMS:_ICMS90:_ORIG:TEXT') <>"U"
				_Origem := oDetICMS:_ICMS90:_ORIG:TEXT
			endif

			Chkproc=.F.
			SLK->(dbsetorder(1))
			IF SLK->(Dbseek(xFilial("SLK")+_cCodBar))
				cEdit1:= SLK->LK_CODIGO
				SB1->(dbsetorder(1))
				IF SB1->(Dbseek(xFilial("SB1")+cEdit1))
					_DESCdigit := SB1->B1_DESC
				ENDIF
			ELSE
				SB1->(dbsetorder(5))
				IF SB1->(Dbseek(xFilial("SB1")+_cCodBar))
					cEdit1:= SB1->B1_COD
					_DESCdigit := SB1->B1_DESC
				ENDIF
			ENDIF
			If cNfinnfe <> '4'

				SA5->(DbsetOrder(14))   // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR
				If !SA5->(dbSeek(xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+cProduto))
					If !MsgYesNo ("Produto Cod.: "+cProduto+" Nao Encontrado. Digita Codigo de Substituicao?")
						Return Nil
					Endif
					_lTrfArq=.f.
					cCbarra := _cCodBar
					_NvALOR := 0
					DEFINE MSDIALOG _oDlg TITLE "Dig.Cod.Substituicao" FROM C(177),C(192) TO C(500),C(659) PIXEL

					// Cria as Groups do Sistema
					@ C(002),C(003) TO C(071),C(286) LABEL "Dig.Cod.Substituicao " PIXEL OF _oDlg

					// Cria Componentes Padroes do Sistema
					@ C(012),C(027) Say "Produto: "+cProduto+" - NCM: "+cNCM Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(020),C(027) Say "Descricao: "+oDet[nX]:_Prod:_xProd:TEXT Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1PER" Valid(ExistCpo("SB1",cEdit1)) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(040),C(027) Say "Produto digitado: "+cEdit1+" - NCM: "+_NCMdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(048),C(027) Say "Descricao: "+_DESCdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(060),C(027) Say "Fator: " Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(060),C(047) MsGet oNVALOR Var _NVALOR PICTURE "@E 9999.999" Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg

					@ C(004),C(194) Button "Processar" Size C(037),C(012) PIXEL OF _oDlg Action(Troca())
					@ C(025),C(194) Button "Cancelar" Size C(037),C(012) PIXEL OF _oDlg Action(_oDlg:End())
					oEdit1:SetFocus()

					ACTIVATE MSDIALOG _oDlg CENTERED
					If Chkproc!=.T.
						MsgAlert("Produto Cod.: "+cProduto+" Nao Encontrado. A Importacao sera interrompida")
						Return Nil
					Else
						If SA5->(dbSetOrder(1), dbSeek(xFilial("SA5")+SA2->A2_COD+SA2->A2_LOJA+SB1->B1_COD))
							RecLock("SA5",.f.)
						Else
							Reclock("SA5",.t.)
						Endif

						SA5->A5_FILIAL  := xFilial("SA5")
						SA5->A5_FORNECE := SA2->A2_COD
						SA5->A5_LOJA 	:= SA2->A2_LOJA
						SA5->A5_NOMEFOR := SA2->A2_NOME
						SA5->A5_PRODUTO := SB1->B1_COD
						SA5->A5_NOMPROD := oDet[nX]:_Prod:_xProd:TEXT
						SA5->A5_CODPRF  := xProduto
						SA5->A5_CODBAR  := cCbarra


						SA5->(MsUnlock())
						SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))

						If !Empty(cNCM) .and. alltrim(SB1->B1_POSIPI) <> cNCM
							IF !_lAtuTodos
								RetAviso := Aviso('NCM encontrado no XML'+cNCM+", é diferente do cadastrado no produto: "+alltrim(SB1->B1_POSIPI),'Deseja Alterar?',{'Nao','Sim',"Sim para todos"})
								IF	RetAviso == 3
									_lAtuTodos := .T.
								ENDIF
							ENDIF
							IF RetAviso <> 1 .OR. _lAtuTodos
								RecLock("SB1",.F.)
								Replace B1_POSIPI with cNCM

								IF !EMPTY(_Origem)
									Replace B1_ORIGEM with _Origem
								endif

								MSUnLock()
							endif
						Endif


					EndIf
				Else
					SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))

					If !Empty(cNCM) .And. alltrim(SB1->B1_POSIPI) <> cNCM
						IF !_lAtuTodos
							RetAviso := Aviso('NCM encontrado no XML'+cNCM+", é diferente do cadastrado no produto: "+alltrim(SB1->B1_POSIPI),'Deseja Alterar?',{'Nao','Sim',"Sim para todos"})
							IF	RetAviso == 3
								_lAtuTodos := .T.
							ENDIF
						ENDIF
						IF RetAviso <> 1 .OR. _lAtuTodos
							RecLock("SB1",.F.)
							Replace B1_POSIPI with cNCM
							IF !EMPTY(_Origem)
								Replace B1_ORIGEM with _Origem
							endif
							MSUnLock()
						endif
					Endif
				Endif
			Else

				//			SA7->(DbOrderNickName("CLIPROD"))   // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR
				SA7->(DbsetOrder(1))   // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR

				If !SA7->(dbSeek(xFilial("SA7")+SA1->A1_COD+SA1->A1_LOJA+cProduto))
					If !MsgYesNo ("Produto Cod.: "+cProduto+" Nao Encontrado. Digita Codigo de Substituicao?")
						Return Nil
					Endif
					DEFINE MSDIALOG _oDlg TITLE "Dig.Cod.Substituicao" FROM C(177),C(192) TO C(509),C(659) PIXEL

					// Cria as Groups do Sistema
					@ C(002),C(003) TO C(071),C(186) LABEL "Dig.Cod.Substituicao " PIXEL OF _oDlg

					// Cria Componentes Padroes do Sistema
					@ C(012),C(027) Say "Produto: "+cProduto+" - NCM: "+cNCM Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(020),C(027) Say "Descricao: "+oDet[nX]:_Prod:_xProd:TEXT Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ExistCpo("SB1",cEdit1)) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(040),C(027) Say "Produto digitado: "+cEdit1+" - NCM: "+_NCMdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(048),C(027) Say "Descricao: "+_DESCdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
					@ C(004),C(194) Button "Processar" Size C(037),C(012) PIXEL OF _oDlg Action(Troca())
					@ C(025),C(194) Button "Cancelar" Size C(037),C(012) PIXEL OF _oDlg Action(_oDlg:End())
					oEdit1:SetFocus()

					ACTIVATE MSDIALOG _oDlg CENTERED
					If Chkproc!=.T.
						MsgAlert("Produto Cod.: "+cProduto+" Nao Encontrado. A Importacao sera interrompida")
						Return Nil
					Else
						If SA7->(dbSetOrder(1), dbSeek(xFilial("SA7")+SA1->A1_COD+SA1->A1_LOJA+SB1->B1_COD))
							RecLock("SA7",.f.)
						Else
							Reclock("SA7",.t.)
						Endif

						SA7->A7_FILIAL := xFilial("SA7")
						SA7->A7_CLIENTE := SA1->A1_COD
						SA7->A7_LOJA 	:= SA1->A1_LOJA
						SA7->A7_DESCCLI := oDet[nX]:_Prod:_xProd:TEXT
						SA7->A7_PRODUTO := SB1->B1_COD
						SA7->A7_CODCLI  := xProduto
						SA7->(MsUnlock())

					EndIf
				Else
					SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SA7->A7_PRODUTO))
					If !Empty(cNCM) .and. cNCM != '00000000' .And. alltrim(SB1->B1_POSIPI) <> cNCM
						RecLock("SB1",.F.)
						Replace B1_POSIPI with cNCM
						IF !EMPTY(_Origem)
							Replace B1_ORIGEM with _Origem
						endif
						MSUnLock()
					Endif
				Endif
			Endif

			SB1->(dbSetOrder(1))


		Next nX
	ENDIF

	DbSelectArea("CKO")
	RecLock("CKO",.F.)
	CKO->CKO_FLAG := "0"
	CKO->CKO_STATUS := "0"
	MSUnLock()

	MsgInfo("Nota Fiscal enviada para fila de processamento, verifique no monitor.","Produtos X Fornecedor Realizado.")

Return


Static Function C(nTam)
	Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)



Static Function Troca()
	Chkproc=.T.

	if empty(cEdit1)
		_oDlg:End()
		Return
	endif

	cProduto=cEdit1
	If !Empty(cNCM) .and. cNCM != '00000000' .and.  empty(SB1->B1_POSIPI) //Emerson Holanda alterar o ncm se houver discrepancia
		RecLock("SB1",.F.)
		Replace B1_POSIPI with cNCM
		IF !EMPTY(_Origem)
			Replace B1_ORIGEM with _Origem
		endif
		MSUnLock()
	Endif

	_oDlg:End()
Return


StatiC Function Fecha()
	Close(_oPT00005)
Return
