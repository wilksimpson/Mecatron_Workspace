#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} HISTVENDA
Função para mostrar historico de vendas.
@author Wilk Lima
@since 31/11/2022
@version 1.0
@type function
/*/

User Function HISTVENDA()
	//Private aaCampos  	:= {"PRECO1","PRECO2","PRECO3"} //Variavel contendo o campo editÃ¡vel no Grid
	Private oLista                    //Declarando o objeto do browser
	Private aCabecalho  := {}         //Variavel que montara o aHeader do grid
	Private aColsEx 	:= {}         //Variavel que recebera os dados
	Private _dDataIni   := ddatabase-60
	Private _dDataFim   := ddatabase

	DEFINE FONT oFont1 NAME "Arial" SIZE 0,14 BOLD

	aSize := MsAdvSize()
    _nLinIni := 0
    _nColIni := 0
    _nLinFim := aSize[6]
    _nColFim := aSize[5]

		DEFINE MSDIALOG oDlg TITLE "Historico de Vendas" FROM _nLinIni,_nColIni To _nLinFim,_nColFim  PIXEL
			oPanel2 := TPanel():New(30,0,'',oDlg,, .T., .T.,, ,315,20,.T.,.T. ) 
			@003,012 BUTTON "Pesuisar" SIZE 060, 015 PIXEL OF oPanel2 ACTION (funcao1())
			@006,120 SAY "Data De: " SIZE 060, 013 PIXEL OF oPanel2 
			@003,150 GET _dDataIni SIZE 060, 015 PIXEL OF oPanel2 
			@006,250 SAY "Data Até: " SIZE 060, 013 PIXEL OF oPanel2 
			@003,280 GET _dDataFim SIZE 060, 015 PIXEL OF oPanel2 
			
		CriaCab()
		CarHist()
		

		//oDlg:lMaximized := .T.
		oLista := MsNewGetDados():New( 400, 110, 665, 650, GD_UPDATE, /*/cLinOk/*/, "AllwaysTrue", "AllwaysTrue", /*/aACampos/*/,1, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aCabecalho, aColsEx,{ || oLista:oBrowse:Refresh() })
		oLista:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT //CONTROL_ALIGN_BOTTOM
		oLista:oBrowse:SetFocus()
		// configura pintura da TGridLocal
		_cCss:= "QTableView{ alternate-background-color: #f7f7f7; background: #ffffff; selection-background-color: #a9d19f;font-size: 16px; }"
		_cCss+= "QTableView::item:hover { background-color: #ddedd2;font-weight: 400;}"

		// configura pintura do Header da TGrid
		_cCss+= "QHeaderView::section { background-color: qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #ffffff, stop: 0.5 #ffffff, stop: 0.6 #ededed,  stop:1 #ededed); color: black; padding-left: 4px; border: 1px solid #6c6c6c; }"

		oLista:oBrowse:SetCss(_cCss)

		UpdHist()

		EnchoiceBar(oDlg, {|| oDlg:End() },{|| 	oDlg:End() })
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT (oPanel2:Align:=CONTROL_ALIGN_TOP )

Return


//função responsavel por definir as colunas e suas caracteristicas
Static Function CriaCab()
	Aadd(aCabecalho, {;
		" Empresa",;//X3Titulo()
	"EMPRESA",;  //X3_CAMPO
	"@!",;		//X3_PICTURE
	15,;			//X3_TAMANHO
	TamSX3("L1_FILIAL")[2],;			//X3_DECIMAL
	"",;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("L1_FILIAL")[3],;			//X3_TIPO
	"",; 			//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})	
	Aadd(aCabecalho, {;
		"Data",;	//X3Titulo()
	"DATA",;  	//X3_CAMPO
	"",;		//X3_PICTURE
	TamSX3("L1_EMISNF")[1],;			//X3_TAMANHO
	TamSX3("L1_EMISNF")[2],;			//X3_DECIMAL
	"",;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("L1_EMISNF")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Documento",;	//X3Titulo()
	"DOCUMENTO",;  	//X3_CAMPO
	"",;		//X3_PICTURE
	TamSX3("D2_DOC")[1],;			//X3_TAMANHO
	TamSX3("D2_DOC")[2],;			//X3_DECIMAL
	"",;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("D2_DOC")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Cliente",;	//X3Titulo()
	"CLIENTE",;  	//X3_CAMPO
	"",;		//X3_PICTURE
	TamSX3("A1_NOME")[1],;			//X3_TAMANHO
	TamSX3("A1_NOME")[2],;			//X3_DECIMAL
	"",;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("A1_NOME")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Form. Pagto",;	//X3Titulo()
	"FORMPG",;  	//X3_CAMPO
	"",;		//X3_PICTURE
	TamSX3("L1_FORMPG")[1],;			//X3_TAMANHO
	TamSX3("L1_FORMPG")[2],;			//X3_DECIMAL
	"",;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("L1_FORMPG")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN	
	Aadd(aCabecalho, {;
		"Quantidade",;	//X3Titulo()
	"QUANT",;  	//X3_CAMPO
	"@E 9,999.99",;		//X3_PICTURE
	TamSX3("L2_QUANT")[1],;			//X3_TAMANHO
	TamSX3("L2_QUANT")[2],;			//X3_DECIMAL
	'',;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("L2_QUANT")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Preço",;	//X3Titulo()
	"PRECO",;  	//X3_CAMPO
	"@E 99,999,999,999.9999",;		//X3_PICTURE
	TamSX3("L2_VRUNIT")[1],;			//X3_TAMANHO
	TamSX3("L2_VRUNIT")[2],;			//X3_DECIMAL
	'',;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("L2_VRUNIT")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Total Item",;	//X3Titulo()
	"TOTAL",;  	//X3_CAMPO
	"@E 9,999,999,999,999.99",;		//X3_PICTURE
	TamSX3("L2_VLRITEM")[1],;			//X3_TAMANHO
	TamSX3("L2_VLRITEM")[2],;			//X3_DECIMAL
	'',;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("L2_VLRITEM")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	
Return

//função responsavel por carregar os preços
Static Function CarHist()

Local _cQry := ""
        _cQry := " SELECT * FROM ( "
        _cQry += " SELECT L1_FILIAL, L1_EMISNF, L1_DOC, A1_NOME, L1_FORMPG, L2_QUANT, L2_VRUNIT, L2_VLRITEM "
        _cQry += " FROM "+RetSqlName("SL1")+" L1 INNER JOIN "
        _cQry += " "+RetSqlName("SL2")+" L2 ON L1_FILIAL=L2_FILIAL AND  L1_NUM=L2_NUM AND L2.D_E_L_E_T_<>'*' INNER JOIN "
        _cQry += " "+RetSqlName("SA1")+" A1 ON A1_FILIAL='"+XFILIAL("SA1")+"' AND  L1_CLIENTE=A1_COD AND L1_LOJA=A1_LOJA AND A1.D_E_L_E_T_<>'*' "
        _cQry += " WHERE L1.D_E_L_E_T_ <> '*' "
        _cQry += " AND L2_PRODUTO = '"+SB1->B1_COD+"' AND L1_EMISNF BETWEEN '"+DTOS(_dDataIni)+"' AND '"+DTOS(_dDataFim)+"' "
        _cQry += " AND (L1.L1_TIPO <> '') AND (L1.L1_ORCRES = '') "
        _cQry += " AND (L1.L1_EMISNF <> '') AND ((L1.L1_DOC <> '') OR (L1.L1_DOCPED <> '')) "
        _cQry += " UNION ALL "
        _cQry += " SELECT F2_FILIAL L1_FILIAL, F2_EMISSAO L1_EMISNF, F2_DOC L1_DOC, A1_NREDUZ A1_NOME, "
        _cQry += " F2_COND L1_FORMPG, D2_QUANT L2_QUANT, D2_PRCVEN L2_VRUNIT, D2_TOTAL L2_VLRITEM  "
        _cQry += " FROM "+RetSqlName("SF2")+" F2 INNER JOIN "
        _cQry += " "+RetSqlName("SD2")+" D2 ON F2_FILIAL=D2_FILIAL AND F2_DOC=D2_DOC AND F2_SERIE=D2_SERIE  "
        _cQry += " AND F2_CLIENTE=D2_CLIENTE AND F2_LOJA=D2_LOJA AND F2_TIPO='N' AND D2.D_E_L_E_T_<>'*' INNER JOIN "
        _cQry += " "+RetSqlName("SA1")+" A1 ON A1_FILIAL='01' AND  F2_CLIENTE=A1_COD AND F2_LOJA=A1_LOJA AND A1.D_E_L_E_T_<>'*' "
        _cQry += " WHERE F2.D_E_L_E_T_ <>'*' AND D2_CF IN ('5152','5409','6152','6409') "
        _cQry += " AND D2_COD = '"+SB1->B1_COD+"' AND F2_EMISSAO BETWEEN '"+DTOS(_dDataIni)+"' AND '"+DTOS(_dDataFim)+"' "
        _cQry += " UNION ALL "
        _cQry += " SELECT D3_FILIAL L1_FILIAL, D3_EMISSAO L1_EMISNF, D3_DOC L1_DOC, 'Req. por '+D3_USUARIO A1_NOME,  "
        _cQry += " 'REQ' L1_FORMPG, D3_QUANT L2_QUANT, (D3_CUSTO1/D3_QUANT) L2_VRUNIT, D3_CUSTO1 L2_VLRITEM  "
        _cQry += " FROM "+RetSqlName("SD3")+" D3 "
        _cQry += " WHERE D3.D_E_L_E_T_ <>'*' AND D3_CF IN ('RE0') "
        _cQry += " AND D3_COD = '"+SB1->B1_COD+"' AND D3_EMISSAO BETWEEN '"+DTOS(_dDataIni)+"' AND '"+DTOS(_dDataFim)+"' "
        _cQry += " ) TMP "
        _cQry += " ORDER BY TMP.L1_EMISNF DESC "
		DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQry), "PRDLOCAL", .T., .F. )
		aColsEx := {}
		
        DO WHILE !PRDLOCAL->(Eof())
			aadd(aColsEx,{FWFilName ( cEmpAnt , PRDLOCAL->L1_FILIAL ), stod(PRDLOCAL->L1_EMISNF), PRDLOCAL->L1_DOC,;
			 PRDLOCAL->A1_NOME, PRDLOCAL->L1_FORMPG, PRDLOCAL->L2_QUANT, PRDLOCAL->L2_VRUNIT, PRDLOCAL->L2_VLRITEM, .F.})
			PRDLOCAL->(DbSkip())
		ENDDO

		PRDLOCAL->(DbCloseArea())

Return



//	Executa Funções do Botão Pesquisar.
Static Function funcao1()
  
  CarHist()
  UpdHist()

return
 
// atualiza dados da nova pesquisa
Static Function UpdHist()

	oLista:SetArray(aColsEx)
	oLista:Refresh()
	oDlg:Refresh()

Return
