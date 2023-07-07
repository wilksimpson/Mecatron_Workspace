#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

//ÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœÃœ
//Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±
//Â±Â±Ã‰Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã‘Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã‹Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã‘Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã‹Ã?Ã?Ã?Ã?Ã?Ã?Ã‘Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Â»Â±Â±
//Â±Â±ÂºPrograma  ENDERPRD   Âº Autor JoÃ£o Felipe Costa Braga Data Â³ 05.02.2021 ÂºÂ±Â±
//Â±Â±ÃŒÃ?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã˜Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?ÃŠÃ?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?ÃŠÃ?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Â¹Â±Â±
//Â±Â±ÂºDescricao Â³ REPONSAVEL PELA ATUALIZAÇÃO DE PREÇOS              ÂºÂ±Â±
//Â±Â±ÃˆÃ?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Ã?Â¼Â±Â±
//Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±Â±
//ÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸÃŸ


User Function ATUSB0()
	Private aaCampos  	:= {"PRECO1","PRECO2","PRECO3"} //VariÃ¡vel contendo o campo editÃ¡vel no Grid
	Private oLista                    //Declarando o objeto do browser
	Private aCabecalho  := {}         //Variavel que montarÃ¡ o aHeader do grid
	Private aColsEx 	:= {}         //VariÃ¡vel que receberÃ¡ os dados
	Private oVerde  	:= LoadBitmap( GetResources(), "BR_VERDE")
	Private oAzul  		:= LoadBitmap( GetResources(), "BR_AZUL")
	Private oVermelho	:= LoadBitmap( GetResources(), "BR_VERMELHO")
	Private oAmarelo	:= LoadBitmap( GetResources(), "BR_AMARELO")
	Private _cCodFab    := ""
	Private _cCodGrup   := ""
	Private _nPerc      := 0 
    Private _nTipo      := 0

	DEFINE FONT oFont1 NAME "Arial" SIZE 0,14 BOLD

	aSize := MsAdvSize()


	IF Pergunte("ATUSB0",.T.,"Atualização de Preços",.T.)
		_cCodFab  := MV_PAR01
        _cCodGrup := MV_PAR02
		_nPerc    := MV_PAR03
        _nTipo    := MV_PAR04

		DEFINE MSDIALOG oDlg TITLE "Manutenção de Preços" FROM aSize[7],0 To aSize[6],aSize[5]  PIXEL
		CriaCab()
		cLinOk         := 'ExecBlock("ATUASB0V",.F.,.F.,{1})'
		CarSB0()

		oDlg:lMaximized := .T.
		oLista := MsNewGetDados():New( 200, 010, 365, 350, GD_UPDATE, cLinOk, "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aCabecalho, aColsEx,{ || oLista:oBrowse:Refresh() })
		oLista:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT //CONTROL_ALIGN_BOTTOM
		oLista:oBrowse:SetFocus()
		// configura pintura da TGridLocal
		_cCss:= "QTableView{ alternate-background-color: #f7f7f7; background: #ffffff; selection-background-color: #a9d19f;font-size: 16px; }"
		_cCss+= "QTableView::item:hover { background-color: #ddedd2;font-weight: 400;}"

		// configura pintura do Header da TGrid
		_cCss+= "QHeaderView::section { background-color: qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #ffffff, stop: 0.5 #ffffff, stop: 0.6 #ededed,  stop:1 #ededed); color: black; padding-left: 4px; border: 1px solid #6c6c6c; }"

		oLista:oBrowse:SetCss(_cCss)

		EnchoiceBar(oDlg, {|| Processar(oLista:aCols) }, {|| 	oDlg:End() })
		ACTIVATE MSDIALOG oDlg CENTERED
	ENDIF
Return


Static Function CarProd()
	IF Pergunte("ENDERPRD",.T.,"Produto",.T.)	
		CarSB0()
		aCols := aColsEx
		oLista:aCols := aColsEx
		oLista:Refresh()
		oDlg:Refresh()
	ENDIF
Return

//função responsavel por definir as colunas e suas caracteristicas
Static Function CriaCab()
	Aadd(aCabecalho, {;
		"",;//X3Titulo()
	"IMAGEM",;  //X3_CAMPO
	"@BMP",;		//X3_PICTURE
	3,;			//X3_TAMANHO
	0,;			//X3_DECIMAL
	".F.",;			//X3_VALID
	"",;			//X3_USADO
	"C",;			//X3_TIPO
	"",; 			//X3_F3
	"V",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	"",;			//X3_WHEN
	"V"})			//
	Aadd(aCabecalho, {;
		"Codigo",;//X3Titulo()
	"CODIGO",;  //X3_CAMPO
	"@!",;		//X3_PICTURE
	TamSX3("B1_COD")[1],;			//X3_TAMANHO
	TamSX3("B1_COD")[2],;			//X3_DECIMAL
	"",;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("B1_COD")[3],;			//X3_TIPO
	"",; 			//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Descrição",;	//X3Titulo()
	"DESCRICAO",;  	//X3_CAMPO
	"@!",;		//X3_PICTURE
	TamSX3("B1_DESC")[1],;			//X3_TAMANHO
	TamSX3("B1_DESC")[2],;			//X3_DECIMAL
	"",;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("B1_DESC")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Preço Tabela Atual",;	//X3Titulo()
	"PRECO",;  	//X3_CAMPO
	"@E 9,999,999,999,999.99",;		//X3_PICTURE
	TamSX3("B0_PRV1")[1],;			//X3_TAMANHO
	TamSX3("B0_PRV1")[2],;			//X3_DECIMAL
	'',;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("B0_PRV1")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Preço Tabela",;	//X3Titulo()
	"PRECO1",;  	//X3_CAMPO
	"@E 9,999,999,999,999.99",;		//X3_PICTURE
	TamSX3("B0_PRV1")[1],;			//X3_TAMANHO
	TamSX3("B0_PRV1")[2],;			//X3_DECIMAL
	'ExecBlock("ATUASB0V",.F.,.F.,{2})',;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("B0_PRV1")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Preço Prom",;	//X3Titulo()
	"PRECO2",;  	//X3_CAMPO
	"@E 9,999,999,999,999.99",;		//X3_PICTURE
	TamSX3("B0_PRV2")[1],;			//X3_TAMANHO
	TamSX3("B0_PRV2")[2],;			//X3_DECIMAL
	'ExecBlock("ATUASB0V",.F.,.F.,{3})',;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("B0_PRV2")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Preço Icms Dif",;	//X3Titulo()
	"PRECO3",;  	//X3_CAMPO
	"@E 9,999,999,999,999.99",;		//X3_PICTURE
	TamSX3("B0_PRV3")[1],;			//X3_TAMANHO
	TamSX3("B0_PRV3")[2],;			//X3_DECIMAL
	'ExecBlock("ATUASB0V",.F.,.F.,{4})',;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("B0_PRV3")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN


Return

//função responsavel por detectar e validar alterações do usuario
User Function ATUASB0V()
	_bRet := .T.

	IF PARAMIXB[1] == 1 //usuario mudou de linha

	ENDIF

	IF PARAMIXB[1] == 2 //validação do campo PRECO1
            if M->PRECO1 <= 0
                _bRet := .F.
                Alert("Produto nao permite preço menor q zero")
                Return _bRet
            ELSE
                aCols[N,getPosCab("PRECO1")] := M->PRECO1
                aCols[N,getPosCab("PRECO3")] := CustomRound(M->PRECO1 - (M->PRECO1 * 0.17))
                aCols[N,getPosCab("IMAGEM")] := oVerde
            ENDIF
	ENDIF

	IF PARAMIXB[1] == 3 //validação do campo PRECO2
                aCols[N,getPosCab("PRECO2")] := M->PRECO2
                aCols[N,getPosCab("IMAGEM")] := oVerde
	ENDIF


	IF PARAMIXB[1] == 4 //validação do campo PRECO3
            if M->PRECO3 <= 0
                _bRet := .F.
                Alert("Produto nao permite preço menor q zero")
                Return _bRet
            ELSE
                aCols[N,getPosCab("PRECO3")] := M->PRECO3
                aCols[N,getPosCab("IMAGEM")] := oVerde
            ENDIF
	ENDIF

Return _bRet

//função responsavel por carregar os endereços do produto selecionado
Static Function CarSB0()

	IF !EMPTY(ALLTRIM(_cCodFab)) .OR. !EMPTY(ALLTRIM(_cCodGrup))

		_cQry := " SELECT B1_COD,B1_DESC,B0_PRV1,B0_PRV2,B0_PRV3 FROM "+RetSqlName("SB0")+" B0 "
		_cQry += " INNER JOIN "+RetSqlName("SB1")+" B1 ON "
		_cQry += " B1_COD = B0_COD  "
		_cQry += " WHERE B1.d_e_l_e_t_ = ' ' AND B0.d_e_l_e_t_ = ' ' AND "
        IF !EMPTY(_cCodFab)
    		_cQry += " B1_CODFAB = '"+ALLTRIM(_cCodFab)+"' "
        ENDIF
        IF !EMPTY(_cCodGrup)
		    _cQry += " AND B1_GRUPO = '"+ALLTRIM(_cCodGrup)+"' "
        ENDIF
		_cQry += " ORDER BY B1_DESC "

		DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQry), "PRDLOCAL", .T., .F. )
		aColsEx := {}
		DO WHILE !PRDLOCAL->(Eof())
            nPrc1 := PRDLOCAL->B0_PRV1
            nPrc2 := PRDLOCAL->B0_PRV2
            nPrc3 := PRDLOCAL->B0_PRV3
            oCor := oVermelho
            IF _nPerc > 0 .AND. _nTipo == 1
                nPrc1 := nPrc1 + (nPrc1*(_nPerc/100))
                nPrc1 := CustomRound(nPrc1)
                nPrc3 := nPrc1 - (nPrc1 * 0.17)
                nPrc3 := CustomRound(nPrc3)
                oCor := oVerde
            ENDIF
            IF _nPerc > 0 .AND. _nTipo == 2
                nPrc1 := nPrc1 - (nPrc1*(_nPerc/100))
                nPrc1 := CustomRound(nPrc1)
                nPrc3 := nPrc1 - (nPrc1 * 0.17)
                nPrc3 := CustomRound(nPrc3)
                oCor := oVerde
            ENDIF


			aadd(aColsEx,{oCor,PRDLOCAL->B1_COD,;
				PRDLOCAL->B1_DESC,PRDLOCAL->B0_PRV1,nPrc1,nPrc2,nPrc3,.F.})
			PRDLOCAL->(DbSkip())
		ENDDO
		PRDLOCAL->(DbCloseArea())
	ENDIF


Return

//função responsavel por atualizar os PREÇOS no produto
Static Function Processar(aCols)
	Local i := 0
	For i := 1 to len(aCols)

		IF aCols[i,getPosCab("PRECO1")] > 0 .and. !EMPTY(aCols[i,getPosCab("CODIGO")]) .AND. aCols[i,getPosCab("IMAGEM")] == oVerde
            //atualização via update evitando lock para area de vendas
			_cSql := " UPDATE "+RETSQLNAME("SB0")+" SET "
			_cSql += " B0_PRV1 = "+cValToChar(aCols[i,getPosCab("PRECO1")])+", "
			_cSql += " B0_PRV2 = "+cValToChar(aCols[i,getPosCab("PRECO2")])+", "
			_cSql += " B0_PRV3 = "+cValToChar(aCols[i,getPosCab("PRECO3")])+" "
			_cSql += " WHERE B0_COD = '"+aCols[i,getPosCab("CODIGO")]+"' "
			_cSql += " AND D_E_L_E_T_ = ' ' "
			TCSQLEXEC(_cSql)
			_cSql := " UPDATE "+RETSQLNAME("SB1")+" SET "
			_cSql += " B1_PRV1 = "+cValToChar(aCols[i,getPosCab("PRECO1")])+" "
			_cSql += " WHERE B1_COD = '"+aCols[i,getPosCab("CODIGO")]+"' "
			_cSql += " AND D_E_L_E_T_ = ' ' "
			TCSQLEXEC(_cSql)


			DbSelectArea("ZZ6")
			RECLOCK("ZZ6",.T.)
			ZZ6->ZZ6_FILIAL	 := XFILIAL("ZZ6")
			ZZ6->ZZ6_PRODUTO := aCols[i,getPosCab("CODIGO")]
			ZZ6->ZZ6_PRECO   := aCols[i,getPosCab("PRECO1")]
			ZZ6->ZZ6_DATA    := DDATABASE
			ZZ6->ZZ6_ORIGEM  := "Reajuste Linear por %"
			ZZ6->ZZ6_USUARI  := UsrRetName(RetCodUsr())
			ZZ6->(MSUNLOCK())


		ENDIF

	Next
    MsgInfo("Preços atualizados com sucesso!")
    oDlg:End()
Return


Static Function getPosCab(_cCampo)
Local nPos := 0
	nPos := aScan(aCabecalho,{ |x| ALLTRIM(x[2]) == _cCampo })
Return nPos


Static Function CustomRound(nPrc)
IF nPrc < 10
    nPrc := ROUND(nPrc,1)
ELSE
    nDecimal:=nPrc-int(nPrc)
    if nDecimal < 0.50
        nPrc:=int(nPrc)+0.50
    else
        nPrc:=int(nPrc)+1
    Endif
ENDIF


Return nPrc
