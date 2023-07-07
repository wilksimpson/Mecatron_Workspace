#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} SugestCO
Grava dados da sugestão de compras.
@type function
@version  1.0
@author Wilk Lima
@since 15/02/2022
/*/

User Function SugestCO()
	Local aArea       := GetArea()
	Local cTabela     := "ZZ1"
	Private aCores    := {}
	Private cCadastro := "Sugestão de Compras Mecatron"
	Private aRotina   := {}


	chkfile("ZZ1")
	chkfile("ZZ2")
	//Montando o Array aRotina, com funções que serão mostradas no menu

	AADD(aRotina, { "Pesquisar" , "AxPesqui"  , 0, 1 })
	AADD(aRotina, { "Visualizar", "AxVisual"  , 0, 2 })
	AADD(aRotina, { "Incluir"   , "AxInclui"  , 0, 3 })
	AADD(aRotina, { "Alterar"   , "U_AltSug"  , 0, 4 })
	AADD(aRotina, { "Excluir"   , "AxDeleta"  , 0, 5 })
	AADD(aRotina, { "Processar" , "U_ProcSug" , 0, 6 })
	AADD(aRotina, { "Gerar Ped Compra"  , "U_EfetSug" , 0, 7 })


	//Montando as cores da legenda
	aAdd(aCores,{"ZZ1_STATUS == '1' ", "BR_VERDE" })
	aAdd(aCores,{"ZZ1_STATUS == '2' ", "BR_AZUL" })
	aAdd(aCores,{"ZZ1_STATUS == '3' ", "BR_VERMELHO" })

	//Selecionando a tabela e ordenando
	DbSelectArea(cTabela)
	(cTabela)->(DbSetOrder(1))

	//Montando o Browse
	mBrowse(6, 1, 22, 75, cTabela, , , , , , aCores )

	//Encerrando a rotina
	(cTabela)->(DbCloseArea())
	RestArea(aArea)
Return


/*/{Protheus.doc} ProcSug
    (Processa Sugetão de compras, de acordo com os parâmetros informado pelo usuário.)
    @type Function
    @author Wilk Lima
    @since 17/02/2022
    @version 1.0
    @param tabela ZZ1
    @example 
    ProcSug()
/*/
User Function ProcSug()
	Local _cCodFab    := ZZ1->ZZ1_CODFAB
	Local _cCodGrup   := ZZ1->ZZ1_GRUPOS
	Local _dDatai     := dDataBase-1
	Local _dDataf     := dDataBase-1
	Local _nCobertura := ZZ1->ZZ1_DIAS
	Local _cMesesM    := ZZ1->ZZ1_MESESM
	Local _cQry       := ""
	Local _cStatus    := ZZ1->ZZ1_STATUS
	Local QRY_UPD     := ''
	Local nStatus
	Local _aGrupo
	Local xi
	lOCAL CodSugest := ZZ1->ZZ1_CODIGO
	Local _nQtdSug  := 0
	Local _nSaldo  := 0
	local _nVlrEst  := 0

	IF _cStatus == "3"
		MsgInfo("Sugestão já efetivada.", "Atenção")
		Return
	ENDIF

	// verifica se já existe registro processado para sugestão.
	DbSelectArea("ZZ2")
	DbSetOrder(1)
	IF DbSeek(xFilial("ZZ2")+CodSugest)
		if MsgYesNo("Já existem dados na sugestão de compras, deseja reprocessar? Isso apagará todos os dados processados anteriormente.", "Atenção")
			QRY_UPD := " DELETE FROM "+RetSqlname("ZZ2")+" "
			QRY_UPD += " WHERE D_E_L_E_T_<>'*' AND ZZ2_FILIAL = '"+XFILIAL("ZZ2")+"' AND ZZ2_CODSUG = '"+CodSugest+"' "
			nStatus := TCSqlExec(QRY_UPD)
			if (nStatus < 0)
				conout("TCSQLError() " + TCSQLError())
			endif
		else
			Return
		Endif
	Endif

	// ajusta parametro de data incial para
	IF _cMesesM=='1'
		_dDatai := _dDatai-30
	elseif _cMesesM=='2'
		_dDatai := _dDatai-60
	else
		_dDatai := _dDatai-90
	Endif

	// Se for preenchido algum valor no parametro grupo, ajusta os dados para o SQL
	IF !Empty(_cCodGrup)
		_aGrupo := StrTokArr(_cCodGrup,",;")
		_cCodGrup := ''
		for xi := 1 to len(_aGrupo)
			if xi > 1
				_cCodGrup +=","
			ENDIF
			_cCodGrup += "'"+alltrim(_aGrupo[xi])+"'"
		next xi
	ENDIF

	//-- Busca dados de vendas na SD2 para compor a média de consumo
	_cQry += " SELECT ULTPRC, CODIGO, REFERENCIA, DESCRICAO, SUM(QTDSAIDA-DEVOLUCAO) AS QUANTIDADE, "
	_cQry += " (CASE WHEN ROUND(SUM(QTDSAIDA-DEVOLUCAO)/"+_cMesesM+",0)=0 THEN 1 ELSE ROUND(SUM(QTDSAIDA-DEVOLUCAO)/"+_cMesesM+",0) END)  AS MEDIA, B2.B2_QATU AS SALDO, GRUPO, "
	_cQry += " ISNULL((SELECT TOP 1 A5_FORNECE+'|'+A5_LOJA+'|'+A5_NOMEFOR FROM "+RetSqlName("SA5")+" A5 WHERE A5.D_E_L_E_T_<>'*' AND A5_PRODUTO = CODIGO AND A5_FILIAL='"+xFilial("SA5")+"' ORDER BY R_E_C_N_O_ ),'') AS DADOS_FORNECEDOR, "
	_cQry += " ISNULL((SELECT SUM(C7_QUANT-C7_QUJE) FROM "+RetSqlName("SC7")+" C7 WHERE C7.D_E_L_E_T_<>'*' AND C7_PRODUTO = CODIGO AND C7_FILIAL='"+xFilial("SC7")+"' AND C7_QUJE<C7_QUANT AND C7_ENCER='' GROUP BY C7_PRODUTO ),0) AS DADOS_COMPRA "
	_cQry += " FROM ( "
	_cQry += " SELECT B1_UPRC AS ULTPRC,D2_COD CODIGO,B1_REFER REFERENCIA,B1_DESC DESCRICAO, D2_QUANT AS QTDSAIDA, D2_QTDEDEV AS DEVOLUCAO, B1_GRUPO GRUPO "
	_cQry += " FROM "+RetSqlName("SD2")+" AS D2 INNER JOIN "+RetSqlName("SF4")+" AS F4 "
	_cQry += " ON SUBSTRING(D2.D2_FILIAL,1,2)=F4.F4_FILIAL AND D2.D2_TES=F4.F4_CODIGO AND F4.D_E_L_E_T_<>'*' INNER JOIN "+RetSqlName("SB1")+" B1 "
	_cQry += " ON D2.D2_COD=B1.B1_COD AND B1.B1_FILIAL = '"+XFILIAL("SB1")+"' AND B1_MSBLQL<>'1' AND B1_TIPO='ME' AND B1.B1_FLAGSUG='1' AND B1.D_E_L_E_T_<>'*' "
	_cQry += " WHERE D2.D_E_L_E_T_<>'*'   "
	_cQry += " AND D2.D2_FILIAL='"+XFILIAL("SD2")+"' "
	_cQry += " AND D2.D2_LOCAL='01' AND ( (F4.F4_DUPLIC='S' AND F4_ESTOQUE='S') OR ( F4.F4_CODIGO='507')) "
	_cQry += " AND  D2.D2_EMISSAO BETWEEN '"+DTOS(_dDatai)+"' AND '"+DTOS(_dDataf)+"' "
	IF !EMPTY(_cCodFab)
		_cQry += " AND  B1.B1_CODFAB='"+ALLTRIM(_cCodFab)+"' "
	ENDIF
	IF !Empty(_cCodGrup)
		_cQry += " AND  B1.B1_GRUPO IN ("+_cCodGrup+") "
	ENDIF
	// Busca dados de requisições do estoque para compor o consumo médio.
	_cQry += " UNION ALL "
	_cQry += " SELECT B1_UPRC AS ULTPRC,D3_COD CODIGO,B1_REFER REFERENCIA,B1_DESC DESCRICAO, "
	_cQry += " (CASE F5_TIPO WHEN 'R' THEN D3_QUANT ELSE 0 END) AS QTDSAIDA, "
	_cQry += " (CASE F5_TIPO WHEN 'D' THEN D3_QUANT ELSE 0 END) AS DEVOLUCAO, B1_GRUPO GRUPO "
	_cQry += " FROM "+RetSqlName("SD3")+" AS D3 INNER JOIN "+RetSqlName("SF5")+" AS F5 "
	_cQry += " ON F5.F5_FILIAL='"+xFilial("SF5")+"' AND D3.D3_TM=F5.F5_CODIGO AND F5.F5_VAL='N' AND F5.F5_QTDZERO='2' AND F5.D_E_L_E_T_<>'*' INNER JOIN "+RetSqlName("SB1")+" B1 "
	_cQry += " ON D3.D3_COD=B1.B1_COD AND B1.B1_FILIAL = '"+XFILIAL("SB1")+"' AND B1_MSBLQL<>'1' AND B1_TIPO='ME' AND B1.B1_FLAGSUG='1' AND B1.D_E_L_E_T_<>'*' "
	_cQry += " WHERE D3.D_E_L_E_T_<>'*' "
	_cQry += " AND D3.D3_FILIAL='"+XFILIAL("SD3")+"' "
	_cQry += " AND D3.D3_LOCAL='01' "
	_cQry += " AND D3.D3_EMISSAO BETWEEN '"+DTOS(_dDatai)+"' AND '"+DTOS(_dDataf)+"' "
	IF !EMPTY(_cCodFab)
		_cQry += " AND  B1.B1_CODFAB='"+ALLTRIM(_cCodFab)+"' "
	ENDIF
	IF !Empty(_cCodGrup)
		_cQry += " AND  B1.B1_GRUPO IN ("+_cCodGrup+") "
	ENDIF
	_cQry += " ) AS TMP "
	_cQry += " INNER JOIN "+RetSqlname("SB2")+" B2 ON B2.B2_FILIAL = '"+XFILIAL("SB2")+"' AND B2.B2_COD=CODIGO AND B2.B2_LOCAL='01' AND B2.D_E_L_E_T_<>'*' "
	_cQry += " GROUP BY CODIGO,ULTPRC, REFERENCIA, DESCRICAO, B2.B2_QATU, GRUPO "
	_cQry += " HAVING SUM(QTDSAIDA-DEVOLUCAO)>0 "
	_cQry += " ORDER BY QUANTIDADE DESC "
	DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQry), "PRDLOCAL", .T., .F. )

	cCodFor := Padr("    ",TamSx3("A2_COD")[1])
	cLojFor := Padr("    ",TamSx3("A2_LOJA")[1])
	cNomeFor := Padr("    ",TamSx3("A5_NOMEFOR")[1])

	DO WHILE !PRDLOCAL->(Eof())
		aFor := Separa(PRDLOCAL->DADOS_FORNECEDOR,'|',.T.)

		IF LEN(aFor) > 1
			cCodFor := aFor[1]
			cLojFor := aFor[2]
			cNomeFor := aFor[3]
		ENDIF

		if PRDLOCAL->SALDO < 0
			_nSaldo := 0
		else
			_nSaldo := PRDLOCAL->SALDO
		endif

		// cálcula sugestão de compra de acordo com dados levantados e parametros da sugestão.
		_nQtdSug := 0
		_nQtdSug := ((PRDLOCAL->MEDIA/30)*_nCobertura)-_nSaldo

		// grava dados da sugestão
		IF _nQtdSug > 0
			RecLock("ZZ2",.T.)
			ZZ2->ZZ2_FILIAL := xFilial("ZZ2")
			ZZ2->ZZ2_CODSUG := CodSugest
			ZZ2->ZZ2_COD    := PRDLOCAL->CODIGO
			ZZ2->ZZ2_DESC   := PRDLOCAL->DESCRICAO
			ZZ2->ZZ2_REFER  := PRDLOCAL->REFERENCIA
			ZZ2->ZZ2_QTDPED := PRDLOCAL->DADOS_COMPRA
			ZZ2->ZZ2_ESTOQU := PRDLOCAL->SALDO
			ZZ2->ZZ2_CONSUM := PRDLOCAL->QUANTIDADE
			ZZ2->ZZ2_MEDIA  := PRDLOCAL->MEDIA
			ZZ2->ZZ2_SUGEST := _nQtdSug // quantidade sugerida
			ZZ2->ZZ2_ACOMPR := round(_nQtdSug,0) //quantidade sugerida
			ZZ2->ZZ2_ULTPRC := PRDLOCAL->ULTPRC
			ZZ2->ZZ2_GRUPO  := PRDLOCAL->GRUPO
			ZZ2->ZZ2_CODFOR := cCodFor
			ZZ2->ZZ2_LJFORN := cLojFor
			ZZ2->ZZ2_FORNEC := cNomeFor
			ZZ2->ZZ2_SELEC  := ""
			MsUnlock()
			// Totaliza valor estimado.
			_nVlrEst += (_nQtdSug*PRDLOCAL->ULTPRC)
		ENDIF
		PRDLOCAL->(DbSkip())
	ENDDO
	// Atualiza valor estimado.
	RecLock("ZZ1",.F.)
	ZZ1->ZZ1_VLESTI := _nVlrEst
	ZZ1->ZZ1_STATUS := "2"
	MsUnlock()
	PRDLOCAL->(DbCloseArea())
Return


/*/{Protheus.doc} AltSug
    (Altera Dados da Sugestão de compras processada.)
    @type Function
    @author Wilk Lima
    @since 21/02/2022
    @version 1.0
    @param ZZ2
    @example 
    AltSug()
/*/

User Function AltSug()
	Local _cArea := GetArea()
	Private aaCampos  	:= {"PEDIDO","ULTPRC","CODFOR","LOJFOR","SELEC"} //Variável contendo o campo editável no Grid
	Private oLista                    //Declarando o objeto do browser
	Private aCabecalho  := {}         //Variavel que montarÃ¡ o aHeader do grid
	Private aColsEx 	:= {}         //VariÃ¡vel que receberÃ¡ os dados
	Private oVerde  	:= LoadBitmap( GetResources(), "BR_VERDE")
	Private oAzul  		:= LoadBitmap( GetResources(), "BR_AZUL")
	Private oVermelho	:= LoadBitmap( GetResources(), "BR_VERMELHO")
	Private oAmarelo	:= LoadBitmap( GetResources(), "BR_AMARELO")
	Private oOk			:= LoadBitMap(GetResources(), "LBOK")
	Private oNo			:= LoadBitMap(GetResources(), "LBNO")


	// verifica se o STATUS permite alteração
	IF ZZ1->ZZ1_STATUS=='1'
		MsgInfo("Sugestão de compras ainda não foi processada, favor processar sugestão antes de alterar","Atenção")
		Return
	ENDIF

	IF ZZ1->ZZ1_STATUS=='3'
		MsgInfo("Sugestão de compras já foi efetivada","Atenção")
		Return
	ENDIF


	DEFINE FONT oFont1 NAME "Arial" SIZE 0,14 BOLD

	aSize := MsAdvSize()

	DEFINE MSDIALOG oDlg TITLE "Sugestão de Compras" FROM aSize[7],0 To aSize[6],aSize[5]  PIXEL
	CriaCab()
	cLinOk         := 'ExecBlock("VSOLICOM",.F.,.F.,{1})'
	CarZZ2()

	oDlg:lMaximized := .T.
	oLista := MsNewGetDados():New( 200, 010, 365, 350, GD_UPDATE, cLinOk, "AllwaysTrue", "AllwaysTrue", aACampos,1, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aCabecalho, aColsEx,{ || oLista:oBrowse:Refresh() })
	oLista:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT //CONTROL_ALIGN_BOTTOM
	oLista:oBrowse:SetFocus()
	oLista:AddAction("SELEC", {|x| ExecBlock("VSOLICOM",.F.,.F.,{3})} ) 
	// configura pintura da TGridLocal
	_cCss:= "QTableView{ alternate-background-color: #f7f7f7; background: #ffffff; selection-background-color: #a9d19f;font-size: 16px; }"
	_cCss+= "QTableView::item:hover { background-color: #ddedd2;font-weight: 400;}"

	// configura pintura do Header da TGrid
	_cCss+= "QHeaderView::section { background-color: qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #ffffff, stop: 0.5 #ffffff, stop: 0.6 #ededed,  stop:1 #ededed); color: black; padding-left: 4px; border: 1px solid #6c6c6c; }"

	oLista:oBrowse:SetCss(_cCss)



	//EnchoiceBar(oDlg, {|| ProcAlter(oLista:aCols), {|| oDlg:End() } })
	EnchoiceBar(oDlg, {|| ProcAlter(oLista:aCols) }, {|| oDlg:End() })
	ACTIVATE MSDIALOG oDlg CENTERED

	Restarea(_cArea)
Return


//função responsavel por definir as colunas e suas caracteristicas
Static Function CriaCab()
	Aadd(aCabecalho, {;
		"",;//X3Titulo()
	"IMAGEM",;  //X3_CAMPO
	"@BMP",;		//X3_PICTURE
	3,;			//X3_TAMANHO
	0,;			//X3_DECIMAL
	"",;			//X3_VALID
	"",;			//X3_USADO
	"C",;			//X3_TIPO
	"",; 			//X3_F3
	"V",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	"",;			//X3_WHEN
	"V"})			//
	Aadd(aCabecalho, {;
		"Seleção",;//X3Titulo()
	"SELEC",;  //X3_CAMPO
	"@BMP",;	//X3_PICTURE
	3,;			//X3_TAMANHO
	0,;			//X3_DECIMAL
	'ExecBlock("VSOLICOM",.F.,.F.,{3})',;			//X3_VALID
	"",;			//X3_USADO
	"C",;			//X3_TIPO
	"",; 			//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	"",;			//X3_WHEN
	"A"})			//
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
		"Referencia",;	//X3Titulo()
	"REFERENCIA",;  	//X3_CAMPO
	"@!",;		//X3_PICTURE
	TamSX3("B1_REFER")[1],;			//X3_TAMANHO
	TamSX3("B1_REFER")[2],;			//X3_DECIMAL
	"",;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("B1_REFER")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Qtd em Pedido",;	//X3Titulo()
	"DADOS_COMPRA",;  	//X3_CAMPO
	"@E 999,999.99",;		//X3_PICTURE
	TamSX3("ZZ2_QTDPED")[1],;			//X3_TAMANHO
	TamSX3("ZZ2_QTDPED")[2],;			//X3_DECIMAL
	'',;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("ZZ2_QTDPED")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Estoque Atual",;	//X3Titulo()
	"SALDO",;  	//X3_CAMPO
	"@E 9,999,999,999,999.99",;		//X3_PICTURE
	TamSX3("B2_QATU")[1],;			//X3_TAMANHO
	TamSX3("B2_QATU")[2],;			//X3_DECIMAL
	'',;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("B2_QATU")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Qtd. Vendida",;	//X3Titulo()
	"QTDVEN",;  	//X3_CAMPO
	"@E 9,999,999,999,999.99",;		//X3_PICTURE
	TamSX3("B2_QATU")[1],;			//X3_TAMANHO
	TamSX3("B2_QATU")[2],;			//X3_DECIMAL
	'',;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("B2_QATU")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Media",;	//X3Titulo()
	"MEDIA",;  	//X3_CAMPO
	"@E 9,999,999,999,999.99",;		//X3_PICTURE
	TamSX3("B2_QATU")[1],;			//X3_TAMANHO
	TamSX3("B2_QATU")[2],;			//X3_DECIMAL
	'',;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("B2_QATU")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Sugestao",;	//X3Titulo()
	"SUGESTAO",;  	//X3_CAMPO
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
		"A Comprar",;	//X3Titulo()
	"PEDIDO",;  	//X3_CAMPO
	"@E 9,999,999,999,999.99",;		//X3_PICTURE
	TamSX3("B0_PRV1")[1],;			//X3_TAMANHO
	TamSX3("B0_PRV1")[2],;			//X3_DECIMAL
	'ExecBlock("VSOLICOM",.F.,.F.,{2})',;
		"",;			//X3_USADO
	TamSX3("B0_PRV1")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Ult. Prc",;	//X3Titulo()
	"ULTPRC",;  	//X3_CAMPO
	"@E 9,999,999,999,999.99",;		//X3_PICTURE
	TamSX3("B1_UPRC")[1],;			//X3_TAMANHO
	TamSX3("B1_UPRC")[2],;			//X3_DECIMAL
	'ExecBlock("VSOLICOM",.F.,.F.,{2})',;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("B1_UPRC")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Fornecedor",;	//X3Titulo()
	"CODFOR",;  	//X3_CAMPO
	"@!",;		//X3_PICTURE
	TamSX3("A2_COD")[1],;			//X3_TAMANHO
	TamSX3("A2_COD")[2],;			//X3_DECIMAL
	'ExecBlock("VSOLICOM",.F.,.F.,{2})',;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("A2_COD")[3],;			//X3_TIPO
	"SA2",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Loja",;	//X3Titulo()
	"LOJFOR",;  	//X3_CAMPO
	"@!",;		//X3_PICTURE
	TamSX3("A2_LOJA")[1],;			//X3_TAMANHO
	TamSX3("A2_LOJA")[2],;			//X3_DECIMAL
	'ExecBlock("VFORSUG",.F.,.F.,{2})',;			//X3_VALID VFORSUG()
	"",;			//X3_USADO
	TamSX3("A2_LOJA")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Nome Fornecedor",;	//X3Titulo()
	"NOMFOR",;  	//X3_CAMPO
	"@!",;		//X3_PICTURE
	TamSX3("A2_NOME")[1],;			//X3_TAMANHO
	TamSX3("A2_NOME")[2],;			//X3_DECIMAL
	"",;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("A2_NOME")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN

Return

//função responsavel por detectar e validar alterações do usuario
User Function VSOLICOM()
	_bRet := .T.

	IF PARAMIXB[1] == 1 //usuario mudou de linha

	ENDIF

	IF PARAMIXB[1] == 2 //validação do campo PEDIDO
		if M->PEDIDO <> aCols[N,getPosCab("PEDIDO")]
			aCols[N,getPosCab("IMAGEM")] := oVerde
		ELSE
			aCols[N,getPosCab("IMAGEM")] := oVermelho
		ENDIF
		if M->PEDIDO > 0
			aCols[N,getPosCab("SELEC")] := oOk
			aCols[N,getPosCab("IMAGEM")] := oVerde
		endif
	ENDIF

	IF PARAMIXB[1] == 3 //validação do campo SELEÇÃO
		if aCols[N,getPosCab("SELEC")] == oNo
			aCols[N,getPosCab("SELEC")] := oOk
			aCols[N,getPosCab("IMAGEM")] := oVerde
		ELSE
			aCols[N,getPosCab("SELEC")] := oNo
			aCols[N,getPosCab("IMAGEM")] := oVerde
		ENDIF
	ENDIF

Return _bRet

// CRREGA DADOS PROCESSADOS NA ZZ2
Static Function CarZZ2()
	_cQry := " SELECT ZZ2_COD CODIGO, ZZ2_DESC DESCRICAO,ZZ2_REFER REFERENCIA, ZZ2_QTDPED DADOS_COMPRA,"
	_cQry += " ZZ2_ESTOQU SALDO, ZZ2_CONSUM QUANTIDADE, ZZ2_MEDIA MEDIA, ZZ2_SUGEST SUGESTAO, "
	_cQry += " ZZ2_ACOMPR PEDIDO ,ZZ2_ULTPRC ULTPRC, ZZ2_CODFOR CODFOR,ZZ2_LJFORN LOJFOR, ZZ2_FORNEC NOMFOR, ZZ2_SELEC SELEC
	_cQry += " FROM "+RetSqlName("ZZ2")+" ZZ2 "
	_cQry += " WHERE ZZ2.D_E_L_E_T_<>'*' AND ZZ2_FILIAL='"+xFilial("ZZ2")+"' AND ZZ2_CODSUG='"+ZZ1->ZZ1_CODIGO+"' "

	DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQry), "PRDLOCAL", .T., .F. )

	aColsEx := {}
	DO WHILE !PRDLOCAL->(Eof())

		aadd(aColsEx,{oVermelho,if(empty(PRDLOCAL->SELEC),oNo,oOk),;
		PRDLOCAL->CODIGO,PRDLOCAL->DESCRICAO,PRDLOCAL->REFERENCIA,PRDLOCAL->DADOS_COMPRA,PRDLOCAL->SALDO,PRDLOCAL->QUANTIDADE,PRDLOCAL->MEDIA,PRDLOCAL->SUGESTAO,PRDLOCAL->PEDIDO,PRDLOCAL->ULTPRC,PRDLOCAL->CODFOR,PRDLOCAL->LOJFOR,PRDLOCAL->NOMFOR,.F.})
		PRDLOCAL->(DbSkip())
	ENDDO
	PRDLOCAL->(DbCloseArea())

Return


// Grava alterações do usuários nos Acols na ZZ2 e ZZ1
Static Function ProcAlter(aCols)
	Local i := 0
//	Local _bRet := .T.
	Local _nVlrEst := 0

	For i:=1 to Len(aCols)

		// ATUALIZA TOTAL ESTIMADO
		if aCols[i][getPosCab("SELEC")]==oOk
		_nVlrEst += (aCols[i][getPosCab("PEDIDO")]*aCols[i][getPosCab("ULTPRC")])
		endif
		//GRAVA ZZ2 APENAS NO QUE FOI ALTERADO PELO USUÁRIO
		IF aCols[i][getPosCab("IMAGEM")] == oVerde

			// Grava alterações do usuário na ZZ2 // {"PEDIDO","ULTPRC","CODFOR","LOJFOR","NOMFOR"}
			DbSelectArea("ZZ2")
			DbSetOrder(1)
			IF DbSeek(xFilial("ZZ2")+ZZ1->ZZ1_CODIGO+aCols[i][getPosCab("CODIGO")])
				RecLock("ZZ2",.F.)
				ZZ2->ZZ2_SELEC := if( aCols[i][getPosCab("SELEC")]==oOk,"ok","") 
				ZZ2->ZZ2_ACOMPR := aCols[i][getPosCab("PEDIDO")]
				ZZ2->ZZ2_CODFOR := aCols[i][getPosCab("CODFOR")]
				ZZ2->ZZ2_FORNEC := aCols[i][getPosCab("NOMFOR")]
				ZZ2->ZZ2_LJFORN := aCols[i][getPosCab("LOJFOR")]
				ZZ2->ZZ2_ULTPRC := aCols[i][getPosCab("ULTPRC")]
				MsUnlock()
			ENDIF

		ENDIF

	Next

	if _nVlrEst>0
		RecLock("ZZ1",.F.)
		ZZ1->ZZ1_VLESTI := _nVlrEst
		MsUnlock()
	ENDIF
	oDlg:End()
Return

// retorna posição do campo no acols
Static Function getPosCab(_cCampo)
	Local nPos := 0
	nPos := aScan(aCabecalho,{ |x| ALLTRIM(x[2]) == _cCampo })
Return nPos

//função responsavel por detectar e validar alterações do usuario
User Function VFORSUG()
	local _cCodF := aCols[N,getPosCab("CODFOR")]
	local _cLJF  := M->LOJFOR
	_bRet := .T.

	IF PARAMIXB[1] == 2 //validação do campo PEDIDO
		aCols[N,getPosCab("IMAGEM")] := oVerde
	ENDIF

	//VALIDA FORNECEDOR
	IF EMPTY(_cCodF) .OR. EMPTY(_cLJF)
		Alert("Codigo de fornecedor invalido")
		_bRet := .F.
	ELSE
		DbSelectArea("SA2")
		DbSetOrder(1)
		IF DbSeek(XFILIAL("SA2")+_cCodF+_cLJF)
			aCols[N,getPosCab("NOMFOR")] := SA2->A2_NOME
		else
			Alert("Codigo de fornecedor nao existe no cadastro de fornecedores")
			_bRet := .F.
		ENDIF
	ENDIF

Return _bRet


User Function EfetSug()
	Local _Forneced := ""
	Local _LjFornec := ""
	Local aDados 	:= {}
	Local _cPedidos := ""

	if ZZ1_STATUS =='1'
		MsgInfo("A sugestão de compras não foi processada.","Atenção")
		Return
	endif

	_cQry := " SELECT ZZ2_COD CODIGO, ZZ2_DESC DESCRICAO,ZZ2_REFER REFERENCIA, "
	_cQry += " ZZ2_ESTOQU SALDO, ZZ2_CONSUM QUANTIDADE, ZZ2_MEDIA MEDIA, ZZ2_SUGEST SUGESTAO, "
	_cQry += " ZZ2_ACOMPR PEDIDO ,ZZ2_ULTPRC ULTPRC, ZZ2_CODFOR CODFOR,ZZ2_LJFORN LOJFOR, ZZ2_FORNEC NOMFOR
	_cQry += " FROM "+RetSqlName("ZZ2")+" ZZ2 "
	_cQry += " WHERE ZZ2.D_E_L_E_T_<>'*' AND ZZ2_FILIAL='"+xFilial("ZZ2")+"' AND ZZ2_CODSUG='"+ZZ1->ZZ1_CODIGO+"' "
	_cQry += " AND ZZ2_ULTPRC>0 AND ZZ2_CODFOR>' ' AND ZZ2_LJFORN>' ' AND ZZ2_ACOMPR>0 AND ZZ2_SELEC>' ' "
	_cQry += " ORDER BY  ZZ2_CODFOR,ZZ2_LJFORN,ZZ2_COD "
	DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQry), "TMPSUGEST", .T., .F. )

	_Forneced := TMPSUGEST->CODFOR
	_LjFornec := TMPSUGEST->LOJFOR

	DO WHILE !TMPSUGEST->(Eof())

		// Controla registro, até quando mudar o fornecedor.
		if _Forneced+_LjFornec == TMPSUGEST->CODFOR+TMPSUGEST->LOJFOR
			aadd(aDados,{TMPSUGEST->CODIGO,TMPSUGEST->PEDIDO,TMPSUGEST->ULTPRC})
		else
			// envia para gravação registros atuais.
			_cPedidos += GerPed(aDados,_Forneced,_LjFornec)+", "
			// zera array de itens
			aDados := {}
			// adiciona no array, o registro atual.
			aadd(aDados,{TMPSUGEST->CODIGO,TMPSUGEST->PEDIDO,TMPSUGEST->ULTPRC})
			// Salva código do prox. fornecedor
			_Forneced := TMPSUGEST->CODFOR
			_LjFornec := TMPSUGEST->LOJFOR
		endif

		TMPSUGEST->(DbSkip())
	ENDDO
	// envia para gravação registros atuais.
	_cPedidos += GerPed(aDados,_Forneced,_LjFornec)
	TMPSUGEST->(DbCloseArea())

	if !empty(_cPedidos)
		RecLock("ZZ1",.F.)
		ZZ1->ZZ1_STATUS := '3'
		MsUnlock()
		MsgInfo("Gerado Pedido(s): "+_cPedidos,"Sugestão de Compra Finalizada")
	endif

Return

// Geração de pedido de compra. 
Static Function GerPed(aDados,cCodFor,cLoja)
	Local i := 0
	Local aCab	 := {}
	Local aItens := {}
	Local aLinha := {}
	Local DocGerado := ""


	cDoc := GetSXENum("SC7","C7_NUM")
	SC7->(dbSetOrder(1))
	While SC7->(dbSeek(xFilial("SC7")+cDoc))
		ConfirmSX8()
		cDoc := GetSXENum("SC7","C7_NUM")
	EndDo

	AADD(aCab,{"C7_NUM"       , cDoc,NIL}) // Numero do Pedido
	AADD(aCab,{"C7_EMISSAO"   ,dDataBase   ,NIL}) // Data de Emissao
	AADD(aCab,{"C7_FORNECE"   ,cCodFor     ,NIL}) // Fornecedor
	AADD(aCab,{"C7_LOJA"      ,cLoja       ,NIL}) // Loja do Fornecedor
	AADD(aCab,{"C7_CONTATO"   ,""          ,NIL}) // Contato
	AADD(aCab,{"C7_COND"      ,"001"       ,NIL}) // Condicao de Pagamento
	AADD(aCab,{"C7_FILENT"    ,cFilant     ,NIL}) // Filial de Entrega

	For i:=1 to Len(aDados)

		dbSelectArea("SB1")
		dbSetOrder(1)
		If DbSeek(XFILIAL("SB1")+aDados[i][1])
			nQuant:= aDados[i,2]
			nPrc  := aDados[i,3]
			IF nPrc <= 0
				nPrc := 1
			ENDIF
			IF nQuant > 0
				aLinha:={}
				AADD(aLinha,{"C7_ITEM"      ,StrZero(i,Len(SC7->C7_ITEM)),NIL})
				AADD(aLinha,{"C7_PRODUTO"   ,aDados[i,1],NIL})
				AADD(aLinha,{"C7_QUANT"     ,nQuant    ,NIL})
				AADD(aLinha,{"C7_QTDSOL"    ,nQuant    ,NIL})
				AADD(aLinha,{"C7_UM"        ,SB1->B1_UM             ,NIL})
				AADD(aLinha,{"C7_QTSEGUM"   ,ConvUm(SB1->B1_COD,nQuant,0,2),NIL})
				AADD(aLinha,{"C7_PRECO"     ,nPrc,NIL})
				AADD(aLinha,{"C7_TOTAL"     ,nQuant * nPrc,NIL})
				AADD(aLinha,{"C7_LOCAL"     ,"01"           ,NIL})
				AADD(aLinha,{"C7_TES"       ,"001"         ,NIL})
				AADD(aLinha,{"C7_DESCRI"    ,SB1->B1_DESC   ,NIL})
				aadd(aItens,aLinha)
			ENDIF
		Endif
	Next i

	lMsErroAuto := .F.

	//Utilizar o MsExecAuto para incluir registros na tabela de Pedido, utilizando a opção 3
	MSExecAuto({|v,x,y,z,w|     MATA120(v,x,y,z,w)}     ,1,aCab  ,aItens,3   ,.F.)

	//Caso encontre erro exibir na tela
	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
	ELSE
		DocGerado := cDoc
	EndIf

Return DocGerado

Static Function Disp()
	RecLock("TTRB",.F.)
	If Marked("OK")
		TTRB->OK := cMark
	Else
		TTRB->OK := ""
	Endif

	MSUNLOCK()

	oMark:oBrowse:Refresh()

Return()
