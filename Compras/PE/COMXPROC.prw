User Function COMXPROC()
// falta terminar... 
/*/{Protheus.doc} COMXPROC
Função para validar se informações de NCM, Origem e CEST no sistema, estão divergentes do XML, e atualizar no sistema caso usuário confirme.
@author Wilk Lima
@since 10/11/2022
@version 1.0
@type function
/*/

	Local _aArea := GetArea()
	Local lRet 		:= .T.
	Local cXmlOrig 	:= ""
	Local cXmlNCM	:= ""
	Local cXmlCEST	:= ""
	Local cCodProd 	:= ""
	Local cXmlItem 	:= ""
	Local nX
	Local _lAtuTodos := .F.
	Local _nMVAST := 0

	IF ALLTRIM(FUNNAME(0)) == "SCHEDCOMCOL"
    /*/QUANDO O PE FOR CHAMADO PELO JOB
		CONOUT("Novo xml chegou na base:" + ALLTRIM(SDS->DS_ARQUIVO) + " - Referente ao documento:"+SDS->DS_DOC)
		IF ALLTRIM(SDS->DS_TIPO) == "T" .AND. ALLTRIM(SDS->DS_ESPECI) == "CTE" .AND. ALLTRIM(SDS->DS_TPCTE) == "N"
			Reclock("SDS",.F.)
			Replace SDS->DS_TPCTE With "C"
			MsUnlock()
		ENDIF
/*/
	ELSE  //QUANDO O PE FOR CHAMADO PELO USUARIO
		Dbselectarea("CKO")
		DBSETORDER(1)
		IF DBSEEK(ALLTRIM(SDS->DS_ARQUIVO)) .AND. SDS->DS_TIPO == "N"

			// INICIO DO PROCESSO DE LEITURA DO XML
			cAviso := ""
			cErro  := ""
			oNfe := XmlParser(CKO->CKO_XMLRET,"_",@cAviso,@cErro)
			oNF := oNFe:_NFeProc:_NFe
			oEmitente  := oNF:_InfNfe:_Emit
			oIdent     := oNF:_InfNfe:_IDE
			oDestino   := oNF:_InfNfe:_Dest
			oTotal     := oNF:_InfNfe:_Total
			oTransp    := oNF:_InfNfe:_Transp
			oDet       := oNF:_InfNfe:_Det
			oDet := IIf(ValType(oDet)=="O",{oDet},oDet)
			cCgc := AllTrim(IIf(Type("oEmitente:_CPF")=="U",oEmitente:_CNPJ:TEXT,oEmitente:_CPF:TEXT))
			cCodFor := POSICIONE("SA2",3,XFILIAL("SA2")+cCgc,"A2_COD")
			cLojFor := POSICIONE("SA2",3,XFILIAL("SA2")+cCgc,"A2_LOJA")
			cXmlDoc := IIF(Type("OIdent:_nNF")=="U",space(12),Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9))
			cXmlSer := IIF(Type("OIdent:_serie")=="U",space(12),Padr(OIdent:_serie:TEXT,3))

			For nX := 1 To Len(oDet) //LEITURA DOS ITENS DO XML

				cXmlNCM		:= ""
				cXmlCEST	:= ""
				cXmlOrig	:= ""
				cCodProd 	:= ""
				cXmlItem 	:= ""
				_nMVAST 	:= 0
				oDetAtu := oDet[nX]

				cXmlNcm := IIF(Type("oDetAtu:_Prod:_NCM")=="U",space(12),oDetAtu:_Prod:_NCM:TEXT)
				cXmlProd := IIF(Type("oDetAtu:_Prod:_cProd")=="U",space(12),oDetAtu:_Prod:_cProd:TEXT)

				cXmlCest := IIF(Type("oDetAtu:_Prod:_CEST")=="U",space(12),oDetAtu:_Prod:_CEST:TEXT)
				cXmlItem := IIF(Type("oDetAtu:_NITEM")=="U",space(12),oDetAtu:_NITEM:TEXT)


				Do Case
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMS00")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMS00
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMS10")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMS10
					_nMVAST := val(oICM:_pMVAST:TEXT)
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMS20")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMS20
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMS30")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMS30
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMS40")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMS40
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMS51")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMS51
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMS60")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMS60
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMS70")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMS70
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMS90")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMS90
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMSSN101")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMSSN101
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMSSN102")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMSSN102
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMSSN103")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMSSN103
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMSSN201")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMSSN201
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMSSN202")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMSSN202
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMSSN203")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMSSN203
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMSSN300")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMSSN300
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMSSN400")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMSSN400
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMSSN500")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMSSN500
				Case Type("oDetAtu:_Imposto:_ICMS:_ICMSSN900")<> "U"
					oICM:=oDetAtu:_Imposto:_ICMS:_ICMSSN900
				EndCase

				// CLASSIFICAÇÃO DA ORIGEM DO PRODUTO B1_ORIGEM
				cXmlOrig := IIF(Type("oICM:_orig:TEXT")== "U" ," ",Alltrim(oICM:_orig:TEXT))

				cCodProd := POSICIONE("SA5",14,XFILIAL("SA5")+cCodFor+cLojFor+cXmlProd,"A5_PRODUTO")

				Dbselectarea("SB1")
				DbSetOrder(1)
				DBSEEK(XFILIAL("SB1")+cCodProd)

				if _nMVAST> 0
					RecLock("SB1",.F.)
						Replace B1_PICMENT with _nMVAST
					MSUnLock()
				endif

				If !Empty(cXmlNCM) .and. alltrim(SB1->B1_POSIPI) <> cXmlNCM
					IF !_lAtuTodos
						RetAviso := Aviso('NCM encontrado no xml: '+cXmlNCM+", é diferente do cadastrado no produto: "+alltrim(SB1->B1_POSIPI),'Deseja Alterar?',{'Nao','Sim',"Sim para todos"})
						IF	RetAviso == 3
							_lAtuTodos := .T.
						ENDIF
					ENDIF
					IF RetAviso <> 1 .OR. _lAtuTodos
						RecLock("SB1",.F.)
						Replace B1_POSIPI with cXmlNCM
						IF !EMPTY(cXmlOrig)
							Replace B1_ORIGEM with cXmlOrig
						endif
						IF !EMPTY(cXmlCest)
							Replace B1_CEST with cXmlCEST
						endif
						MSUnLock()
					endif
				Endif
				DbSelectArea("SB1")
			Next
		ENDIF
	ENDIF
	RestArea(_aArea)

Return lRet
