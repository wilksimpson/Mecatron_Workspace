#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.ch"
#INCLUDE "RPTDEF.CH"
#include "TOPCONN.CH"

#Define STR_PULA	Chr(13)+Chr(10)

//IMP_SEP0101

User Function ROrcCodbar()

	Local lAdjustToLegacy := .F.
	Local lDisableSetup  := .T.
	Local oPrinter
	Local cLocal          := "\spool"
	IF SL1->L1_LIBERAD $ "2,3,6,7,8"
		oPrinter := FWMSPrinter():New("codbar_"+SL1->L1_FILIAL+SL1->L1_NUM+".rel", IMP_SPOOL, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
		oPrinter:Setup()
		IF oPrinter:nModalResult == PD_OK
			oPrinter:StartPage()
			oPrinter:Say(10,10,"Vendedor: "+Posicione('SA3',1,xFilial('SA3')+SL1->L1_VEND,'A3_NREDUZ'))
			oPrinter:Say(25,10,"Cliente:  "+Posicione('SA1',1,xFilial('SA1')+SL1->(L1_CLIENTE+L1_LOJA),'A1_NREDUZ'))
			oPrinter:Say(40,10,"Total "+Transform(SL1->L1_VLRTOT,"@E 99,999.99"))
			oPrinter:Say(55,10,"Orçamento: "+SL1->L1_NUM+" Tipo: "+u_zCmbDesc(SL1->L1_LIBERAD, "L1_LIBERAD", ""))
			oPrinter:FWMSBAR("CODE128" /*cTypeBar*/,6/*nRow*/ ,5/*nCol*/ ,SL1->L1_NUM  /*cCode*/,oPrinter/*oPrint*/,/*lCheck*/,/*Color*/,/*lHorz*/,/*nWidth*/,/*nHeigth*/,.F./*lBanner*/,/*cFont*/,/*cMode*/,.f./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,/*lCmtr2Pix*/)

			oPrinter:EndPage()
			oPrinter:Print()
		endif
	ELSE
		Alert("Nao permitido a impressao do ticket para orcamento e vistoria")
	ENDIF
Return

User Function RImpOrc()
	Local lAdjustToLegacy := .F.
	Local lDisableSetup  := .T.
	Local oPrinter
	Local cLocal          := "\spool"

	Local nLin   := 1
	Local cQuery
	Local nLin2 := 0
	Local nX := 0

	oFont  := TFont():New("Courier New",,6,,.T. /*NEGRITO*/,,,,.T.,)	//85 caracteres por linha
	oFont1 := TFont():New("Courier New",,10,,.T. /*NEGRITO*/,,,,.T.,)	//99 caracteres por linha
	oFont2 := TFont():New("Courier New",,6,,.T. /*NEGRITO*/,,,,,)
	oFont3 := TFont():New("Courier New",,8,,.T. /*NEGRITO*/,,,,.T.,)
	oFont4 := TFont():New("Courier New",,18,,.T. /*NEGRITO*/,,,,.T.,)	//85 caracteres por linha
	oFont5 := TFont():New("Courier New",,15,,.T. /*NEGRITO*/,,,,.T.,)


	cImp := "IMP_SEP"+XFILIAL("SL1")

	oPrinter := FWMSPrinter():New("orc_"+SL1->L1_FILIAL+SL1->L1_NUM+".rel", IMP_SPOOL, lAdjustToLegacy,cLocal, lDisableSetup, , ,cImp , , , .F., )
	oPrinter:Setup()
	IF oPrinter:nModalResult == PD_OK

		oPrinter:setresolution(82)
		oPrinter:StartPage()
		oPrinter:setpapersize(8)
		oPrinter:SetMargin(0,0,0,0) // nEsquerda, nSuperior, nDireita, nInferior

		cQuery := ""
		cQuery += " SELECT  '' AS BZ_LOCALI2,L1_EMISSAO, L1_NUM,L1_VLRLIQ,L1_DESCONT,L1_VALBRUT, L1_VLRTOT, L2_ITEM, L2_PRODUTO, L2_QUANT, L2_VRUNIT, L2_VLRITEM " + STR_PULA
		cQuery += " ,A3_NOME,A3_NREDUZ,A1_NOME,A1_BAIRRO,A1_END,A1_COMPLEM,A1_EST,A1_EMAIL,A1_CGC,A1_MUN,B1_REFER,B1_DESC,B1_UM " + STR_PULA
		cQuery += " FROM "+RetSqlName("SL1")+" L1 "+STR_PULA
		cQuery += " INNER JOIN "+RetSqlName("SL2")+" L2 ON L2.D_E_L_E_T_=' ' AND L1_FILIAL=L2_FILIAL AND L1_NUM=L2_NUM " + STR_PULA
		cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1.D_E_L_E_T_=' ' AND B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD = L2_PRODUTO " + STR_PULA
		cQuery += " INNER JOIN "+RetSqlName("SA1")+" A1 ON A1.D_E_L_E_T_=' ' AND A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD = L1_CLIENTE AND A1_LOJA = L1_LOJA  " + STR_PULA
		cQuery += " INNER JOIN "+RetSqlName("SA3")+" A3 ON A3.D_E_L_E_T_=' ' AND A3_FILIAL='"+xFilial("SA3")+"' AND A3_COD = L1_VEND " + STR_PULA
		cQuery += " WHERE L1.D_E_L_E_T_ = ' ' AND L1_NUM = '"+SL1->L1_NUM+"' AND L2_FILIAL='"+SL1->L1_FILIAL+"' " + STR_PULA
		cQuery += " ORDER BY L2_ITEM "

		dbUseArea(.t., "TOPCONN", TcGenQry(,,cQuery), "QRYORC", .t.)

		nLin:=80

		cLogo := "\imagens\mecatron.jpg"


		oPrinter:SayBitmap(020,060,cLogo,100,060)
		NLIN+=10

		oPrinter:Say(nLin,0,RTRIM(SM0->M0_ENDCOB)+" - "+alltrim(SM0->M0_BAIRCOB),oFont3)
		NLIN+=10
		oPrinter:Say(nLin,0," Fone: "+RTRIM(SM0->M0_TEL),oFont3)
		NLIN+=20
		DO CASE
		CASE SL1->L1_LIBERAD =='1'
			oPrinter:Say(nLin,55,"ORÇAMENTO DE MERCADORIAS",oFont1)
		CASE SL1->L1_LIBERAD =='2'
			oPrinter:Say(nLin,55,"NOTA DE SEPARAÇÃO",oFont1)
		CASE SL1->L1_LIBERAD =='3'
			oPrinter:Say(nLin,55,"NOTA DE ITENS SEPARADOS",oFont1)
		CASE SL1->L1_LIBERAD =='4'
			oPrinter:Say(nLin,55,"ORÇAMENTO FATURADO",oFont1)
		OTHERWISE
			oPrinter:Say(nLin,55,"ORÇAMENTO DE MERCADORIAS",oFont1)
		END

		NLIN+=20

		oPrinter:Say(nLin,0," Nr Doc.:"+SL1->L1_NUM+"       Data: "+dToc(SL1->L1_EMISSAO)+" "+Left(Time(),5),oFont3)
		NLIN+=10
		oPrinter:Say(nLin,0,"         "+SPACE(6)+   "      Valid: "+dToc(SL1->L1_DTLIM)+" ",oFont3)
		NLIN+=10

		oPrinter:LINE(nLin,0,nLin,500)
		NLIN+=10
		oPrinter:Say(nLin,0," Cliente: " + POSICIONE("SA1",1,XFILIAL("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA,"A1_NOME"),oFont3)
		NLIN+=10
		oPrinter:Say(nLin,0," End: "+POSICIONE("SA1",1,XFILIAL("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA,"A1_END"),oFont3)
		NLIN+=10
		oPrinter:Say(nLin,0," Contato: "+SL1->L1_CONTATO,oFont3)
		NLIN+=10
		oPrinter:Say(nLin,0," Observação: ",oFont3)
		NLIN+=10
		cObs := SL1->L1_OBS
		nLin2 := mlcount(ALLTRIM(cObs),40)
		For nX := 1 to nLin2
			oPrinter:Say(nLin,5,memoline(Alltrim(cObs),40,nX) ,oFont3)
			NLIN+=10
		Next

		oPrinter:Say(nLin,0," Vendedor.:"+POSICIONE("SA3",1,XFILIAL("SA3")+SL1->L1_VEND,"A3_NREDUZ"),oFont3)
		NLIN+=10
		oPrinter:LINE(nLin,0,nLin,500)
		NLIN+=10
		oPrinter:Say(nLin,5,"COD.",oFont2)
		oPrinter:Say(nLin,30,"DESCRIÇÃO",oFont2)
		oPrinter:Say(nLin,80,"QTD ",oFont2)
		oPrinter:Say(nLin,120,"VLR. UNIT",oFont2)
		oPrinter:Say(nLin,170,"VLR. TOT",oFont2)
		NLIN+=5
		oPrinter:LINE(nLin,0,nLin,500)
		NLIN+=10

		_nItem := 1
		_nQtd  := 1
		_nPag  := 1
		_nTot := 0

		while !QRYORC->(Eof()) //Enquanto houver registros
			////////////////////Itens ///////////////////////
			oPrinter:Say(nLin,5,Left(ALLTRIM(QRYORC->L2_PRODUTO)+" "+ALLTRIM(QRYORC->B1_DESC),60),oFont3)
			NLIN+=10
			oPrinter:Say(nLin,80,ALLTRIM(Transform(QRYORC->L2_QUANT,"@E 99,999.99"))+" X "+ALLTRIM(Transform(QRYORC->L2_VRUNIT,"@E 99,999.99"))+" = "+ALLTRIM(Transform(QRYORC->L2_VRUNIT * QRYORC->L2_QUANT,"@E 99,999.99")),oFont3)
			_nTot +=  QRYORC->L2_VRUNIT * QRYORC->L2_QUANT
			NLIN+=10
			oPrinter:Say(nLin,5,"Ref:"+Left(ALLTRIM(QRYORC->B1_REFER),60),oFont3)
			NLIN+=10
			oPrinter:Say(nLin,5,"Loc:"+Left(POSICIONE("SBZ",1,XFILIAL("SBZ")+QRYORC->L2_PRODUTO,"BZ_DESCLOC"),60),oFont3)

			NLIN+=6
			oPrinter:LINE(nLin,0,nLin,500)
			NLIN+=10

			if _nQtd == 14
				oPrinter:Say(nLin,0,Left("Pagina:"+cValToChar(_nPag)+" Continua...",60),oFont3)
				NLIN+=10
				oPrinter:LINE(nLin,0,nLin,500)

				oPrinter:EndPage()
				oPrinter:StartPage()
				_nQtd := 1
				nLin:=20
				_nPag++
			endif

			_nItem++
			_nQtd++

			QRYORC->(DBSKIP())

		Enddo
		///////////////////Rodapé///////////////////////



		oPrinter:Say(nLin,0," TOTAL: " ,oFont3)
		oPrinter:Say(nLin,180,(Transform((SL1->L1_VALBRUT+SL1->L1_DESCONT),"@E 99,999.99")) ,oFont3)
		NLIN+=10
		oPrinter:Say(nLin,0," DESCONTO: " ,oFont3)
		oPrinter:Say(nLin,180,(Transform(SL1->L1_DESCONT,"@E 99,999.99")) ,oFont3)
		NLIN+=10
		oPrinter:Say(nLin,0," VALOR DA VENDA: " ,oFont3)
		oPrinter:Say(nLin,180,(Transform(SL1->L1_VLRLIQ,"@E 99,999.99")) ,oFont3)
		NLIN+=10
		oPrinter:LINE(nLin,0,nLin,500)
		NLIN+=10
		oPrinter:Say(nLin,0," CONDICOES DE PGTO: " ,oFont3)
		NLIN+=10
		nLin := LjSL4(SL1->L1_NUM,SL1->L1_FILIAL,oPrinter,nLin)

		NLIN+=10


		oPrinter:EndPage()
		oPrinter:Print()


		QRYORC->(DbCloseArea())



	ENDIF


Return


User Function RImpSep()
	Local lAdjustToLegacy := .F.
	Local lDisableSetup  := .T.
	Local oPrinter
	Local cLocal          := "\spool"

	Local nLin   := 1
	Local cQuery
	Local nLin2 := 0
	Local nX := 0

	oFont  := TFont():New("Courier New",,6,,.T. /*NEGRITO*/,,,,.T.,)	//85 caracteres por linha
	oFont1 := TFont():New("Courier New",,10,,.T. /*NEGRITO*/,,,,.T.,)	//99 caracteres por linha
	oFont2 := TFont():New("Courier New",,6,,.T. /*NEGRITO*/,,,,,)
	oFont3 := TFont():New("Courier New",,8,,.T. /*NEGRITO*/,,,,.T.,)
	oFont4 := TFont():New("Courier New",,18,,.T. /*NEGRITO*/,,,,.T.,)	//85 caracteres por linha
	oFont5 := TFont():New("Courier New",,15,,.T. /*NEGRITO*/,,,,.T.,)


//	cImp := "\\Estoque2\MP-4200 TH" \\ impressora separação nome filial
	cImp := ALLTRIM(GETMV("MC_IMPSEP"))

    oPrinter := FWMSPrinter():New("separacao.rel", IMP_SPOOL, lAdjustToLegacy,cLocal, lDisableSetup, , ,cImp , , , .F., )


		oPrinter:setresolution(82)
		oPrinter:StartPage()
		oPrinter:setpapersize(8)
		oPrinter:SetMargin(0,0,0,0) // nEsquerda, nSuperior, nDireita, nInferior

		cQuery := ""
		cQuery += " SELECT  '' AS BZ_LOCALI2,L1_EMISSAO, L1_NUM,L1_VLRLIQ,L1_DESCONT,L1_VALBRUT, L1_VLRTOT, L2_ITEM, L2_PRODUTO, L2_QUANT, L2_VRUNIT, L2_VLRITEM " + STR_PULA
		cQuery += " ,A3_NOME,A3_NREDUZ,A1_NOME,A1_BAIRRO,A1_END,A1_COMPLEM,A1_EST,A1_EMAIL,A1_CGC,A1_MUN,B1_REFER,B1_DESC,B1_UM " + STR_PULA
		cQuery += " FROM "+RetSqlName("SL1")+" L1 "+STR_PULA
		cQuery += " INNER JOIN "+RetSqlName("SL2")+" L2 ON L2.D_E_L_E_T_=' ' AND L1_FILIAL=L2_FILIAL AND L1_NUM=L2_NUM " + STR_PULA
//        cQuery += " INNER JOIN "+RetSqlName("SBZ")+" BZ ON BZ.D_E_L_E_T_=' ' AND BZ_FILIAL=L2_FILIAL AND BZ_COD=L2_PRODUTO " + STR_PULA
		cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1.D_E_L_E_T_=' ' AND B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD = L2_PRODUTO " + STR_PULA
		cQuery += " INNER JOIN "+RetSqlName("SA1")+" A1 ON A1.D_E_L_E_T_=' ' AND A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD = L1_CLIENTE AND A1_LOJA = L1_LOJA  " + STR_PULA
		cQuery += " INNER JOIN "+RetSqlName("SA3")+" A3 ON A3.D_E_L_E_T_=' ' AND A3_FILIAL='"+xFilial("SA3")+"' AND A3_COD = L1_VEND " + STR_PULA
		cQuery += " WHERE L1.D_E_L_E_T_ = ' ' AND L1_NUM = '"+SL1->L1_NUM+"' AND L2_FILIAL='"+SL1->L1_FILIAL+"' " + STR_PULA
		cQuery += " ORDER BY L2_ITEM "

		dbUseArea(.t., "TOPCONN", TcGenQry(,,cQuery), "QRYORC", .t.)

		nLin:=80

		cLogo := "\imagens\mecatron.jpg"


		oPrinter:SayBitmap(020,060,cLogo,100,060)
		NLIN+=10

		oPrinter:Say(nLin,0,RTRIM(SM0->M0_ENDCOB)+" - "+alltrim(SM0->M0_BAIRCOB),oFont3)
		NLIN+=10
		oPrinter:Say(nLin,0," Fone: "+RTRIM(SM0->M0_TEL),oFont3)
		NLIN+=20
		DO CASE
		CASE SL1->L1_LIBERAD =='1'
			oPrinter:Say(nLin,55,"ORÇAMENTO DE MERCADORIAS",oFont1)
		CASE SL1->L1_LIBERAD =='2'
			oPrinter:Say(nLin,55,"NOTA DE SEPARAÇÃO",oFont1)
		CASE SL1->L1_LIBERAD =='3'
			oPrinter:Say(nLin,55,"NOTA DE ITENS SEPARADOS",oFont1)
		CASE SL1->L1_LIBERAD =='4'
			oPrinter:Say(nLin,55,"ORÇAMENTO FATURADO",oFont1)
		OTHERWISE
			oPrinter:Say(nLin,55,"ORÇAMENTO DE MERCADORIAS",oFont1)
		END

		NLIN+=20

		oPrinter:Say(nLin,0," Nr Doc.:"+SL1->L1_NUM+"       Data: "+dToc(SL1->L1_EMISSAO)+" "+Left(Time(),5),oFont3)
		NLIN+=10
		oPrinter:Say(nLin,0,"         "+SPACE(6)+   "      Valid: "+dToc(SL1->L1_DTLIM)+" ",oFont3)
		NLIN+=10
		oPrinter:LINE(nLin,0,nLin,500)
		NLIN+=10
		oPrinter:Say(nLin,0," Cliente: " + POSICIONE("SA1",1,XFILIAL("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA,"A1_NOME"),oFont3)
		NLIN+=10
		oPrinter:Say(nLin,0," End: "+POSICIONE("SA1",1,XFILIAL("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA,"A1_END"),oFont3)
		NLIN+=10
		oPrinter:Say(nLin,0," Contato: "+SL1->L1_CONTATO,oFont3)
		NLIN+=10
		oPrinter:Say(nLin,0," Observação: ",oFont3)
		NLIN+=10
		cObs := SL1->L1_OBS
		nLin2 := mlcount(ALLTRIM(cObs),40)
		For nX := 1 to nLin2
			oPrinter:Say(nLin,5,memoline(Alltrim(cObs),40,nX) ,oFont3)
			NLIN+=10
		Next

		oPrinter:Say(nLin,0," Vendedor.:"+POSICIONE("SA3",1,XFILIAL("SA3")+SL1->L1_VEND,"A3_NREDUZ"),oFont3)
		NLIN+=10
		oPrinter:LINE(nLin,0,nLin,500)
		NLIN+=10
		oPrinter:Say(nLin,5,"COD.",oFont2)
		oPrinter:Say(nLin,30,"DESCRIÇÃO",oFont2)
		oPrinter:Say(nLin,80,"QTD ",oFont2)
		oPrinter:Say(nLin,120,"VLR. UNIT",oFont2)
		oPrinter:Say(nLin,170,"VLR. TOT",oFont2)
		NLIN+=5
		oPrinter:LINE(nLin,0,nLin,500)
		NLIN+=10

		_nItem := 1
		_nQtd  := 1
		_nPag  := 1
		_nTot := 0

		while !QRYORC->(Eof()) //Enquanto houver registros
			////////////////////Itens ///////////////////////
			oPrinter:Say(nLin,5,Left(ALLTRIM(QRYORC->L2_PRODUTO)+" "+ALLTRIM(QRYORC->B1_DESC),60),oFont3)
			NLIN+=10
			oPrinter:Say(nLin,80,ALLTRIM(Transform(QRYORC->L2_QUANT,"@E 99,999.99"))+" X "+ALLTRIM(Transform(QRYORC->L2_VRUNIT,"@E 99,999.99"))+" = "+ALLTRIM(Transform(QRYORC->L2_VRUNIT * QRYORC->L2_QUANT,"@E 99,999.99")),oFont3)
			_nTot +=  QRYORC->L2_VRUNIT * QRYORC->L2_QUANT
			NLIN+=10
			oPrinter:Say(nLin,5,"Ref:"+Left(ALLTRIM(QRYORC->B1_REFER),60),oFont3)
			NLIN+=10
			oPrinter:Say(nLin,5,"Loc:"+Left(POSICIONE("SBZ",1,XFILIAL("SBZ")+QRYORC->L2_PRODUTO,"BZ_DESCLOC"),60),oFont3)
			NLIN+=6
			oPrinter:LINE(nLin,0,nLin,500)
			NLIN+=10

			if _nQtd == 14
				oPrinter:Say(nLin,0,Left("Pagina:"+cValToChar(_nPag)+" Continua...",60),oFont3)
				NLIN+=10
				oPrinter:LINE(nLin,0,nLin,500)

				oPrinter:EndPage()
				oPrinter:StartPage()
				_nQtd := 1
				nLin:=20
				_nPag++
			endif

			_nItem++
			_nQtd++

			QRYORC->(DBSKIP())

		Enddo
		///////////////////Rodapé///////////////////////



		oPrinter:Say(nLin,0," TOTAL: " ,oFont3)
		oPrinter:Say(nLin,180,(Transform((SL1->L1_VALBRUT+SL1->L1_DESCONT),"@E 99,999.99")) ,oFont3)
		NLIN+=10
		oPrinter:Say(nLin,0," DESCONTO: " ,oFont3)
		oPrinter:Say(nLin,180,(Transform(SL1->L1_DESCONT,"@E 99,999.99")) ,oFont3)
		NLIN+=10
		oPrinter:Say(nLin,0," VALOR DA VENDA: " ,oFont3)
		oPrinter:Say(nLin,180,(Transform(SL1->L1_VLRLIQ,"@E 99,999.99")) ,oFont3)
		NLIN+=10
		oPrinter:LINE(nLin,0,nLin,500)
		NLIN+=10
		oPrinter:Say(nLin,0," CONDICOES DE PGTO: " ,oFont3)
		NLIN+=10
		nLin := LjSL4(SL1->L1_NUM,SL1->L1_FILIAL,oPrinter,nLin)

		NLIN+=10


		oPrinter:EndPage()
		oPrinter:Print()


		QRYORC->(DbCloseArea())


Return





User Function zCmbDesc(cChave, cCampo, cConteudo)
	Local aArea       := GetArea()
	Local aCombo      := {}
	Local nAtual      := 1
	Local cDescri     := ""
	Default cChave    := ""
	Default cCampo    := ""
	Default cConteudo := ""

	//Se o campo e o conteúdo estiverem em branco, ou a chave estiver em branco, não há descrição a retornar
	If (Empty(cCampo) .And. Empty(cConteudo)) .Or. Empty(cChave)
		cDescri := ""
	Else
		//Se tiver campo
		If !Empty(cCampo)
			aCombo := RetSX3Box(GetSX3Cache(cCampo, "X3_CBOX"),,,1)

			//Percorre as posições do combo
			For nAtual := 1 To Len(aCombo)
				//Se for a mesma chave, seta a descrição
				If cChave == aCombo[nAtual][2]
					cDescri := aCombo[nAtual][3]
				EndIf
			Next

			//Se tiver conteúdo
		ElseIf !Empty(cConteudo)
			aCombo := StrTokArr(cConteudo, ';')

			//Percorre as posições do combo
			For nAtual := 1 To Len(aCombo)
				//Se for a mesma chave, seta a descrição
				If cChave == SubStr(aCombo[nAtual], 1, At('=', aCombo[nAtual])-1)
					cDescri := SubStr(aCombo[nAtual], At('=', aCombo[nAtual])+1, Len(aCombo[nAtual]))
				EndIf
			Next
		EndIf
	EndIf

	RestArea(aArea)
Return cDescri


Static Function LjSL4(_nNum,_cFilial,oPrinter,nLin)
	Local _cSql := ""

	_cSql := "SELECT L4_FORMA,X5_DESCRI,L4_ADMINIS,COUNT(*) L4_PARC "
	_cSql += "FROM "+RETSQLNAME("SL4")+" SL4 "
	_cSql += "INNER JOIN "+RETSQLNAME("SX5")+" SX5 ON X5_TABELA = '24' AND X5_CHAVE = L4_FORMA "
	_cSql += "WHERE L4_NUM = '"+_nNum+"' AND L4_FILIAL = '"+_cFilial+"' AND SL4.D_E_L_E_T_ = ' ' "
	_cSql += "GROUP BY L4_FORMA,X5_DESCRI,L4_ADMINIS "
	_cSql := ChangeQuery(_cSql)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSql),"SL4TMP")
	While !(SL4TMP->(EOF()))
		If Alltrim(SL4TMP->L4_FORMA) $ 'R$,CD'
			oPrinter:Say(nLin,5,Alltrim(SL4TMP->X5_DESCRI),oFont3)
			NLIN+=10
		Else
			oPrinter:Say(nLin,5,Alltrim(SL4TMP->X5_DESCRI)+" - ("+strzero(SL4TMP->L4_PARC,2)+" x ) ",oFont3)
			NLIN+=10
		Endif
		SL4TMP->(DbSkip())
	Enddo
	SL4TMP->(DbCloseArea())
Return nLin
