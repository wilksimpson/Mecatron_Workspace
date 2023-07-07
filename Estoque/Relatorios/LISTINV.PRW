//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} LISTINV
Relatório - LISTA DE INVENTÁRIO POR FABRICANTE
@author Wilk Lima
@since 14/02/2022
@version 1.0
	@example
	LISTINV()
/*/
	
User Function LISTINV()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "LISTINV"

	ValidPerg()
	If !Pergunte(cPerg, .t.)
		Return .f.
	EndIf
	
	//Se a pergunta não existir, zera a variável
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
		cPerg := Nil
	EndIf
	
	//Cria as definições do relatório
	oReport := fReportDef()
	
	//Será enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 1 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.T.)
		oReport:Print(.F., "", .T.)
	//Senão, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf
	//
	RestArea(aArea)
Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Função que monta a definição do relatório                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectDad1 := Nil
	Local oSectDad2 := Nil
	Local oBreak := Nil
	
	//Criação do componente de impressão
	oReport := TReport():New(	"LISTINV",;		//Nome do Relatório
								"Lista de Inventário",;	//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandscape() // modo paisagem
	//oReport:SetPortrait() // modo retrato
	oReport:cFontBody := 'Courier New' 
	oReport:nFontBody := 10 
	
	//Criando a seção de dados
	oSectDad1 := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Fabricante",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad1:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad1, "COD_FAB", "QRY_AUX", "Codigo", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "FABRICANTE", "QRY_AUX", "Fabricante / Fornecedor", /*Picture*/, 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

	//Criando a seção de dados								
	oSectDad2 := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Produtos",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad2:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad2, "CODIGO", "QRY_AUX", "Código", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "REFERENCIA", "QRY_AUX", "Referência", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "DESCRICAO", "QRY_AUX", "Descrição", /*Picture*/, 65, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "UNID", "QRY_AUX", "Un.", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	//TRCell():New(oSectDad2, "SALDO_ATUAL", "QRY_AUX", "Qtd. Atu", "@E 99,999.99", 7, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "QTD1","","Qtd. 1a",,8,,{|| "[        ]" }) //" _______1a."###"Quantidade"
	TRCell():New(oSectDad2, "QTD2","","Qtd. 2a",,8,,{|| "[        ]" }) //" _______2a."###"Quantidade"
	TRCell():New(oSectDad2, "QTD3","","Qtd. 3a",,8,,{|| "[        ]" }) //" _______3a."###"Quantidade"
	TRCell():New(oSectDad2, "ENDERECO", "QRY_AUX", "Endereço",/*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	//Adicione mais campos, caso necessário
	
	//Definindo a quebra
	oBreak := TRBreak():New(oSectDad1,{|| QRY_AUX->(COD_FAB) },{|| "Fabricante" })
	oSectDad1:SetHeaderBreak(.T.)
	
	//Definindo a quebra
	oBreak1 := TRBreak():New(oSectDad2,{|| QRY_AUX->(COD_FAB) },{|| "Fabricante" })
	oSectDad2:SetHeaderBreak(.T.)
	
	oSectDad2:SetHeaderSection(.T.)
	
	//Totalizadores
	oFunTot1 := TRFunction():New(oSectDad2:Cell("CODIGO"),,"COUNT",oBreak,,"@E 99,999.99")
	oFunTot1:SetEndReport(.F.)
	
     //Aqui, farei uma quebra  por seção
	//oSectDad1:SetPageBreak(.T.)
	//oSectDad1:SetTotalText(" Fabricante ")			
	
Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad1 := Nil
	Local oSectDad2 := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	Local cVend    := ""
	Local xi
	Local _cGrupo := ""
	Local _aGrupo
	//Pegando as seções do relatório
	oSectDad1 := oReport:Section(1)
	oSectDad2 := oReport:Section(2)
	
	//Montando consulta de dados
	// VENDAS

    cQryAux := "" 
    if MV_PAR05==1 // TODOS OS PRODUTOS
    cQryAux += " SELECT B1_COD CODIGO, B1_REFER REFERENCIA, B1_DESC DESCRICAO, B1_UM UNID, B1_CODFAB COD_FAB, " 
    cQryAux += " B1_FABRIC FABRICANTE, B2_QATU SALDO_ATUAL, BZ_DESCLOC ENDERECO " 
    cQryAux += " FROM "+RetSqlname("SB1")+" B1 " 
    cQryAux += " LEFT JOIN "+RetSqlname("SB2")+" B2 ON B2_COD=B1_COD AND B2_FILIAL='"+XFILIAL("SB2")+"' AND B2_LOCAL='"+MV_PAR04+"' AND B2.D_E_L_E_T_<>'*' " 
    cQryAux += " LEFT JOIN "+RetSqlname("SBZ")+" BZ ON BZ_COD=B1_COD AND BZ_FILIAL='"+XFILIAL("SBZ")+"' AND BZ_LOCPAD='"+MV_PAR04+"' AND BZ.D_E_L_E_T_<>'*' " 
    cQryAux += " WHERE B1.D_E_L_E_T_<>'*' AND B1_FILIAL='"+XFILIAL("SB1")+"' " 
    cQryAux += " AND B1_CODFAB BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"' " 
    ELSEIF MV_PAR05==2// Saldo Positivo
    cQryAux += " SELECT B1_COD CODIGO, B1_REFER REFERENCIA, B1_DESC DESCRICAO, B1_UM UNID, B1_CODFAB COD_FAB, " 
    cQryAux += " B1_FABRIC FABRICANTE, B2_QATU SALDO_ATUAL, BZ_DESCLOC ENDERECO " 
    cQryAux += " FROM "+RetSqlname("SB1")+" B1 " 
    cQryAux += " INNER JOIN "+RetSqlname("SB2")+" B2 ON B2_COD=B1_COD AND B2_FILIAL='"+XFILIAL("SB2")+"' AND B2_LOCAL='"+MV_PAR04+"' AND B2.D_E_L_E_T_<>'*' " 
    cQryAux += " LEFT JOIN "+RetSqlname("SBZ")+" BZ ON BZ_COD=B1_COD AND BZ_FILIAL='"+XFILIAL("SBZ")+"' AND BZ_LOCPAD='"+MV_PAR04+"' AND BZ.D_E_L_E_T_<>'*' " 
    cQryAux += " WHERE B1.D_E_L_E_T_<>'*' AND B1_FILIAL='"+XFILIAL("SB1")+"' AND B2_QATU>0 " 
    cQryAux += " AND B1_CODFAB BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"' " 
	ELSEIF MV_PAR05==3// Saldo Negativo
    cQryAux += " SELECT B1_COD CODIGO, B1_REFER REFERENCIA, B1_DESC DESCRICAO, B1_UM UNID, B1_CODFAB COD_FAB, " 
    cQryAux += " B1_FABRIC FABRICANTE, B2_QATU SALDO_ATUAL, BZ_DESCLOC ENDERECO " 
    cQryAux += " FROM "+RetSqlname("SB1")+" B1 " 
    cQryAux += " INNER JOIN "+RetSqlname("SB2")+" B2 ON B2_COD=B1_COD AND B2_FILIAL='"+XFILIAL("SB2")+"' AND B2_LOCAL='"+MV_PAR04+"' AND B2.D_E_L_E_T_<>'*' " 
    cQryAux += " LEFT JOIN "+RetSqlname("SBZ")+" BZ ON BZ_COD=B1_COD AND BZ_FILIAL='"+XFILIAL("SBZ")+"' AND BZ_LOCPAD='"+MV_PAR04+"' AND BZ.D_E_L_E_T_<>'*' " 
    cQryAux += " WHERE B1.D_E_L_E_T_<>'*' AND B1_FILIAL='"+XFILIAL("SB1")+"' AND B2_QATU<0 " 
    cQryAux += " AND B1_CODFAB BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"' " 
	ELSEIF MV_PAR05==4// Positivos e Negativos
    cQryAux += " SELECT B1_COD CODIGO, B1_REFER REFERENCIA, B1_DESC DESCRICAO, B1_UM UNID, B1_CODFAB COD_FAB, " 
    cQryAux += " B1_FABRIC FABRICANTE, B2_QATU SALDO_ATUAL, BZ_DESCLOC ENDERECO " 
    cQryAux += " FROM "+RetSqlname("SB1")+" B1 " 
    cQryAux += " INNER JOIN "+RetSqlname("SB2")+" B2 ON B2_COD=B1_COD AND B2_FILIAL='"+XFILIAL("SB2")+"' AND B2_LOCAL='"+MV_PAR04+"' AND B2.D_E_L_E_T_<>'*' " 
    cQryAux += " LEFT JOIN "+RetSqlname("SBZ")+" BZ ON BZ_COD=B1_COD AND BZ_FILIAL='"+XFILIAL("SBZ")+"' AND BZ_LOCPAD='"+MV_PAR04+"' AND BZ.D_E_L_E_T_<>'*' " 
    cQryAux += " WHERE B1.D_E_L_E_T_<>'*' AND B1_FILIAL='"+XFILIAL("SB1")+"' AND B2_QATU<>0 " 
    cQryAux += " AND B1_CODFAB BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"' " 
    ENDIF
    IF !EMPTY(MV_PAR03)
        _cGrupo := MV_PAR03
        _aGrupo := StrTokArr(_cGrupo,",;")
        _cGrupo := ''
        for xi := 1 to len(_aGrupo)
            if xi > 1
                _cGrupo +=","
            ENDIF
            _cGrupo += "'"+alltrim(_aGrupo[xi])+"'"
        next xi
   ENDIF
   if !empty(_cGrupo)
       cQryAux += " AND B1_GRUPO IN ("+_cGrupo+") " + STR_PULA
   endif
    cQryAux += " ORDER BY B1_CODFAB,B1_COD " 
	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	//TCSetField("QRY_AUX", "DT_COBRANCA", "D")
	
	//Enquanto houver dados
	//oSectDad1:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
	
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira seção
		oSectDad1:Init()
			
		//Incrementando a régua
		nAtual++
		oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
		oReport:IncMeter()
		
		cVend := QRY_AUX->(COD_FAB)
		
		//Imprimindo a linha atual
		oSectDad1:PrintLine()
		
		oSectDad2:Init()
		
		While QRY_AUX->(COD_FAB) == cVend
		
			nAtual++
			oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
			oReport:IncMeter()
			oSectDad2:Printline()
		
			QRY_AUX->(DbSkip())
		EndDo	
	EndDo
	oSectDad1:Finish()
	oSectDad2:Finish()
	QRY_AUX->(DbCloseArea())
	
	RestArea(aArea)
Return

Static Function ValidPerg()
	Local aArea:= GetArea()                                                                                                                          
	Local aRegs
	Local i, j
	
	DbSelectArea("SX1")
	DbSetOrder(1)
	cPerg:= Padr(cPerg, 10)
	
	aRegs:= {}
	aAdd(aRegs, {cPerg,"01","Fabricante De       ?","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","FAB","","","","",""})
	aAdd(aRegs, {cPerg,"02","Fabricante Até      ?","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","FAB","","","","",""})
	aAdd(aRegs, {cPerg,"03","Grupos      		 ?","","","mv_ch3","C",20,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SBM","","","","",""})
	aAdd(aRegs, {cPerg,"04","Local de estoque	 ?","","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","NNR","","","","",""})
	aAdd(aRegs, {cPerg,"05","Tipo de Saldo 		 ?","","","mv_ch5","N",01,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	For i:= 1 To Len(aRegs)
		If !DbSeek(cPerg + aRegs[i,2])
			RecLock("SX1", .t.)
			For j:= 1 To fCount()
				FieldPut(j, aRegs[i,j])
			Next j
			MsUnlock()
			DbCommit()
		Endif
	Next i
		
	RestArea(aArea)		
Return
