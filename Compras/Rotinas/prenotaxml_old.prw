/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ PRENOTAบ Autor ณ Luiz Alberto บ Data ณ 29/10/10 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Leitura e Importacao Arquivo XML para gera็ใo de Pre-Nota  บฑฑ
ฑฑบ          ณ                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Pelican Textil                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//-- Ponto de Entrada para incluir botใo na Pr้-Nota de Entrada

#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"


User Function PreNotaXML

	Local nX
	Local nI
//Local aTipo			:={'N','B','D'}
	Local cFile 		:= Space(10)
	Private CPERG   	:="NOTAXML"
	Private Caminho 	:= "\importadorxml\cfg\"
	Private cArqs 		:= "\importadorxml\cfg\*.XML"
	Private cCaminho 	:= "\importadorxml\cfg"
	Private _cMarca   := GetMark()
	Private aFields   := {}
	Private cArq
	Private aFields2  := {}
	Private cArq2
	Private lPcNfe		:= GETMV("MV_PCNFE")
	Private cCbarra
	Private cEOL := CHR(13)+CHR(10)
	PRIVATE cFile	
	Private cVpNF:= .T.
	Private _lReleitura:=.f.


	u_ufunzip()

	aFile := Directory(cArqs)
	PutMV("MV_PCNFE",.f.)

	nTipo := 1
	Do While .T.
		cCodBar := Space(100)
		ccond := space(3)

		DEFINE MSDIALOG _oPT00005 FROM  50, 050 TO 400,500 TITLE OemToAnsi('Busca de XML de Notas Fiscais de Entrada') PIXEL	// "Movimentao Banc ria"

		@ 003,005 Say OemToAnsi("Cod Barra NFE") Size 040,030
		@ 020,005 Say OemToAnsi("Tipo Nota Entrada:") Size 070,030

		@ 003,060 Get cCodBar  Picture "@!S80" Valid (AchaFile(@cCodBar),If(!Empty(cCodBar),_oPT00005:End(),.t.))  Size 150,030
		@ 020,060 RADIO oTipo VAR nTipo ITEMS "Normal"  SIZE 70,10 OF _oPT00005

		@ 037,005 Say OemToAnsi("Cond Pagamento") Size 070,030
		@ 037,100 Get cCond  F3 "SE4" Size 30,009

		//	@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ValProd()) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg


		//"Nota Normal","Nota Beneficiamento","Nota Devolu็ใo"
		@ 135,060 Button OemToAnsi("Importar Xml") Size 036,016 Action (GetArq(@cCodBar),_oPT00005:End())
		@ 135,110 Button OemToAnsi("Ok")  Size 036,016 Action (_oPT00005:End())
		@ 135,160 Button OemToAnsi("Sair")   Size 036,016 Action Fecha()

		Activate Dialog _oPT00005 CENTERED

		MV_PAR01 := nTipo

		cFile := cCodBar

		if _lReleitura
			return()
		endif

		If !File(cFile) .and. !Empty(cFile)
			MsgAlert("Arquivo Nใo Encontrado no Local de Origem Indicado!")
			PutMV("MV_PCNFE",lPcNfe)
			Return
		Endif

		Private nHdl    := fOpen(cFile,0)


		aCamposPE:={}

		If nHdl == -1
			If !Empty(cFile)
				MsgAlert("O arquivo de nome "+cFile+" nao pode ser aberto! Verifique os parametros.","Atencao!")
			Endif
			PutMV("MV_PCNFE",lPcNfe)
			Return
		Endif
		nTamFile := fSeek(nHdl,0,2)
		fSeek(nHdl,0,0)
		cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
		nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
		fClose(nHdl)

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
//	Private _cChv       := onf:_infnfe:_id:text
			private _cVersao := oNF:_InfNfe:_versao:text
			Private oICM       := nil

			If Type("oNF:_InfNfe:_ICMS")<> "U"
				oICM       := oNF:_InfNfe:_ICMS
			Else
			    oICM		:= nil
			Endif
			Private oFatura    := IIf(Type("oNF:_InfNfe:_Cobr")=="U",Nil,oNF:_InfNfe:_Cobr)
			Private cEdit1	   := Space(15)
			Private _DESCdigit := space(55)
			Private _NCMdigit  := space(8)
			Private  cFornecN
			Private  cLojaN
			Private  cNotaN := Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)
			Private  cNfinnfe := Alltrim(OIdent:_finNFe:TEXT)



			Private  cSerieN:= IIF(VAL(OIdent:_serie:TEXT)==0,"000",Padr(OIdent:_serie:TEXT,3))
			Private  cDesconto:= Val(oNF:_InfNfe:_total:_ICMSTot:_vDesc:TEXT)

			oDet := IIf(ValType(oDet)=="O",{oDet},oDet)
			// Valida็๕es -------------------------------
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
					MsgAlert("CNPJ Origem Nใo Localizado - Verifique " + cCgc)
					PutMV("MV_PCNFE",lPcNfe)
					Return
				Endif
				cFornecN:= SA2->A2_COD
				cLojaN  := SA2->A2_LOJA
			Else
				If !SA1->(dbSetOrder(3), dbSeek(xFilial("SA1")+cCgc))
					MsgAlert("CNPJ Origem Nใo Localizado - Verifique " + cCgc)
					PutMV("MV_PCNFE",lPcNfe)
					Return
				Endif
			Endif

			// -- Nota Fiscal jแ existe na base ?
			If SF1->(DbSeek(XFilial("SF1")+Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)+IIF(VAL(OIdent:_serie:TEXT)==0,"001",Padr(OIdent:_serie:TEXT,3))+SA2->A2_COD+SA2->A2_LOJA))
				IF MV_PAR01 = 1
					MsgAlert("Nota No.: "+Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)+"/"+IIF(VAL(OIdent:_serie:TEXT)==0,"001",Padr(OIdent:_serie:TEXT,3))+" do Fornec. "+SA2->A2_COD+"/"+SA2->A2_LOJA+" Ja Existe. A Importacao sera interrompida")
				Else
					MsgAlert("Nota No.: "+Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)+"/"+IIF(VAL(OIdent:_serie:TEXT)==0,"001",Padr(OIdent:_serie:TEXT,3))+" do Cliente "+SA1->A1_COD+"/"+SA1->A1_LOJA+" Ja Existe. A Importacao sera interrompida")
				Endif
				PutMV("MV_PCNFE",lPcNfe)
				Return Nil
			EndIf

			aCabec := {}
			public	aItens := {}
			aadd(aCabec,{"F1_TIPO"   ,If(MV_PAR01==1,"N",If(MV_PAR01==2,'B','D')),Nil,Nil})
			aadd(aCabec,{"F1_FORMUL" ,"N",Nil,Nil})
			aadd(aCabec,{"F1_DOC"    ,Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9),Nil,Nil})
			If VAL(OIdent:_serie:TEXT) = 0
				aadd(aCabec,{"F1_SERIE"  ,"001",Nil,Nil})
			Else
				aadd(aCabec,{"F1_SERIE"  ,OIdent:_serie:TEXT,Nil,Nil})
			Endif

			if _cVersao = "3.10" .OR. _cVersao = "4.00"
				cData:=Alltrim(OIdent:_dhEmi:TEXT)
				dData:=CTOD(SUBSTR(cData,9,2)+'/'+Substr(cData,6,2)+'/'+Left(cData,4))
			else
				cData:=Alltrim(OIdent:_dEmi:TEXT)
				dData:=CTOD(Right(cData,2)+'/'+Substr(cData,6,2)+'/'+Left(cData,4))
			endif
			aadd(aCabec,{"F1_EMISSAO",dData,Nil,Nil})
			aadd(aCabec,{"F1_FORNECE",If(MV_PAR01=1,SA2->A2_COD,SA1->A1_COD),Nil,Nil})
			aadd(aCabec,{"F1_LOJA"   ,If(MV_PAR01=1,SA2->A2_LOJA,SA1->A1_LOJA),Nil,Nil})
			aadd(aCabec,{"F1_ESPECIE","SPED",Nil,Nil})
			aadd(aCabec,{"F1_COND",iif(!empty(cCond),cCond,SA2->A2_COND),Nil,Nil})
			_cChv := strtran(_cChv,"NFe","")
			aadd(aCabec,{"F1_CHVNFE",_cChv,Nil,Nil})
			_lCerpa := .f.

			cProds := ''
			aPedIte:={}
			_lTrfArq=.t.

			For nX := 1 To Len(oDet)
				cEdit1 := Space(15)
				_DESCdigit :=space(55)
				_NCMdigit  :=space(8)

				cProduto:=PadR(AllTrim(oDet[nX]:_Prod:_cProd:TEXT),20)
				xProduto:=cProduto
				_cCodBar := PadR(AllTrim(oDet[nX]:_Prod:_cEan:TEXT),15)
				_cCodbar := iF(LEFT(_cCodBar,1)="0",PADR(SUBSTR(_cCodBar,2,14),15),_cCodBar)
				cNCM:=IIF(Type("oDet[nX]:_Prod:_NCM")=="U",space(12),oDet[nX]:_Prod:_NCM:TEXT)
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
							PutMV("MV_PCNFE",lPcNfe)
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
//						@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ExistCpo("SB1",cEdit1)) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
//						@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ExistCpo("SB1",cEdit1)) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
						@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ValProd()) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg

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
							PutMV("MV_PCNFE",lPcNfe)
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
//					SA5->A5_CONVXML := _NVALOR

							SA5->(MsUnlock())
							SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))

							If !Empty(cNCM) .and. cNCM != '00000000' .And. SB1->B1_POSIPI <> cNCM
								IF Aviso('NCM DIVERGENTE DO XML COM O CADASTRO DO PRODUTO','Deseja Alterar?',{'Nao','Sim'}) == 2
									RecLock("SB1",.F.)
									Replace B1_POSIPI with cNCM
									MSUnLock()
								endif
							Endif


						EndIf
					Else
						SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))

						If !Empty(cNCM) .and. cNCM != '00000000' .And. SB1->B1_POSIPI <> cNCM
							IF Aviso('NCM DIVERGENTE DO XML COM O CADASTRO DO PRODUTO','Deseja Alterar?',{'Nao','Sim'}) == 2
								RecLock("SB1",.F.)
								Replace B1_POSIPI with cNCM
								MSUnLock()
							endif
						Endif
					Endif
				Else

					//			SA7->(DbOrderNickName("CLIPROD"))   // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR
					SA7->(DbsetOrder(1))   // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR

					If !SA7->(dbSeek(xFilial("SA7")+SA1->A1_COD+SA1->A1_LOJA+cProduto))
						If !MsgYesNo ("Produto Cod.: "+cProduto+" Nao Encontrado. Digita Codigo de Substituicao?")
							PutMV("MV_PCNFE",lPcNfe)
							Return Nil
						Endif
						DEFINE MSDIALOG _oDlg TITLE "Dig.Cod.Substituicao" FROM C(177),C(192) TO C(509),C(659) PIXEL

						// Cria as Groups do Sistema
						@ C(002),C(003) TO C(071),C(186) LABEL "Dig.Cod.Substituicao " PIXEL OF _oDlg

						// Cria Componentes Padroes do Sistema
						@ C(012),C(027) Say "Produto: "+cProduto+" - NCM: "+cNCM Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
						@ C(020),C(027) Say "Descricao: "+oDet[nX]:_Prod:_xProd:TEXT Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
//						@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ExistCpo("SB1",cEdit1)) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
						@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ValProd()) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg

						@ C(040),C(027) Say "Produto digitado: "+cEdit1+" - NCM: "+_NCMdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
						@ C(048),C(027) Say "Descricao: "+_DESCdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
						@ C(004),C(194) Button "Processar" Size C(037),C(012) PIXEL OF _oDlg Action(Troca())
						@ C(025),C(194) Button "Cancelar" Size C(037),C(012) PIXEL OF _oDlg Action(_oDlg:End())
						oEdit1:SetFocus()

						ACTIVATE MSDIALOG _oDlg CENTERED
						If Chkproc!=.T.
							MsgAlert("Produto Cod.: "+cProduto+" Nao Encontrado. A Importacao sera interrompida")
							PutMV("MV_PCNFE",lPcNfe)
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
						If !Empty(cNCM) .and. cNCM != '00000000' .And. SB1->B1_POSIPI <> cNCM
							RecLock("SB1",.F.)
							Replace B1_POSIPI with cNCM
							MSUnLock()
						Endif
					Endif
				Endif

				SB1->(dbSetOrder(1))

				cProds += ALLTRIM(SB1->B1_COD)+'/'



/*		IF SA5->A5_CONVXML > 0
			AAdd(aPedIte,{SB1->B1_COD,Val(oDet[nX]:_Prod:_qTrib:TEXT)*SA5->A5_CONVXML,Round(Val(oDet[nX]:_Prod:_vProd:TEXT)/(Val(oDet[nX]:_Prod:_qTrib:TEXT)*SA5->A5_CONVXML),6),Val(oDet[nX]:_Prod:_vProd:TEXT)})
		ELSE*/
			AAdd(aPedIte,{SB1->B1_COD,Val(oDet[nX]:_Prod:_qTrib:TEXT),Round(Val(oDet[nX]:_Prod:_vProd:TEXT)/Val(oDet[nX]:_Prod:_qTrib:TEXT),6),Val(oDet[nX]:_Prod:_vProd:TEXT)})
//		endif
		
	Next nX
 

    _lTrfArq=.t.
	
	For nX := 1 To Len(oDet)
		cEdit1 := Space(15)
		_DESCdigit :=space(55)
		_NCMdigit  :=space(8)
		
		cProduto:=PadR(AllTrim(oDet[nX]:_Prod:_cProd:TEXT),20)
		xProduto:=cProduto
		_cCodBar := PadR(AllTrim(oDet[nX]:_Prod:_cEan:TEXT),15)
		_cCodbar := iF(LEFT(_cCodBar,1)="0",PADR(SUBSTR(_cCodBar,2,14),15),_cCodBar)
		cNCM:=IIF(Type("oDet[nX]:_Prod:_NCM")=="U",space(12),oDet[nX]:_Prod:_NCM:TEXT)
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
					PutMV("MV_PCNFE",lPcNfe)
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
//				@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ExistCpo("SB1",cEdit1)) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
				@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ValProd()) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg

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
					PutMV("MV_PCNFE",lPcNfe)
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
//					SA5->A5_CONVXML := _NVALOR
					
					SA5->(MsUnlock())
					SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))
					
					If !Empty(cNCM) .and. cNCM != '00000000' .And. SB1->B1_POSIPI <> cNCM
						IF Aviso('NCM DIVERGENTE DO XML COM O CADASTRO DO PRODUTO','Deseja Alterar?',{'Nao','Sim'}) == 2
							RecLock("SB1",.F.)
	  						Replace B1_POSIPI with cNCM
							MSUnLock()     
						endif
					Endif
					
					
				EndIf
			Else
				SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))
				
				If !Empty(cNCM) .and. cNCM != '00000000' .And. SB1->B1_POSIPI <> cNCM
						IF Aviso('NCM DIVERGENTE DO XML COM O CADASTRO DO PRODUTO','Deseja Alterar?',{'Nao','Sim'}) == 2
							RecLock("SB1",.F.)
	  						Replace B1_POSIPI with cNCM
							MSUnLock()     
						endif
				Endif
			Endif
		Else
			
			//			SA7->(DbOrderNickName("CLIPROD"))   // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR
			SA7->(DbsetOrder(1))   // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR
			
			If !SA7->(dbSeek(xFilial("SA7")+SA1->A1_COD+SA1->A1_LOJA+cProduto))
				If !MsgYesNo ("Produto Cod.: "+cProduto+" Nao Encontrado. Digita Codigo de Substituicao?")
					PutMV("MV_PCNFE",lPcNfe)
					Return Nil
				Endif
				DEFINE MSDIALOG _oDlg TITLE "Dig.Cod.Substituicao" FROM C(177),C(192) TO C(509),C(659) PIXEL
				
				// Cria as Groups do Sistema
				@ C(002),C(003) TO C(071),C(186) LABEL "Dig.Cod.Substituicao " PIXEL OF _oDlg
				
				// Cria Componentes Padroes do Sistema
				@ C(012),C(027) Say "Produto: "+cProduto+" - NCM: "+cNCM Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
				@ C(020),C(027) Say "Descricao: "+oDet[nX]:_Prod:_xProd:TEXT Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
//				@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ExistCpo("SB1",cEdit1)) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
				@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ValProd()) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg

				@ C(040),C(027) Say "Produto digitado: "+cEdit1+" - NCM: "+_NCMdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
				@ C(048),C(027) Say "Descricao: "+_DESCdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
				@ C(004),C(194) Button "Processar" Size C(037),C(012) PIXEL OF _oDlg Action(Troca())
				@ C(025),C(194) Button "Cancelar" Size C(037),C(012) PIXEL OF _oDlg Action(_oDlg:End())
				oEdit1:SetFocus()
				
				ACTIVATE MSDIALOG _oDlg CENTERED
				If Chkproc!=.T.
					MsgAlert("Produto Cod.: "+cProduto+" Nao Encontrado. A Importacao sera interrompida")
					PutMV("MV_PCNFE",lPcNfe)
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
				If !Empty(cNCM) .and. cNCM != '00000000' .And. SB1->B1_POSIPI <> cNCM
					RecLock("SB1",.F.)
					Replace B1_POSIPI with cNCM
					MSUnLock()
				Endif
			Endif
		Endif

		SB1->(dbSetOrder(1))
		
		cProds += ALLTRIM(SB1->B1_COD)+'/'
		
		
		
/*		IF SA5->A5_CONVXML > 0
			AAdd(aPedIte,{SB1->B1_COD,Val(oDet[nX]:_Prod:_qTrib:TEXT)*SA5->A5_CONVXML,Round(Val(oDet[nX]:_Prod:_vProd:TEXT)/(Val(oDet[nX]:_Prod:_qTrib:TEXT)*SA5->A5_CONVXML),6),Val(oDet[nX]:_Prod:_vProd:TEXT)})
		ELSE*/
			AAdd(aPedIte,{SB1->B1_COD,Val(oDet[nX]:_Prod:_qTrib:TEXT),Round(Val(oDet[nX]:_Prod:_vProd:TEXT)/Val(oDet[nX]:_Prod:_qTrib:TEXT),6),Val(oDet[nX]:_Prod:_vProd:TEXT)})
//		endif
		
	Next nX
    endif

    If _lTrfArq .or. _lCte
 
        cDirdes   := SuperGetMV('MV_NGINN', .F., '')
        cDirSrv   := "\importadorxml\cfg\"

        cDirSrv   := Alltrim(cDirSrv) 
        cDirdes   := Alltrim(cDirdes)+"\"
        
 //       cDirSrv   := strtran(Alltrim(cDirSrv) ,"\","/")
   //     cDirdes   := strtran((Alltrim(cDirdes) + "\"),"\","/")

        //Monta um array com todos os arquivos GZ
        aArquivos := Directory(cFile) 
            
        //Percorre todos os arquivos descompactando
        For nI := 1 To len(aArquivos)

				cArquivo := aArquivos[nI,1]
				cArqOri := Alltrim(cDirSrv) + alltrim(cArquivo)
            	cArqDest := Alltrim(cDirdes) + alltrim(cArquivo)
 
				if __CopyFile( cArqOri, cArqDest,,,.T.)
                //    FErase( cDirdes +  cArqSemExt )
                //    FErase( cDirSrv +  cArquivo )
                EndIf
            
        Next
    
		MsgInfo("Arquivo encontrado com sucesso, Favor verificar o Monitor!")

    Endif


enddo


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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTratamento para tema "Flat"ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)


Static Function ValProd()

cEdit1 := U_LJCONPRD(cEdit1,1)


_DESCdigit=Alltrim(GetAdvFVal("SB1","B1_DESC",XFilial("SB1")+cEdit1,1,""))
_NCMdigit=GetAdvFVal("SB1","B1_POSIPI",XFilial("SB1")+cEdit1,1,"")


// Procura nota sem preficacao
_aNota:={}
dbSelectArea("SB1")
dbSetOrder(1)
IF !Dbseek(xFilial("SB1")+cEdit1)
	MsgInfo("Produto Inexistente")
	Chkproc=.F.
	_oDlg:End()
	return
ENDIF

Return	ExistCpo("SB1")


Static Function Troca()
	Chkproc=.T.

	cProduto=cEdit1
	If Empty(SB1->B1_POSIPI) .and. !Empty(cNCM) .and. cNCM != '00000000' //Emerson Holanda alterar o ncm se houver discrepancia
		RecLock("SB1",.F.)
		Replace B1_POSIPI with cNCM
		MSUnLock()
	Endif

	_oDlg:End()
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChk_File  บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChamado pelo grupo de perguntas EESTR1			          บฑฑ
ฑฑบ          ณVerifica se o arquivo em &cVar_MV (MV_PAR06..NN) existe.    บฑฑ
ฑฑบ          ณSe nใo existir abre janela de busca e atribui valor a       บฑฑ
ฑฑบ          ณvariavel Retorna .T.										  บฑฑ
ฑฑบ          ณSe usuแrio cancelar retorna .F.							  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณTexto da Janela		                                      บฑฑ
ฑฑบ          ณVariavel entre aspas.                                       บฑฑ
ฑฑบ          ณEx.: Chk_File("Arquivo Destino","mv_par06")                 บฑฑ
ฑฑบ          ณVerificaSeExiste? Logico - Verifica se arquivo existe ou    บฑฑ
ฑฑบ          ณnao - Indicado para utilizar quando o arquivo eh novo.      บฑฑ
ฑฑบ          ณEx. Arqs. Saida.                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Chk_F(cTxt, cVar_MV, lChkExiste)
	Local lExiste := File(&cVar_MV)
	Local cTipo := "Arquivos XML   (*.XML)  | *.XML | Todos os Arquivos (*.*)    | *.* "
	Local cArquivo := ""

//Verifica se arquivo nใo existe
	If lExiste == .F. .or. !lChkExiste
		cArquivo := cGetFile( cTipo,OemToAnsi(cTxt))
		If !Empty(cArquivo)
			lExiste := .T.
			&cVar_Mv := cArquivo
		Endif
	Endif
Return (lExiste .or. !lChkExiste)

	******************************************
Static Function MarcarTudo()
	DbSelectArea('TC9')
	dbGoTop()
	While !Eof()
		MsProcTxt('Aguarde...')
		RecLock('TC9',.F.)
		TC9->T9_OK := _cMarca
		MsUnlock()
		DbSkip()
	EndDo
	DbGoTop()
	DlgRefresh(oDlgPedidos)
	SysRefresh()
Return(.T.)

	******************************************
Static Function DesmarcaTudo()
	DbSelectArea('TC9')
	dbGoTop()
	While !Eof()
		MsProcTxt('Aguarde...')
		RecLock('TC9',.F.)
		TC9->T9_OK := ThisMark()
		MsUnlock()
		DbSkip()
	EndDo
	DbGoTop()
	DlgRefresh(oDlgPedidos)
	SysRefresh()
Return(.T.)


	******************************************
Static Function Marcar()
	DbSelectArea('TC9')
	RecLock('TC9',.F.)
	If Empty(TC9->T9_OK)
		TC9->T9_OK := _cMarca
	Endif
	MsUnlock()
	SysRefresh()
Return(.T.)

	******************************************************
Static FUNCTION Cria_TC9()

	If Select("TC9") <> 0
		TC9->(dbCloseArea())
	Endif
	If Select("TC8") <> 0
		TC8->(dbCloseArea())
	Endif


	aFields   := {}
	AADD(aFields,{"T9_OK"     ,"C",02,0})
	AADD(aFields,{"T9_PEDIDO" ,"C",06,0})
	AADD(aFields,{"T9_ITEM"   ,"C",04,0})
	AADD(aFields,{"T9_PRODUTO","C",15,0})
	AADD(aFields,{"T9_DESC"   ,"C",40,0})
	AADD(aFields,{"T9_UM"     ,"C",02,0})
	AADD(aFields,{"T9_QTDE"   ,"N",12,2})
	AADD(aFields,{"T9_UNIT"   ,"N",12,7})
	AADD(aFields,{"T9_TOTAL"  ,"N",14,2})
	AADD(aFields,{"T9_DTPRV"  ,"D",08,0})
	AADD(aFields,{"T9_ALMOX"  ,"C",04,0})
	AADD(aFields,{"T9_OBSERV" ,"C",30,0})
	AADD(aFields,{"T9_CCUSTO" ,"C",06,0})
	AADD(aFields,{"T9_SALDO"  ,"N",14,2})
	AADD(aFields,{"T9_REG" ,"N",10,0})

	cArq:=Criatrab(aFields,.T.)
	DBUSEAREA(.t.,,cArq,"TC9")

	aFields2   := {}
	AADD(aFields2,{"T8_NOTA" ,"C",09,0})
	AADD(aFields2,{"T8_SERIE"   ,"C",03,0})
	AADD(aFields2,{"T8_PRODUTO","C",15,0})
	AADD(aFields2,{"T8_DESC"   ,"C",40,0})
	AADD(aFields2,{"T8_UM"     ,"C",02,0})
	AADD(aFields2,{"T8_QTDE"   ,"N",12,2})
	AADD(aFields2,{"T8_UNIT"   ,"N",12,7})
	AADD(aFields2,{"T8_TOTAL"  ,"N",14,2})

	cArq2:=Criatrab(aFields2,.T.)
	DBUSEAREA(.t.,,cArq2,"TC8")
Return


	********************************************
Static Function Monta_TC9()
	Local _nX

// Irแ efetuar a checagem de pedidos de compras
// em aberto para este fornecedor e os itens desta nota fiscal a ser importa
// serแ demonstrado ao usuแrio se o pedido de compra deverแ ser associado
// a entrada desta nota fiscal

	cQuery := ""
	cQuery += " SELECT  C7_NUM T9_PEDIDO,     "
	cQuery += " 		C7_ITEM T9_ITEM,    "
	cQuery += " 	    C7_PRODUTO T9_PRODUTO, "
	cQuery += " 		B1_DESC T9_DESC,    "
	cQuery += " 		B1_UM T9_UM,		"
	cQuery += " 		C7_QUANT T9_QTDE,   "
	cQuery += " 		C7_PRECO T9_UNIT,   "
	cQuery += " 		C7_TOTAL T9_TOTAL,   "
	cQuery += " 		C7_DATPRF T9_DTPRV,  "
	cQuery += " 		C7_LOCAL T9_ALMOX, "
	cQuery += " 		C7_OBS T9_OBSERV, "
	cQuery += " 		C7_CC T9_CCUSTO, "
	cQuery += " 		C7_QUJE T9_SALDO, "
	cQuery += " 		SC7.R_E_C_N_O_ T9_REG "
	cQuery += " FROM " + RetSqlName("SC7") + " SC7, " + RetSqlName("SB1") + " SB1 "
	cQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "' "
	cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery += " AND SC7.D_E_L_E_T_ = ' ' "
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " AND C7_QUANT > C7_QUJE  "
	cQuery += " AND C7_RESIDUO = ''  "
//	cQuery += " AND C7_TPOP <> 'P'  "
	cQuery += " AND C7_CONAPRO <> 'B'  "
	cQuery += " AND C7_ENCER = '' "
//	cQuery += " AND C7_CONTRA = '' "
//	cQuery += " AND C7_MEDICAO = '' "
	cQuery += " AND C7_PRODUTO = B1_COD "
	cQuery += " AND C7_FORNECE = '" + SA2->A2_COD + "' "
	cQuery += " AND C7_LOJA = '" + SA2->A2_LOJA + "' "
	cQuery += " AND C7_PRODUTO IN" + FormatIn( cProds, "/")
	If MV_PAR01 <> 1
		cQuery += " AND 1 > 1 "
	Endif
	cQuery += " ORDER BY C7_NUM, C7_ITEM, C7_PRODUTO "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CAD",.T.,.T.)
	TcSetField("CAD","T9_DTPRV","D",8,0)

	Dbselectarea("CAD")

	While CAD->(!EOF())
		RecLock("TC9",.T.)
		For _nX := 1 To Len(aFields)
			If !(aFields[_nX,1] $ 'T9_OK')
				If aFields[_nX,2] = 'C'
					_cX := 'TC9->'+aFields[_nX,1]+' := Alltrim(CAD->'+aFields[_nX,1]+')'
				Else
					_cX := 'TC9->'+aFields[_nX,1]+' := CAD->'+aFields[_nX,1]
				Endif
				_cX := &_cX
			Endif
		Next
		TC9->T9_OK := _cMarca //ThisMark()
		TC9->T9_SALDO := T9_QTDE-T9_SALDO //ThisMark()
		MsUnLock()

		DbSelectArea('CAD')
		CAD->(dBSkip())
	EndDo

	Dbselectarea("CAD")
	DbCloseArea()
	Dbselectarea("TC9")
	DbGoTop()

	_cIndex:=Criatrab(Nil,.F.)
	_cChave:="T9_PEDIDO"
	Indregua("TC9",_cIndex,_cChave,,,"Ordenando registros selecionados...")
	DbSetIndex(_cIndex+ordbagext())
	SysRefresh()
Return


Static Function GetArq(cFile)
	Local cMascara	:= 'Arquivo Xml|*.xml'
	Local cTitulo	:= "Escolha os arquivos"
	Local nMascpad	:= 0
	Local cDirini	:= "\"
	Local lSalvar	:= .F. /*.T. = Salva || .F. = Abre*/
	Local lArvore	:= .F. /*.T. = apresenta o แrvore do servidor || .F. = nใo apresenta*/
	Local path := "\xmlnfe\cfg\"
	Local targetDir
	Local sucess
//Local bReanalise := .F.
	local _NI

	targetDir := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar,;
		nOR(GETF_MULTISELECT,GETF_LOCALHARD, GETF_LOCALFLOPPY), lArvore)

	targetDir := STRTRAN(targetDir,'"','')
	aDados := Separa(targetDir,'|',.T.)

	_cFiles := ""
	FOR _NI:=1 TO LEN(aDados)
		cPatharq  :=  ALLTRIM(aDados[_NI])
		cDrive := ""
		cDir   := ""
		cArq   := ""
		cExt   := ""
		SplitPath( cPatharq, @cDrive, @cDir, @cArq, @cExt )
		frename(cPatharq ,cDrive+cDir+cArq+cExt )
		sucess:= CpyT2S( cDrive+cDir+cArq+cExt, path, .F. )
		_cFiles += IIF(_cFiles == "",cArq+cExt,","+cArq+cExt)
	NEXT


	Alert("xml's importados com sucesso!")

Return cFile


StatiC Function Fecha()
	Close(_oPT00005)
Return





Static Function AchaFile(cCodBar)
//Local aCompl := {}
	Local cCaminho := "\importadorxml\cfg"
	Local lOk := .f.
//Local oNf
//Local oNfe
	local nArq
	Local nI

	If Empty(cCodBar)
		Return .t.
	Endif

/* AAdd(aCompl,'_v1.10-procNFe.xml')
AAdd(aCompl,'-nfe.xml')
AAdd(aCompl,'.xml')
AAdd(aCompl,'-procnfe.xml')

For nC := 1 To Len(aCompl)
If File(cCaminho+AllTrim(cCodBar)+aCompl[nC])
cCodBar := AllTrim(cCaminho+AllTrim(cCodBar)+aCompl[nC])
lOk := .t.
Exit
Endif
Next

*/
	aFiles := Directory(cCaminho+"\"+alltrim(cCodBar)+".XML", "D")

	For nArq := 1 To Len(aFiles)
		cFile := AllTrim(cCaminho+"\"+aFiles[nArq,1])

		nHdl    := fOpen(cFile,0)
		nTamFile := fSeek(nHdl,0,2)
		fSeek(nHdl,0,0)
		cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
		nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
		fClose(nHdl)
		If AT(AllTrim(cCodBar),AllTrim(cBuffer)) > 0
			cCodBar := cFile
			lOk := .t.
			Exit
		Endif
	Next
	If !lOk
		//lok:=.t.
		cCaminho := "\xmlnfe\new"
		aFiles := Directory(cCaminho+"\"+alltrim(cCodBar)+".XML", "D")

		For nArq := 1 To Len(aFiles)
			cFile := AllTrim(cCaminho+"\"+aFiles[nArq,1])

			nHdl    := fOpen(cFile,0)
			nTamFile := fSeek(nHdl,0,2)
			fSeek(nHdl,0,0)
			cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
			nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
			fClose(nHdl)
			If AT(AllTrim(cCodBar),AllTrim(cBuffer)) > 0
				cCodBar := cFile
				lOk := .t.
				Exit
			Endif
		Next
		If !lOk
			Alert("Nenhum Arquivo Encontrado nas pastas NEW, Verifique se o arquivo XML foi baixado!")
			RETURN
		ELSE

			cDirdes   := SuperGetMV('MV_NGINN', .F., '')
			cDirSrv   := "\importadorxml\cfg\"

			cDirSrv   := Alltrim(cDirSrv)
			cDirdes   := Alltrim(cDirdes) + "\"

			//Monta um array com todos os arquivos GZ
			aArquivos := Directory(cFile)
			//aArquivos := Directory(cDirSrv + "*.gz")
			//Percorre todos os arquivos descompactando
			For nI := 1 To len(aArquivos)

				//Pega o nome do arquivo com e sem extensao
				cArquivo    := aArquivos[nI][1]
				cArqSemExt  := StrTran(Lower(cArquivo),'.xml','')

				//Tenta descompactar o arquivo
				If FRename( cDirSrv +  cArqSemExt + ".xml" , cDirdes + cArqSemExt + ".xml" ) == 0
					//    FErase( cDirdes +  cArqSemExt )
					//	FErase( cDirSrv +  cArquivo )
				EndIf

			Next
			Close(_oPT00005)


			MsgInfo("Arquivo encontrado com sucesso, Favor verificar o Monitor!")

			_lReleitura:=.t.
			//Fecha()

		endif
	Endif


Return lOk

