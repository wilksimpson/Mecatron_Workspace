#Include "Protheus.ch"
#include "TopConn.ch"
#INCLUDE "COLORS.CH"
#include "TOTVS.CH"
#include "rwmake.ch"
#DEFINE DS_MODALFRAME 128

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  LJCONPRD   º Autor João Felipe Costa Braga Data ³ 05.02.2021 º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao ³ CONSULTA DE PRODUTOS PERSONALIZADA 					    º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß


User Function LJCONPRD(_cPesq,_nTip)
	Private _lOk
	Private oVerde	  := LoadBitMap(GetResources(), "BR_VERDE")
	Private oVermelho := LoadBitMap(GetResources(), "BR_VERMELHO")
	Private oAzul  	  := LoadBitMap(GetResources(), "BR_AZUL")
	Private opreto  	  := LoadBitMap(GetResources(), "BR_PRETO")
	Private oRosa  	  := LoadBitMap(GetResources(), "BR_PINK")
	
	Private _aDados := {}
	Private _aDados2 := {}
	Private	_nTotOrc := 0
	Private	_nqtd := 0
	Private oDados
	Private oDados2
	Private oProd
	Private oBitMap
	Private _cTitulo := "Consulta Produto "
	Private _aHeader := {}
	Private _aHead2 := {}
	Private _oProd
	Private cProd := SPACE(250)
	Private cProd2 := SPACE(250)
	private aSize := {}
	private cMemo := ""
	private oMemo
	private oLayout1
	private cProduto := SPACE(15)
	private _nInv := 0
	private _cNomFot := ""
	private bModo := .F.

	DEFINE FONT oFont1 NAME "Arial" SIZE 0,20 BOLD

	//OBTEM OS DADOS DA CONSULTA INICIAL, CASO VENHA DO ORÇAMENTO
	_aDados := AtualizaLista(_cPesq,_nTip)

	SetKey(VK_F1, {|| AtivaMod()})

	IF EMPTY(_aDados[1,2]) .and.  FUNNAME() == "LOJA701"
		return .t.
	ENDIF

	//OBTEM AS DIMENSOES DO MONITOR DO USUARIO
	aSize := MsAdvSize()

	DEFINE MSDIALOG oProd TITLE OemToAnsi(_cTitulo)  FROM aSize[7],0 To aSize[6],aSize[5] PIXEL OF oMainWnd
	oPanel := TPanel():New(30,0,'',oProd,, .T., .T.,, ,315,20,.T.,.T. ) 
	@003,012 BUTTON "Selecionar" SIZE 060, 015 PIXEL OF oPanel ACTION (funcao1())
	@003,090 BUTTON "Consultar Ultimas Vendas" SIZE 180, 015 PIXEL OF oPanel ACTION (funcao2())
	@003,280 BUTTON "Historico de Preço" SIZE 180, 015 PIXEL OF oPanel ACTION (funcao3())
	oLayout1:= tGridLayout():New(oProd,CONTROL_ALIGN_ALLCLIENT,0,0)

	//MAXIMIZA A TELA
	oProd:lMaximized := .T.

	oFont  := TFont():New("Courier New",7,20,,.F.,,,,.T.,.F.)

	// CARREGA A GRID DE FORMA DIFERENTE DEPENDENDO DO NIVEL DE USUARIO
	getLBG()
	getLBG2()
	UpdLBG()

	//CRIA O CAMPO MEMO
	oMemo := tMultiget():new( 0, 0, {| u | if( pCount() > 0, cMemo := u, cMemo ) }, ;
		oLayout1, 050, 100, oFont, , , , , .F.,,.F.,,,.T. )
	oMemo:Disable()

	//CRIA O CAMPO IMAGEM
	oBitMap := TBmpRep():New(0,0,0,0,"PRDPAD",.T.,oLayout1,{||visFoto()})

	oBitMap:lAutoSize := .f.
	oBitMap:lstretch :=.t.

	@ 0,0 MSGET _oProd VAR cProd PICTURE "@!" FONT oFont1 SIZE 0,0 Valid BscDados() OF oLayout1 PIXEL

	_oProd:SetCss("  border-style: solid; border-width: 5px; border-color: black;")

	// configura pintura da TGridLocal
	_cCss:= "QTableView{ alternate-background-color: #f7f7f7; background: #ffffff; selection-background-color: #a9d19f }"
	_cCss+= "QTableView::item:hover { background-color: #ddedd2;font-weight: 400;}"

	// configura pintura do Header da TGrid
	_cCss+= "QHeaderView::section { background-color: qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #ffffff, stop: 0.5 #ffffff, stop: 0.6 #ededed,  stop:1 #ededed); color: black; padding-left: 4px; border: 1px solid #6c6c6c; }"

	oDados:SetCss(_cCss)
	oDados2:SetCss(_cCss)
	oLayout1:addInLayout(_oProd , 1, 1,, 4)
	oLayout1:addInLayout(oDados , 2, 1,,4)
	oLayout1:addInLayout(oBitMap , 3, 1,,1)
	oLayout1:addInLayout(oDados2 , 3, 2,,2)
	oLayout1:addInLayout(oMemo , 3, 4,,4)

	Activate Dialog oProd CENTERED ON INIT (oPanel:Align:=CONTROL_ALIGN_TOP )
	IF FUNNAME() == "LOJA701"

		IF !EMPTY(cProduto)
			nQtd := QtdPrd(PADR(cProduto,TamSX3('LQ_PRODUTO')[01]))
			IF nQtd > 0
				M->LQ_PRODUTO := PADR(cValToChar(nQtd)+"*"+ PADR(cProduto,TamSX3('LQ_PRODUTO')[01]),TamSX3('LR_PRODUTO')[01])
			ENDIF
			
		ELSE
			M->LQ_PRODUTO := PADR(cProduto,TamSX3('LQ_PRODUTO')[01])
		ENDIF

		Return !EMPTY(M->LQ_PRODUTO)
	else
		DBSELECTAREA("SB1")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SB1")+PADR(cProduto,TamSX3('B1_COD')[01]))

	ENDIF


Return .T.
//FUNCAO RESPONSAVEL POR EXIBIR A FOTO DO PRODUTO E SEU RESPECTIVO ESTOQUE
STATIC FUNCTION ExibeFoto(_cProd)

	_cNomFot := ""
	//OBTEM A CARACTERISTICA E MARCA DO PRODUTO
	IF !EMPTY(_cProd)
	    dbselectarea("SB1")
    	dbsetorder(1)
	    IF dbSeek(xFilial("SB1") + PADR(ALLTRIM(_cProd),TamSX3('B1_COD')[01])) 
			_cNomFot := SB1->B1_BITMAP

			oBitMap:LoadBmp(_cNomFot)
			oBitMap:lAutoSize := .f.
			oBitMap:lstretch :=.t.

			if !oBitMap:ExistBmp(_cNomFot)
				oBitMap:LoadBmp("SEM_FOTO_IMG")
			endif

			cMemo := "Unidade: "
			cMemo += SB1->B1_UM
			cMemo += "   |  Multiplo: "
			cMemo += ALLTRIM(Transform(SB1->B1_LOTVEN,"@e 9,999,999,999,999.99")) +chr(10)
			cMemo += "Codigo de Barras: "
			cMemo += ALLTRIM(SB1->B1_CODBAR)+chr(10)
			cMemo += "Referencia: "
			cMemo += ALLTRIM(SB1->B1_REFER)+chr(10)
			cMemo += "Fabricante: "
			IF !EMPTY(SB1->B1_CODFAB)
				aFabric := FwGetSX5("FB",SB1->B1_CODFAB)
			ELSE
				aFabric := {}
			ENDIF
			cMemo += ALLTRIM(SB1->B1_CODFAB +" - "+ IIF(LEN(aFabric) >0,aFabric[1][4],"" )) +chr(10)
			cMemo += "Observação: "+chr(10)

			IF !EMPTY(SB1->B1_CODPROC)
				cMemo += MSMM(SB1->B1_CODPROC,48,,,3)
			ENDIF

			_dProm := POSICIONE("SB0",1,XFILIAL("SB0")+SB1->B1_COD,"B0_DATA2")
			IF !EMPTY(_dProm)
				cMemo += "Fim da promoção: "
				cMemo += DTOC(_dProm) +chr(10)
			ENDIF

//			cMemo += SB1->B1_VM_PROC +chr(10)


		ENDIF

	ELSE
		cMemo := ""
	ENDIF

	cQry := " SELECT BZ_EMIN,BZ_EMAX,B2_FILIAL AS FILIAL,B2_COD AS CODIGO,B2_LOCAL AS ARMAZEM,B2_QATU AS ESTFIS,B2_DTINV, "
	cQry += " B2_RESERVA+B2_QEMP AS RESERVA,BZ_DESCLOC AS LOCALIZACAO, "
	cQry += " ISNULL((SELECT SUM(C7_QUANT-C7_QUJE) FROM "+RetSqlName("SC7")+" C7 WHERE C7.d_e_l_e_t_<>'*' AND C7_FILIAL=B2_FILIAL AND (C7_QUANT-C7_QUJE)>0 AND C7_PRODUTO = '"+_cProd+"' ),0) AS PROCCOMP "
	cQry += " FROM "+RetSqlName("SB2")+" B2 INNER JOIN "+ RetSqlName("SBZ")+" BZ ON BZ.d_e_l_e_t_<>'*' AND B2.d_e_l_e_t_ <>'*' AND BZ_FILIAL=B2_FILIAL AND BZ_COD=B2_COD  "
	cQry += " WHERE B2_COD = '"+_cProd+"'"	
	cQry += " ORDER BY B2_FILIAL,B2_LOCAL "

	dbUseArea(.t., "TOPCONN", TcGenQry(,,cQry), "_TMP2", .t.)
	
	_nLinha2 := 0
	_aDados2 := {}
	Do While _TMP2->(!EoF())
		_nLinha2++

		//CASO O ESTOQUE DO PRODUTO SEJA ZERO, ADICIONA A LEGENDA VERMELHA A LINHA
		IF _TMP2->ESTFIS <= 0
			_ret := 1
		ELSE
			_ret := 3
		ENDIF

		aadd(_aDados2,{_ret,; 	//1
			_TMP2->ESTFIS,;	  	//2
			_TMP2->RESERVA,;  	//3
			_TMP2->ESTFIS-_TMP2->RESERVA,; //4
			FWFilName ( SUBSTR(_TMP2->FILIAL,1,2) , _TMP2->FILIAL ),; //5
			ALLTRIM(_TMP2->LOCALIZACAO),;  //6
			_TMP2->PROCCOMP,;	// 7
			ALLTRIM(POSICIONE("NNR",1,_TMP2->FILIAL+_TMP2->ARMAZEM,"NNR_DESCRI")),; // 8
			_TMP2->ARMAZEM,;	// 9
			_TMP2->FILIAL})  	// 10

	
		_TMP2->( dbSkip() )
	EndDo
	_TMP2->(DbCloseArea())

	IF _nLinha2 == 0
		aadd(_aDados2,{1,0,0,0,"","",0,"","",""})
	ENDIF
	oDados2:nAt := 1
	UpdLBG()

	oBitMap:Refresh()
	oMemo:Refresh()
return()


//FUNCAO RESPONSAVEL POR PESQUISAR O PRODUTO
Static Function BscDados()
	IF !EMPTY(cProd) .AND. cProd != cProd2
		nProd := VAL(cProd)
		AtualizaLista()
		oDados:Refresh()
		oProd:Refresh()
		cProd2 := cProd

	ENDIF
Return .T.


//FUNCAO RESPONSAVEL POR EXECUTAR A PESQUISA NO BANCO DE DADOS
//DE ACORDO COM AS INFORMAÇÕES PASSADAS PELO USUARIO
Static Function AtualizaLista(_cPesq,_nTip)
	Local i := 0
	_aDados   := {}
	_nqtd++
	_nLinha := 0

	IF !EMPTY(_cPesq)
		//RETIRA ASPAS DA PESQUISA
		cProd := PADR(_cPesq,250)
		_cPesq := ""
	ENDIF
	cProd := StrTran(cProd,"'"," ")
	cProd := StrTran(cProd,'"',' ')

	//REALIZA A PESQUISA CASO O USUARIO TENHA PREENCHIDO ALGUMA INFOMRACAO
	IF !EMPTY(cProd)
		cQry := " SELECT B1_COD AS CODIGO,B1_DESC AS DESCRICAO,B1_REFER AS REFERENCIA, (CASE B1_FLAGSUG WHEN '2' THEN 'Sim' Else 'Não' End) FLAGSUG,"
		cQry += " ISNULL((SELECT B2_QATU-B2_QEMP-B2_RESERVA FROM "+RetSqlName("SB2")+" B2 WHERE B2_LOCAL = '01' AND B2.D_E_L_E_T_ = ' ' AND B2_FILIAL = '0101' AND B2_COD = B1_COD),0) AS E0101, "
		cQry += " ISNULL((SELECT B2_QATU-B2_QEMP-B2_RESERVA FROM "+RetSqlName("SB2")+" B2 WHERE B2_LOCAL = '01' AND B2.D_E_L_E_T_ = ' ' AND B2_FILIAL = '0103' AND B2_COD = B1_COD),0) AS E0103, "
		cQry += " ISNULL((SELECT B2_QATU-B2_QEMP-B2_RESERVA FROM "+RetSqlName("SB2")+" B2 WHERE B2_LOCAL = '01' AND B2.D_E_L_E_T_ = ' ' AND B2_FILIAL = '0104' AND B2_COD = B1_COD),0) AS E0104 "
		cQry += " FROM "+RetSqlName("SB1")+" WHERE d_e_l_e_t_ = ' ' AND B1_MSBLQL <> '1' AND ( "
		nProd := VAL(cProd)
		cProd2 := cValToChar(nProd)
		
		cQry += " (	"
	
		IF (nProd == 0 .OR. len(cProd2) !=  LEN(ALLTRIM(cProd)))
			CopytoClipboard(cProd)
			cQry += " (B1_COD + B1_REFER + B1_DESC) LIKE '%"+STRTRAN(ALLTRIM(cProd)," ","%")+"%' "
		ELSE
			DBSELECTAREA("SB1")
			SB1->(DBSETORDER(1))
			IF SB1->(DbSeek(xFilial("SB1")+PadR(ALLTRIM(cProd), tamsx3('B1_COD') [1])))
				cQry += " (B1_COD = '"+ALLTRIM(cProd)+"' ) "

			ELSE
				cQry += " (B1_COD = '"+ALLTRIM(cProd)+"' OR B1_CODBAR = '"+ALLTRIM(cProd)+"' OR B1_REFER LIKE '%"+ALLTRIM(cProd)+"%') "

			ENDIF
		ENDIF


		IF cNivel == 4
			cQry += " OR  ( B1_COD IN (SELECT LK_CODIGO FROM SLK010 WHERE d_e_l_e_t_ = ' ' AND LK_CODBAR = '"+ALLTRIM(cProd)+"' ) )  "
		ENDIF
		cQry += " )	"


		cQry += " ) "
		cQry += " ORDER BY b1_desc "

		dbUseArea(.t., "TOPCONN", TcGenQry(,,cQry), "_TMP", .t.)

		Do While _TMP->(!EoF())
			_nLinha++
			aEstoque := {}
			aadd(aEstoque,{"0101",_TMP->E0101})
			aadd(aEstoque,{"0103",_TMP->E0103})
			aadd(aEstoque,{"0104",_TMP->E0104})


			//VERIFICA SE EXISTE ESTOQUE NA FILIAL LOGADA PELO USUARIO
			_nEstoque := 0
			_bEstFil := .F.
			For i := 1 to len(aEstoque)
				IF aEstoque[i,1] == XFILIAL("SL1") .AND. aEstoque[i,2] > 0
					_bEstFil := .T.
				ENDIF
				_nEstoque += aEstoque[i,2]
			Next

			//CASO NAO TENHA ESTOQUE, ADICIONA A LEGENDA VERMELHA
			IF _nEstoque <= 0
				_ret := 1
			ENDIF
			//CASO TENHA ESTOQUE APENAS EM OUTRA FILIAL, ADICIONA A LEGENDA AZUL
			IF _nEstoque > 0 .AND. !_bEstFil
				_ret := 2
			ENDIF
			//CASO TENHA ESTOQUE NA FILIAL LOGADA, ADICIONA A LEGENDA VERDE
			IF _bEstFil
				_ret := 3
			ENDIF

			//DEPENDENDO DO NIVEL DO USUARIO, PREENCHE A GRID DE FORMA DIFERENTE
			//POIS ALGUMAS INFORMAÇÕES SAO OCULTADAS DO USUARIO NIVEL <= 5

			_nPrvVip := POSICIONE("SB0",1,XFILIAL("SB0")+_TMP->CODIGO,"B0_PRV1")
			_nPrvProm := POSICIONE("SB0",1,XFILIAL("SB0")+_TMP->CODIGO,"B0_PRV2")
			if !bModo .OR. ( _nEstoque > 0 .AND. bModo)
				aadd(_aDados,{_ret,; // 1
					ALLTRIM(_TMP->CODIGO),; // 2
					ALLTRIM(_TMP->DESCRICAO),;// 3 
					ALLTRIM(Transform(_nPrvVip,"@e 9,999,999,999,999.99")),; // 4
					IIF(_nPrvProm <= 0," ",ALLTRIM(Transform(_nPrvProm,"@e 9,999,999,999,999.99"))),; // 5
					ALLTRIM(_TMP->REFERENCIA),;// 6
					ALLTRIM(_TMP->FLAGSUG),;// 7
					ALLTRIM(Transform(_TMP->E0101,"@e 9,999,999,999,999.99")),; // 8
					ALLTRIM(Transform(_TMP->E0103,"@e 9,999,999,999,999.99")),; // 9
					ALLTRIM(Transform(_TMP->E0104,"@e 9,999,999,999,999.99"))}) // 10	
			ENDIF	



			_TMP->( dbSkip() )

		EndDo
		_TMP->(DbCloseArea())

	ENDIF

	// ATUALIZA A GRID DEPENDENDO DO NIVEL DO USUARIO

	IF _nLinha == 0
		aadd(_aDados,{1,"","",0,0,"","",0,0,0})
	ENDIF

	aadd(_aDados2,{1,0,0,0,"","",0,"","",""})

	/*
		LEGENDA      01
		ESTOQUE      02
		RESERVADO    03
		DISPONIVEL   04
		NOME EMPRESA 05
		LOCALIZACAO  06
		Proc De Compra 07
		NOME LOCAL   08
		LOCAL 		 09
*/

	IF _nqtd > 1
		oDados:nAt := 1
		oDados2:nAt := 1
		
		UpdLBG()
		ExibeFoto(_aDados[oDados:nAt,2])
	ENDIF


Return _aDados


//LEGENDA DA GRID 1
Static Function Legenda()
	Local aCores     := {}
	aAdd(aCores,{"BR_VERMELHO"	,"Sem estoque"})
	aAdd(aCores,{"BR_AZUL"		,"Em estoque em outra filial "})
	aAdd(aCores,{"BR_VERDE"	,"Em estoque na sua filial"})
	aAdd(aCores,{"BR_PRETO"	,"Bloqueado Inventario"})
	BrwLegenda("Legenda","Legenda",aCores)
Return


//FUNCAO RESPONSAVEL POR ORDENAR A GRID 1 DE ACORDO COM O CLICK DO USUARIO NO HEADER
Static Function MudaOrd(nCol)
	aSort(_aDados,,,{|X,Y| x[nCol] < y[nCol]})
	ExibeFoto(_aDados[oDados:nAt,2])
return



/*
		LEGENDA    01
		CODIGO 	   02
		DESCRICAO  03
		PRECO      04
		PRECO PROM 05
		REFERENCIA 06
		EST. DR FR 07
		EST. MAR   08
		EST. JOS   09
*/

Static Function getLBG()
	AAdd(_aHeader," ")						// 1
	AAdd(_aHeader,"Codigo")					// 2
	AAdd(_aHeader,"Descricao")				// 3
	AAdd(_aHeader,"Preço")					// 4
	AAdd(_aHeader,"Preço Prom")				// 5
	AAdd(_aHeader,"Referencia")				// 6
	AAdd(_aHeader,"Por Encomenda?")			// 7	
	AAdd(_aHeader,"Est. Matriz")			// 8
	AAdd(_aHeader,"Est. Parauapebas")		// 9
	AAdd(_aHeader,"Est. Marituba")			// 10

	@ 0,0 ListBox oDados Fields ;
		HEADER _aHeader[1],_aHeader[2],_aHeader[3],_aHeader[4],_aHeader[5],_aHeader[6],_aHeader[7],_aHeader[8],_aHeader[9],_aHeader[10];
		Size 150,150 Of oLayout1 Pixel;
		ColSizes 10,30,150,50,50,50,30,50,50,50,50
	oDados:oFont := oFont
	oDados:bChange   := {|| ExibeFoto(_aDados[oDados:nAt,2]) }
	oDados:bGotFocus := {|| ExibeFoto(_aDados[oDados:nAt,2]) }
	oDados:bLDBLCLICK := {||  _nInv:=_aDados[oDados:nAt,1],cProduto := _aDados[oDados:nAt,2],_lOk := .t. ,oProd:end()  }
	oDados:bRClicked := {|| Legenda()  }

	oDados:bHeaderClick := {|oObj,nCol| MudaOrd(nCol),oPROD:Refresh() }

Return




/*
		LEGENDA      01
		ESTOQUE      02
		RESERVADO    03
		DISPONIVEL   04
		NOME EMPRESA 05
		LOCALIZACAO  06
		Proc De Compra 07
		NOME LOCAL   09
		LOCAL 		 10

*/

Static Function getLBG2()
	AAdd(_aHead2," ")					// 1
	AAdd(_aHead2,"Est.")				// 2
	AAdd(_aHead2,"Reserv.")				// 3
	AAdd(_aHead2,"Disp.")				// 4
	AAdd(_aHead2,"Nome Empresa") 		// 5
	AAdd(_aHead2,"Localizacao") 		// 6 
	AAdd(_aHead2,"Proc De Compra")		// 7
	AAdd(_aHead2,"Nome Local")			// 8
	AAdd(_aHead2,"Local")				// 9
	AAdd(_aHead2,"Filial")				// 10

	@ 0,0 ListBox oDados2 Fields ;
		HEADER _aHead2[1],_aHead2[2],_aHead2[3],_aHead2[4],_aHead2[5],_aHead2[6],_aHead2[7],_aHead2[8],_aHead2[9],_aHead2[10];
		Size 50,50 Of oLayout1 Pixel;
		ColSizes 10,20,28,20,80,25,40,20,50,20
	oDados2:oFont := oFont // _cProd,_cArm,_cFil
	oDados2:bLDBLCLICK := {||  VisReser(_aDados[oDados:nAt,2],_aDados2[oDados2:nAt,9],_aDados2[oDados2:nAt,10])  }

Return


// FUNCAO RESPONSAVEL POR ATUALIZAR A GRID 1 E 2 DE USUARIOS NIVEL > 7

Static Function UpdLBG()
	oDados:SetArray(_aDados)
	oDados:bLine := {|| {iif(_aDados[oDados:nAt,1]=2,oAzul,iif(_aDados[oDados:nAt,1]=1,oVermelho,iif(_aDados[oDados:nAt,1]=4,oRosa,oVerde))),;
		_aDados[oDados:nAt,2],;
		_aDados[oDados:nAt,3],;
		_aDados[oDados:nAt,4],;
		_aDados[oDados:nAt,5],;
		_aDados[oDados:nAt,6],;
		_aDados[oDados:nAt,7],;
		_aDados[oDados:nAt,8],;
		_aDados[oDados:nAt,9],;
		_aDados[oDados:nAt,10]}}

	oDados2:SetArray(_aDados2)
	oDados2:bLine := {|| {iif(_aDados2[oDados2:nAt,1]=2,oAzul,iif(_aDados2[oDados2:nAt,1]=1,oVermelho,iif(_aDados2[oDados2:nAt,1]=4,oRosa,oVerde))),;
		_aDados2[oDados2:nAt,2],;
		_aDados2[oDados2:nAt,3],;
		_aDados2[oDados2:nAt,4],;
		_aDados2[oDados2:nAt,5],;
		_aDados2[oDados2:nAt,6],;
		_aDados2[oDados2:nAt,7],;
		_aDados2[oDados2:nAt,8],;		
		_aDados2[oDados2:nAt,9],;		
		_aDados2[oDados2:nAt,10]}}

	oDados:Refresh()
	oDados2:Refresh()
	oProd:Refresh()

Return


Static Function VisReser(_cProd,_cArm,_cFil)
	Local _aArea := Getarea()
	Private _oDlg
	Private _aFuncs := {}

	cQuery := " SELECT C0_NUM,C0_OBS,C0_QTDORIG,C0_FILIAL,C0_SOLICIT,CONVERT(VARCHAR(10),cast(C0_EMISSAO as date),103) AS EMISSAO, "
	cQuery += " (SELECT TOP 1 L1_HORA FROM "+RETSQLNAME("SL1")+" (NOLOCK) WHERE D_E_L_E_T_ = ' ' AND L1_NUM = SUBSTRING(C0_OBS,8,6) AND L1_FILIAL = SUBSTRING(C0_OBS,22,2)) AS HORA,' ' FILDES "
	cQuery += " FROM "+RETSQLNAME("SC0")+" (NOLOCK) WHERE D_E_L_E_T_ = ' ' AND C0_FILIAL = '"+XFILIAL("SC0")+"' "
	cQuery += " AND C0_PRODUTO = '"+_cProd+"' "
	cQuery += " AND C0_LOCAL = '"+_cArm+"' "

	DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "RESER", .T., .F. )

	DO WHILE !RESER->(Eof())
		aadd(_aFuncs,{ALLTRIM(RESER->C0_NUM),ALLTRIM(RESER->C0_SOLICIT),;
		ALLTRIM(RESER->C0_OBS)+IIF(!EMPTY(RESER->FILDES)," P/ "+FWFilName ( "01" , RESER->FILDES ),""),;
		RESER->C0_QTDORIG,ALLTRIM(RESER->EMISSAO),ALLTRIM(RESER->HORA)})

		RESER->(DbSkip())
	ENDDO

	RESER->(DbCloseArea())


	IF LEN(_aFuncs) > 0

		DEFINE MSDIALOG _oDlg TITLE "Reservas do produto "+_cProd FROM C(269),C(191) TO C(515),C(725) PIXEL STYLE  DS_MODALFRAME OF oMainWnd

		@ C(007),C(008) ListBox oFuncs Fields HEADER "Cod. Reserva","Usuario","Orç/Nfe/Transf","Qtd.","Emissao","Hora";
			Size C(254),C(100) Of _oDlg Pixel ColSizes 50,40,80,30,30,30
		oFuncs:SetArray(_aFuncs)

		oFuncs:bLine := {|| {;
			_aFuncs[oFuncs:nAt,01],;
			_aFuncs[oFuncs:nAt,02],;
			_aFuncs[oFuncs:nAt,03],;
			_aFuncs[oFuncs:nAt,04],;
			_aFuncs[oFuncs:nAt,05],;
			_aFuncs[oFuncs:nAt,06] }}

		ACTIVATE MSDIALOG _oDlg CENTERED

	ELSE
		MsgInfo("Não existem reservas para este produto na filial e armazem selecionados")
	ENDIF

	RESTAREA(_AAREA)
Return


static function visFoto()
    DEFINE DIALOG oDlgImg TITLE "Imagem" FROM aSize[7],0 To aSize[6],aSize[5] PIXEL
 
    // Usando o New
	oTBitmap1 := TBmpRep():New(0,0,aSize[6],aSize[5],"",.T.,oDlgImg)

	oBitMap:lAutoSize := .f.
	oBitMap:lstretch :=.t.

	oTBitmap1:LoadBmp(_cNomFot)

 
    ACTIVATE DIALOG oDlgImg CENTERED
Return


Static Function AtivaMod()

	if type("bModo")<>"L"
		bModo := .F.
	ENDIF

	IF bModo
		_cTitulo := "Consulta Produto "
		bModo := .F.
		_cCss:= "QTableView{ alternate-background-color: #f7f7f7; background: #ffffff; selection-background-color: #a9d19f }"
		_cCss+= "QTableView::item:hover { background-color: #ddedd2;font-weight: 400;}"

		// configura pintura do Header da TGrid
		_cCss+= "QHeaderView::section { background-color: qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #ffffff, stop: 0.5 #ffffff, stop: 0.6 #ededed,  stop:1 #ededed); color: black; padding-left: 4px; border: 1px solid #6c6c6c; }"
	ELSE
		_cTitulo := "Consulta Produto - MODO FILTRO APENAS COM ESTOQUE "
		bModo := .T.
		_cCss:= "QTableView{ alternate-background-color: #f7f7f7; background: #ffffff; selection-background-color: #d19f9f }"
		_cCss+= "QTableView::item:hover { background-color: #edd2d2;font-weight: 400;}"

		// configura pintura do Header da TGrid
		_cCss+= "QHeaderView::section { background-color: qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #ffffff, stop: 0.5 #ffffff, stop: 0.6 #ededed,  stop:1 #ededed); color: black; padding-left: 4px; border: 1px solid #6c6c6c; }"
	ENDIF

	oDados:SetCss(_cCss)
	oDados2:SetCss(_cCss)
	oProd:Refresh()
	
	cProd2 := SPACE(250)
	BscDados()
Return

Static Function QtdPrd(cProduto)
	cQtd := "1       "
	DBSELECTAREA("SB1")
	DBSETORDER(1)
	IF SB1->(DbSeek(xFilial("SB1")+cProduto))
		@ 200,1 to 250,210 dialog Ofovb TITLE oemtoansi("Informe a quantidade")
		iw_say(30,10,"Qtd:")
		@ 010,010 Get cQtd PICTURE "@!" SIZE 50,50
		@ 010,080 BMPBUTTON TYPE 01 ACTION close(Ofovb)
		ACTIVATE DIALOG Ofovb CENTERED
	ENDIF

Return val(cQtd)


User Function InsProd()
Local _nQuant := m->lr_QUANT
Local nPosProd		:= aPosCpo[Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_PRODUTO"})][2]			// Posicao da codigo do produto
//Local nPosDtLocal  		:= Ascan(aPosCpoDet,{|x| Alltrim(Upper(x[1])) == "LR_LOCAL"})					// Posicao do local (armazem)

SB1->(DBSETORDER(1))
IF SB1->(DBSEEK(XFILIAL("SB1")+acols[n,nposprod])) .and. SB1->B1_LOTVEN > 0
	if _nQuant < SB1->B1_LOTVEN
		_nQuant:=SB1->B1_LOTVEN
	Endif
	_nQtd := mod(_nQuant,SB1->B1_LOTVEN)
	IF _nQtd <> 0
		_nQuant:=INT(_nQuant/sb1->b1_lotven)*sb1->b1_lotven
		_nQuant+=sb1->b1_lotven
	Endif
ENDIF
m->lr_quant := _nQUant


Return( _nQuant )

user function ljtotven()
Local nPosProd		:= aPosCpo[Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_PRODUTO"})][2]			// Posicao da codigo do produto
Local nPosQtd		:= aPosCpo[Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_QUANT"})][2]			// Posicao da codigo do produto
Local _nQuant := acols[n,nposqtd]

SB1->(DBSETORDER(1))
IF SB1->(DBSEEK(XFILIAL("SB1")+acols[n,nposprod])) .and. SB1->B1_LOTVEN > 0
	if _nQuant < SB1->B1_LOTVEN
		_nQuant:=SB1->B1_LOTVEN
	Endif
	_nQtd := mod(_nQuant,SB1->B1_LOTVEN)
	IF _nQtd <> 0
		_nQuant:=INT(_nQuant/sb1->b1_lotven)*sb1->b1_lotven
		_nQuant+=sb1->b1_lotven
	Endif
ENDIF
m->lr_quant := _nQUant
__ReadVar            := "M->LR_QUANT"
//Lj7VlItem(1)  

Return( _nQuant )


//	Executa Funções do Botão selecionar.
Static Function funcao1()
  cProduto := _aDados[oDados:nAt,2]
  _lOk := .t. 
  oProd:end()  

return


// Executa Funções do Botão Consultar Ultimas vendas.
Static Function funcao2()
  cProduto := _aDados[oDados:nAt,2]

  	// SE NÃO FOR VAZIO EXECUTA.
	iF !EMPTY(cProduto)

	// POSICIONA NO PRODUTO NA SB1
	DBSELECTAREA("SB1")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SB1")+PADR(cProduto,TamSX3("B1_COD")[1]))

	// CHAMA ROTINA DE HISTORICO DE PREÇOS.
	U_HISTVENDA() 

	ENDIF
  
return


//	Executa Funções do Botão Historico de Preços.
Static Function funcao3()
  cProduto := _aDados[oDados:nAt,2]
  
	// SE NÃO FOR VAZIO EXECUTA.
	iF !EMPTY(cProduto)

	// POSICIONA NO PRODUTO NA SB1
	DBSELECTAREA("SB1")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SB1")+PADR(cProduto,TamSX3("B1_COD")[1]))

	// CHAMA ROTINA DE HISTORICO DE PREÇOS.
	U_HISTPRECO() 

	ENDIF


return
