#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} HISTPRECO
Função para mostrar historico de alteração de preços de venda no sistema.
@author Wilk Lima
@since 26/10/2022
@version 1.0
@type function
/*/

User Function HISTPRECO()
	//Private aaCampos  	:= {"PRECO1","PRECO2","PRECO3"} //Variavel contendo o campo editÃ¡vel no Grid
	Private oLista                    //Declarando o objeto do browser
	Private aCabecalho  := {}         //Variavel que montara o aHeader do grid
	Private aColsEx 	:= {}         //Variavel que recebera os dados

	DEFINE FONT oFont1 NAME "Arial" SIZE 0,14 BOLD

	aSize := MsAdvSize()
    _nLinIni := 0
    _nColIni := 0
    _nLinFim := aSize[6]
    _nColFim := aSize[5]

		DEFINE MSDIALOG oDlg TITLE "Manutenção de Preços" FROM _nLinIni,_nColIni To _nLinFim,_nColFim  PIXEL
		CriaCab()
		//cLinOk         := 'ExecBlock("ATUASB0V",.F.,.F.,{1})'
		CarZZ6()

		oDlg:lMaximized := .T.
		oLista := MsNewGetDados():New( 400, 110, 665, 650, GD_UPDATE, /*/cLinOk/*/, "AllwaysTrue", "AllwaysTrue", /*/aACampos/*/,1, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aCabecalho, aColsEx,{ || oLista:oBrowse:Refresh() })
		oLista:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT //CONTROL_ALIGN_BOTTOM
		oLista:oBrowse:SetFocus()
		// configura pintura da TGridLocal
		_cCss:= "QTableView{ alternate-background-color: #f7f7f7; background: #ffffff; selection-background-color: #a9d19f;font-size: 16px; }"
		_cCss+= "QTableView::item:hover { background-color: #ddedd2;font-weight: 400;}"

		// configura pintura do Header da TGrid
		_cCss+= "QHeaderView::section { background-color: qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #ffffff, stop: 0.5 #ffffff, stop: 0.6 #ededed,  stop:1 #ededed); color: black; padding-left: 4px; border: 1px solid #6c6c6c; }"

		oLista:oBrowse:SetCss(_cCss)

		EnchoiceBar(oDlg, {|| oDlg:End() }, {|| 	oDlg:End() })
		ACTIVATE MSDIALOG oDlg CENTERED

Return


//função responsavel por definir as colunas e suas caracteristicas
Static Function CriaCab()
	Aadd(aCabecalho, {;
		" Data alteração",;	//X3Titulo()
	"DATA",;  	//X3_CAMPO
	"",;		//X3_PICTURE
	TamSX3("ZZ6_DATA")[1],;			//X3_TAMANHO
	TamSX3("ZZ6_DATA")[2],;			//X3_DECIMAL
	"",;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("ZZ6_DATA")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Preço Atualizado",;	//X3Titulo()
	"PRECO",;  	//X3_CAMPO
	"@E 9,999,999,999,999.99",;		//X3_PICTURE
	TamSX3("ZZ6_PRECO")[1],;			//X3_TAMANHO
	TamSX3("ZZ6_PRECO")[2],;			//X3_DECIMAL
	'',;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("ZZ6_PRECO")[3],;			//X3_TIPO
	"",;		//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Usuário Resp. Alteração",;//X3Titulo()
	"USUARIO",;  //X3_CAMPO
	"@!",;		//X3_PICTURE
	TamSX3("ZZ6_USUARI")[1],;			//X3_TAMANHO
	TamSX3("ZZ6_USUARI")[2],;			//X3_DECIMAL
	"",;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("ZZ6_USUARI")[3],;			//X3_TIPO
	"",; 			//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})			//X3_WHEN
	Aadd(aCabecalho, {;
		"Origem da Atualização",;//X3Titulo()
	"ORIGEM",;  //X3_CAMPO
	"@!",;		//X3_PICTURE
	TamSX3("ZZ6_ORIGEM")[1],;			//X3_TAMANHO
	TamSX3("ZZ6_ORIGEM")[2],;			//X3_DECIMAL
	"",;			//X3_VALID
	"",;			//X3_USADO
	TamSX3("ZZ6_ORIGEM")[3],;			//X3_TIPO
	"",; 			//X3_F3
	"R",;			//X3_CONTEXT
	"",;			//X3_CBOX
	"",;			//X3_RELACAO
	""})	

Return

//função responsavel por carregar os preços
Static Function CarZZ6()

Local _cQry := ""

		_cQry := " SELECT ZZ6_DATA,ZZ6_PRECO,ZZ6_USUARI,ZZ6_ORIGEM FROM "+RetSqlName("ZZ6")+" ZZ6 "
		_cQry += " WHERE ZZ6.D_E_L_E_T_ <> '*' "
		_cQry += " AND ZZ6_PRODUT = '"+SB1->B1_COD+"' "
		_cQry += " ORDER BY ZZ6_DATA DESC "
		DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQry), "PRDLOCAL", .T., .F. )
		aColsEx := {}
		
        DO WHILE !PRDLOCAL->(Eof())
			aadd(aColsEx,{STOD(PRDLOCAL->ZZ6_DATA), PRDLOCAL->ZZ6_PRECO, PRDLOCAL->ZZ6_USUARI,PRDLOCAL->ZZ6_ORIGEM, .F.})
			PRDLOCAL->(DbSkip())
		ENDDO

		PRDLOCAL->(DbCloseArea())

Return



