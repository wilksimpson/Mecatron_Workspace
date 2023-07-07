#Include "Protheus.ch"
#include "TopConn.ch"
#INCLUDE "COLORS.CH"
#include "rwmake.ch"
#include "tbiconn.ch"
#Include "TbiCode.ch"
#DEFINE DS_MODALFRAME 128



//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  BIPPROD   º Autor João Felipe Costa Braga Data ³ 05.02.2021  º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao ³ BIPAGEM DE PRODUTOS PARA CONFERENCIA 					    º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function BIPPRODS(_cOrcam,_cFil)
	Local aArea     	:= GetArea()
	Private _lOk	:= .F.
	Private _oVerde	  := LoadBitMap(GetResources(), "BR_VERDE")
	Private _oPreto	  := LoadBitMap(GetResources(), "BR_PRETO")
	Private _oAmarelo := LoadBitMap(GetResources(), "BR_AMARELO")
	Private _oVermelho:= LoadBitMap(GetResources(), "BR_VERMELHO")
	Private _oAzul	  := LoadBitMap(GetResources(), "BR_AZUL")
	Private _oRosa	  := LoadBitMap(GetResources(), "BR_PINK")
	Private _aDadOrc := {}
	Private _oDadOrc
	Private _oDlgProd
	private _cProd := space(len(SB1->B1_COD))
	private _bConfOk := .F.
	private _oCor := CLR_RED
	private _nItens := 0
	private _cBitMap:=""
	private _nQtd:=1
	private cLabel := "CONFERENCIA DIVERGENTE"
	private _cOrc := _cOrcam
	private _cFilial := _cFil
	Private _nTot := 0
	Private _nPeso := 0
	Private _nVolume := 0
	Private _cEspecie := SPACE(10)

	DEFINE FONT _oFont1 NAME "Arial" SIZE 0,20 BOLD

	_aDadOrc := AtuLista()

	IF _nItens == 0
		_cSql := " UPDATE "+RETSQLNAME("SL1")+" SET L1_LIBERAD ='3' "
		_cSql += " WHERE L1_NUM='"+_cOrc+"' "
		_cSql += " AND L1_FILIAL='"+_cFilial+"' "
		_cSql += " AND D_E_L_E_T_ = ' ' "
		TCSQLEXEC(_cSql)
		_cSql := " COMMIT "
		TCSQLEXEC(_cSql)
		msginfo("Nenhum produto pendente para a conferencia")
	ENDIF

	_nTot := 0

	DEFINE MSDIALOG _oDlgProd TITLE OemToAnsi("Conferencia Orcamento: "+_cOrcam) FROM C(0),C(0) To C(430),C(768) PIXEL  OF oMainWnd

	oFont  := TFont():New("Courier New",7,16,,.F.,,,,.T.,.F.)
	@ C(195),C(010) SAY "Cod. Produto:"                                                     OF _oDlgProd PIXEL
	@ C(192),C(040) MSGET _oProd VAR _cProd PICTURE "@!"  VALID addProd(_cProd) SIZE 100,10 OF _oDlgProd PIXEL

	@ C(205),C(010) SAY "Quantidade:"                                           OF _oDlgProd PIXEL
	@ C(202),C(040) MSGET _oQtd  VAR _nQtd PICTURE "@e 999,999.99"  SIZE 50,10 OF _oDlgProd PIXEL

	@ C(205),C(105) SAY "Total:"                                                OF _oDlgProd PIXEL
	@ C(202),C(120) MSGET _oTot  VAR _nTot PICTURE "@e 999,999.99"  SIZE 50,10  when .f. OF _oDlgProd PIXEL

	@ C(205),C(165) SAY "Peso:"                                                OF _oDlgProd PIXEL
	@ C(202),C(180) MSGET _oPeso  VAR _nPeso PICTURE "@e 999,999.99"  SIZE 50,10  when .t. OF _oDlgProd PIXEL

	@ C(205),C(225) SAY "Volume:"                                                OF _oDlgProd PIXEL
	@ C(202),C(240) MSGET _oVolume  VAR _nVolume PICTURE "@e 999,999.99"  SIZE 50,10  when .t. OF _oDlgProd PIXEL

	@ C(205),C(285) SAY "Especie:"                                                OF _oDlgProd PIXEL
	@ C(202),C(300) MSGET _oEspecie  VAR _cEspecie PICTURE "@!"  SIZE 50,10  when .t. OF _oDlgProd PIXEL


	@ C(192),C(240) BUTTON _oBtnF    PROMPT "Finalizar" SIZE 40 ,10  FONT _oDlgProd:oFont ACTION (Finaliza(1), Close(_oDlgProd)) OF _oDlgProd PIXEL
//	@ C(200),C(250) BUTTON _oBtnP 	 PROMPT "Adicionar Numero Serie"   SIZE 45 ,10  FONT _oDlgProd:oFont ACTION (Legenda())     OF _oDlgProd PIXEL

	@ C(170),C(290) Say olabel  VAR cLabel  Size 200,30 COLOR _oCor FONT _oFont1 PIXEL OF _oDlgProd

	@ C(010),C(10) ListBox _oDadOrc Fields ;
		HEADER " ","Codigo","Descr.","Qtd.","UN","Refer.","Localiz.","Fabri.","Cod. Barras","N. Serie","Item" ;
		Size C(280),C(180) Of _oDlgProd Pixel;
		ColSizes 10,20,70,10,10,20,20,20,20,20,20
	_oDadOrc:oFont := oFont
	_oDadOrc:SetArray(_aDadOrc)


	_oDadOrc:bLine := {|| {;
		iif(_aDadOrc[_oDadOrc:nAt,1]==0,_oVermelho,iif(_aDadOrc[_oDadOrc:nAt,1]=1,_oVerde,iif(_aDadOrc[_oDadOrc:nAt,1]=2,_oAzul,_oPreto)))  ,;
		_aDadOrc[_oDadOrc:nAt,2],;
		_aDadOrc[_oDadOrc:nAt,3],;
		_aDadOrc[_oDadOrc:nAt,4],;
		_aDadOrc[_oDadOrc:nAt,5],;
		_aDadOrc[_oDadOrc:nAt,6],;
		_aDadOrc[_oDadOrc:nAt,7],;
		_aDadOrc[_oDadOrc:nAt,8],;
		_aDadOrc[_oDadOrc:nAt,9],;
		_aDadOrc[_oDadOrc:nAt,10],;
		_aDadOrc[_oDadOrc:nAt,11]} }

	_oDadOrc:bChange   := {|| ExibeFoto(_aDadOrc[_oDadOrc:nAt,2]) }
	_oDadOrc:bGotFocus := {|| ExibeFoto(_aDadOrc[_oDadOrc:nAt,2]) }
	_oDadOrc:bLDBLCLICK := {|| _aDadOrc[_oDadOrc:nAt,10] := AddNserie(_aDadOrc[_oDadOrc:nAt,2],_aDadOrc[_oDadOrc:nAt,11])   }


	// configura pintura da TGridLocal
	_cCss:= "QTableView{ alternate-background-color: #f7f7f7; background: #ffffff; selection-background-color: #a9d19f }"
	_cCss+= "QTableView::item:hover { background-color: #ddedd2;font-weight: 400;}"
	// configura pintura do Header da TGrid
	_cCss+= "QHeaderView::section { background-color: qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #ffffff, stop: 0.5 #ffffff, stop: 0.6 #ededed,  stop:1 #ededed); color: black; padding-left: 4px; border: 1px solid #6c6c6c; }"

	_oDadOrc:SetCss(_cCss)

	oBitMap := TBmpRep():New(010,085,160,131,"1004                ",.T.,_oDlgProd)

	oBitMap:lAutoSize := .f.
	oBitMap:lstretch :=.t.

	Activate Dialog _oDlgProd CENTERED

	RestArea(aArea)

Return _lOk


//FUNCAO RESPONSAVEL POR EXECUTAR A BOTAO FINALIZAR
//ALTERA O STATUS DA CONFERENCIA PARA 3 (CONFERENCIA FINALIZADA)
Static Function Finaliza(_nTipo)
	Local nA := 0
	If MsgYesNo("Deseja realmente finalizar essa contagem ? ")
		for nA := 1 to len(_aDadOrc)
			IF _aDadOrc[nA,4] = _aDadOrc[nA,13]
				_cSql := " UPDATE "+RETSQLNAME("SL2")+" SET L2_BIPPROD  = 'T' "
				_cSql += " WHERE L2_NUM='"+_cOrc+"' "
				_cSql += " AND L2_FILIAL='"+_cFilial+"' "
				_cSql += " AND L2_PRODUTO='"+_aDadOrc[nA,2]+"' "
				_cSql += " AND L2_ITEM='"+_aDadOrc[nA,12]+"' "
				_cSql += " AND D_E_L_E_T_ = ' ' "
				TCSQLEXEC(_cSql)

			ENDIF
		next
		// tratamento para preencher valores de peso e volume e peso automaticamente.
		if _nVolume>0 .and.  _nPeso==0
			_nPeso := 1
		elseif _nVolume==0 .and.  _nPeso>0
			_nVolume := 1
		ENDIF
		// tratamento para preencher espécie automaticamente caso volume ou peso sejam informados
		if empty(_cEspecie) .and. (_nPeso+_nVolume)>0
			_cEspecie := 'Pacote'
		ENDIF

		if ChecaTudo()
			_cSql := " UPDATE "+RETSQLNAME("SL1")+" SET L1_LIBERAD ='3' , "
			_cSql += " L1_PBRUTO = "+cValToChar(_nPeso)+", L1_PLIQUI = "+cValToChar(_nPeso)+" ,  "
			_cSql += " L1_VOLUME = "+cValToChar(_nVolume)+", L1_ESPECI1 = '"+_cEspecie+"' "
			_cSql += " WHERE L1_NUM='"+_cOrc+"' "
			_cSql += " AND L1_FILIAL='"+_cFilial+"' "
			_cSql += " AND D_E_L_E_T_ = ' ' "
			TCSQLEXEC(_cSql)
			return .t.
		else
			_cSql := " UPDATE "+RETSQLNAME("SL1")+" SET L1_PBRUTO = "+cValToChar(_nPeso)+", "
			_cSql += " L1_PLIQUI = "+cValToChar(_nPeso)+" ,  "
			_cSql += " L1_VOLUME = "+cValToChar(_nVolume)+", L1_ESPECI1 = '"+_cEspecie+"' "
			_cSql += " WHERE L1_NUM='"+_cOrc+"' "
			_cSql += " AND L1_FILIAL='"+_cFilial+"' "
			_cSql += " AND D_E_L_E_T_ = ' ' "
			TCSQLEXEC(_cSql)
			return .t.
		ENDIF

	ENDIF

	_oDlgProd:End()

Return


Static Function ChecaTudo()
	Local nA
	_lOk := .t.
	_nTot := 0
	for nA := 1 to len(_aDadOrc)
		_lOk := _lOk .and. (_aDadOrc[nA,4] = _aDadOrc[nA,13])
		_nTot += _aDadOrc[nA,4]
	next

	cLabel := iif(_lOk,"CONFERENCIA OK","CONFERENCIA DIVERGENTE")
	oLabel:Refresh()

	_oTot:Refresh()



return _lOk


//FUNCAO RESPONSAVEL POR ADICIONAR UM PRODUTO APOS A BIPAGEM
Static Function addProd(CodBar)
	local _aBkp := {}
	local nA:=0

	//REALIZA UM BACKUP DO ARRAY PARA O CASO DE ALGUMA VALIDAÃ‡ÃƒO FALHAR
	_aBkp := aClone(_aDadOrc)

	//FINALIZA A FUNCAO CASO O PRODUTO ESTEJA EM BRANCO
	if empty(CodBar)
		return .t.
	endif

	//procura o item pelo codigo ou codigo de barras
	_nPos :=ascan(_aDadOrc,{|x| (alltrim(x[2])==alltrim(CodBar) .or. alltrim(x[9])==alltrim(CodBar))  .AND. x[1] != 1 })

	//caso nao encontre na tela, realiza a busca no banco
	if _nPos = 0
		cProd2 := ""
		IF (LEN(ALLTRIM(CodBar)) != 13) // se nao for codigo de barras, busca na consulta
			cProd2 :=  PADR(ALLTRIM(CodBar),TamSX3('B1_COD')[01])
		ELSE
			cProd2 := ""
			DBSELECTAREA("SLK")
			SLK->(DBSETORDER(1))
			IF SLK->(DbSeek(xFilial("SLK")+PADR(ALLTRIM(CodBar),TamSX3('LK_CODBAR')[01])))
				cProd2 := PADR(ALLTRIM(SLK->LK_CODIGO),TamSX3('B1_COD')[01])
			ELSE
				DBSELECTAREA("SB1")
				SB1->(DBSETORDER(5))
				IF SB1->(DbSeek(xFilial("SB1")+PADR(ALLTRIM(CodBar),TamSX3('B1_CODBAR')[01])))
					cProd2 := PADR(ALLTRIM(SB1->B1_COD),TamSX3('B1_COD')[01])
				ENDIF
			ENDIF

			IF EMPTY(cProd2) // caso nao encontre pelo codigo de barras, assume que Ã© um codigo de produto
				cProd2 := PADR(ALLTRIM(CodBar),TamSX3('B1_COD')[01])
			ENDIF

		ENDIF

		//busca o produto
		DBSELECTAREA("SB1")
		SB1->(DBSETORDER(1))
		IF !SB1->(DbSeek(xFilial("SB1")+cProd2))
			DBSELECTAREA("SB1")
			SB1->(DBSETORDER(14))
			IF !SB1->(DbSeek(xFilial("SB1")+cProd2))
				Alert("Produto nao encontrado")
				return .f.

			ELSE
				//procura o produto na tela pela segunda vez

				_nPos :=ascan(_aDadOrc,{|x| alltrim(x[6])==alltrim(cProd2) .AND. x[1] != 1 })

			ENDIF

		ELSE
			//procura o produto na tela pela segunda vez
			_nPos :=ascan(_aDadOrc,{|x| alltrim(x[2])==alltrim(cProd2)  .AND. x[1] != 1 })

		ENDIF


		IF EMPTY(_aDadOrc[1,2]) // deleta a primeira linha inicial
			_aDadOrc := {}
		ENDIF


		//se nao encontrar, inclui o produto no controle
		IF _nPos = 0
			IF !EMPTY(SB1->B1_CODFAB)
				aFabric := FwGetSX5("FB",SB1->B1_CODFAB)
			ELSE
				aFabric := {}

			ENDIF
			aadd(_aDadOrc,{3,ALLTRIM(SB1->B1_COD),ALLTRIM(SB1->B1_DESC),0,SB1->B1_UM,;
				ALLTRIM(SB1->B1_REFER),POSICIONE("SBZ",1,XFILIAL("SBZ")+SB1->B1_COD,"BZ_DESCLOC"),;
				IIF(LEN(aFabric) >0,ALLTRIM(aFabric[1][4]),"" ),;
				ALLTRIM(SB1->B1_CODBAR),"","",dtos(date())+time(),0})
			_nPos := len(_aDadOrc)
		ENDIF





	endif

	//ajusta a quantidade do produto em questao

	CodBar := _aDadOrc[_nPos,2]

	if _nQtd <> 0
		_aDadOrc[_nPos,4] += _nQtd
	else
		_aDadOrc[_nPos,4] := 0
	endif
	_aDadOrc[_nPos,12] := dtos(date())+time()

	IF  _aDadOrc[_nPos,1] != 3


		IF _aDadOrc[_nPos,13] != _aDadOrc[_nPos,4]
			_aDadOrc[_nPos,1] := 2
		ENDIF

		IF _aDadOrc[_nPos,4] <= 0
			_aDadOrc[_nPos,1] := 0
		ENDIF

		IF _aDadOrc[_nPos,13] == _aDadOrc[_nPos,4]
			_aDadOrc[_nPos,1] := 1
		ENDIF

	ELSE
		IF _aDadOrc[_nPos,4]  <= 0

			adel(_aDadOrc,_nPos)
			_aBkp := {}
			For nA:=1 to len(_aDadOrc)
				IF !Empty(_aDadOrc[nA])
					aadd(_aBkp,_aDadOrc[nA])
				ENDIF
			Next
			_aDadOrc :=	_aBkp
			_nPos := LEN(_aDadOrc)
		ENDIF

	ENDIF




	IF LEN(_aDadOrc) == 0
		aadd(_aDadOrc,{0,"","",0,"",;
			"","",;
			"",;
			"","","",dtos(date())+time()})
		_nPos := LEN(_aDadOrc)

	ENDIF

	ExibeFoto(_aDadOrc[_nPos,2])

	//ATUALIZA A GRID PARA O USUARIO
	_oDadOrc:SetArray(_aDadOrc)

	_oDadOrc:bLine := {|| {;
		iif(_aDadOrc[_oDadOrc:nAt,1]==0,_oVermelho,iif(_aDadOrc[_oDadOrc:nAt,1]=1,_oVerde,iif(_aDadOrc[_oDadOrc:nAt,1]=2,_oAzul,_oPreto)))  ,;
		_aDadOrc[_oDadOrc:nAt,2],;
		_aDadOrc[_oDadOrc:nAt,3],;
		_aDadOrc[_oDadOrc:nAt,4],;
		_aDadOrc[_oDadOrc:nAt,5],;
		_aDadOrc[_oDadOrc:nAt,6],;
		_aDadOrc[_oDadOrc:nAt,7],;
		_aDadOrc[_oDadOrc:nAt,8],;
		_aDadOrc[_oDadOrc:nAt,9],;
		_aDadOrc[_oDadOrc:nAt,10],;
		_aDadOrc[_oDadOrc:nAt,11]} }

	_oDadOrc:Refresh()

	_cProd := space(len(SB1->B1_COD))
	_oProd:Refresh()

	_nQtd := 1
	_oQtd:Refresh()

	ChecaTudo()

return .f.

//FUNCAO REPONSAVEL POR CARREGAR OS ITENS AO ABRIR A TELA DE UMA CONFERENCIA PENDENTE
Static Function AtuLista()
	_aDadOrc   := {}

	//CARREGAMENTO CONTAGEM ATUAL

	cQry := " select L2_ITEM AS ITEM,L2_NSERIE AS NUMERO_SERIE,L2_PRODUTO AS CODIGO_PRODUTO,L2_DESCRI AS DESCRICAO_PRODUTO ,B1_CODBAR AS CODBAR, "
	cQry += " L2_QUANT AS QUANT,B1_UM AS UNIDADE,B1_REFER AS REFERENCIA,B1_CODFAB AS FABRICANTE "
	cQry += " from "+RetSqlName("SL2")+" L2 "
	cQry += " INNER JOIN "+RetSqlName("SB1")+" B1  "
	cQry += " ON B1_COD = L2_PRODUTO AND B1.D_E_L_E_T_ <> '*'  "
	cQry += " where L2.D_E_L_E_T_ <> '*' AND "
	cQry += " L2_NUM = '"+_cOrc+"' AND L2_FILIAL = '"+_cFilial+"' "
	cQry += " AND L2_BIPPROD != 'T' "

	dbUseArea(.t., "TOPCONN", TcGenQry(,,cQry), "_TMP3", .t.)

	_nItens := 0
	Do While _TMP3->(!EoF())
		_nItens++
		IF !EMPTY(SB1->B1_CODFAB)
			aFabric := FwGetSX5("FB",SB1->B1_CODFAB)
		ELSE
			aFabric := {}

		ENDIF

		aadd(_aDadOrc,{0,ALLTRIM(_TMP3->CODIGO_PRODUTO),ALLTRIM(_TMP3->DESCRICAO_PRODUTO),0,_TMP3->UNIDADE,;
			ALLTRIM(_TMP3->REFERENCIA),ALLTRIM(POSICIONE("SBZ",1,XFILIAL("SBZ")+_TMP3->CODIGO_PRODUTO,"BZ_DESCLOC")),;
			IIF(LEN(aFabric) >0,ALLTRIM(aFabric[1][4]),""),;
			ALLTRIM(_TMP3->CODBAR),ALLTRIM(_TMP3->NUMERO_SERIE),ALLTRIM(_TMP3->ITEM),dtos(date())+time(),_TMP3->QUANT})

		_TMP3->( dbSkip() )

	EndDo
	_TMP3->(DbCloseArea())

	IF _nItens == 0
		aadd(_aDadOrc,{0,"","",0,"",;
			"","",;
			"",;
			"","","",dtos(date())+time()})
	ENDIF

Return _aDadOrc



Static Function C(nTam)
	Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8

	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28
	EndIf

	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)

//FUNCAO RESPONSAVEL POR CARREGAR A IMAGEM DO PRODUTO
STATIC FUNCTION ExibeFoto(_cProd)
	Local _cNomFot :=  ""

	IF !EMPTY(_cProd)
		_cNomFot := POSICIONE("SB1",1,XFILIAL("SB1")+PADR(ALLTRIM(_cProd),TamSX3('B1_COD')[01]),"B1_BITMAP")

		oBitMap:LoadBmp(_cNomFot)
		oBitMap:lAutoSize := .f.
		oBitMap:lstretch :=.t.

		if !oBitMap:ExistBmp(_cNomFot)
			oBitMap:LoadBmp("SEM_FOTO_IMG")
		endif
	ENDIF

	oBitMap:Refresh()

return()


Static Function AddNserie(cCod,cItem)
	Local nSerie := ""

	nSerie := FWInputBox("Informe o N. Serie do produto ", "")
	_cSql := " UPDATE "+RETSQLNAME("SL2")+" SET L2_NSERIE  = '"+ALLTRIM(nSerie)+"' "
	_cSql += " WHERE L2_NUM='"+_cOrc+"' "
	_cSql += " AND L2_FILIAL='"+_cFilial+"' "
	_cSql += " AND L2_PRODUTO='"+cCod+"' "
	_cSql += " AND L2_ITEM='"+cItem+"' "
	_cSql += " AND D_E_L_E_T_ = ' ' "
	TCSQLEXEC(_cSql)


Return nSerie
