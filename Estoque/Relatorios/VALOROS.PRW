//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} VALOROS
Relatório - LISTA DE MATERIAIS REQUISITADOS NA OS COM VALORES
@author Wilk Lima
@since 19/04/2022
@version 1.0
	@example
	VALOROS()
/*/
	
User Function VALOROS()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	PRIVATE _cNumOs := ABF->ABF_NUMOS
	PRIVATE _cSeqRc := ABF->ABF_SEQRC
	

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
	//Local oBreak := Nil

	//Criação do componente de impressão
	oReport := TReport():New(	"REQUIOS",;		//Nome do Relatório
								"Lista de Materiais da OS",;	//Título
								,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandscape() // modo paisagem
	//oReport:SetPortrait() // modo retrato
	oReport:cFontBody := 'Courier New' 
	oReport:nFontBody := 8 
	oReport:NLINEHEIGHT := 45
	//Criando a seção de dados
	oSectDad1 := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Ordem de Servico",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad1:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad1, "NUM_OS", "QRY_AUX", "Ord. Servico", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "SEQUENCIA", "QRY_AUX", "Seq. ", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "SOLICITANTE", "QRY_AUX", "Solicitante", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "NSA", "QRY_AUX", "Num. SA", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "EMISSAO", "QRY_AUX", "Emissão", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	
	//Criando a seção de dados								
	oSectDad2 := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Produtos",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad2:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad2, "CODIGO", "QRY_AUX", "Código", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "REFERENCIA", "QRY_AUX", "Referência", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "DESCRICAO", "QRY_AUX", "Descrição", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "UNID", "QRY_AUX", "Un.", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "QTD", "QRY_AUX", "Qtd Solic", "@E 99,999.99", 7, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "QTD_ENTREGUE", "QRY_AUX", "Qtd Entreg", "@E 99,999.99", 7, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "PRECO", "QRY_AUX", "Preço", "@E 9,999,999.99", 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "TOTAL_ORC", "QRY_AUX", "Total Solic.", "@E 9,999,999.99", 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "TOTAL_APL", "QRY_AUX", "Total Aplic.", "@E 9,999,999.99", 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	//Adicione mais campos, caso necessário
	oSectDad2:SetHeaderSection(.T.)

	
	//Definindo a quebra
	oBreak := TRBreak():New(oSectDad1,{|| QRY_AUX->(NUM_OS) },{|| "Ordem de Servico" })
	oSectDad1:SetHeaderBreak(.T.)
	
	//Definindo a quebra
	oBreak1 := TRBreak():New(oSectDad2,{|| QRY_AUX->(NUM_OS) },{|| "Ordem de Servico" })
	oSectDad2:SetHeaderBreak(.T.)
	
	
	//Totalizadores
	oFunTot1 := TRFunction():New(oSectDad2:Cell("CODIGO"),,"COUNT",oBreak,,"@E 99,999")
	oFunTot1 := TRFunction():New(oSectDad2:Cell("QTD"),,"SUM",oBreak,,"@E 99,999.99")
	oFunTot1 := TRFunction():New(oSectDad2:Cell("QTD_ENTREGUE"),,"SUM",oBreak,,"@E 99,999.99")
	oFunTot1 := TRFunction():New(oSectDad2:Cell("TOTAL_ORC"),,"SUM",oBreak,,"@E 9,999,999.99")
	oFunTot1 := TRFunction():New(oSectDad2:Cell("TOTAL_APL"),,"SUM",oBreak,,"@E 9,999,999.99")
	//oFunTot1:SetEndReport(.T.)
	
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

	//Pegando as seções do relatório
	oSectDad1 := oReport:Section(1)
	oSectDad2 := oReport:Section(2)
	
	//Montando consulta de dados
	// VENDAS

        
    cQryAux := "" 
    cQryAux += " SELECT ABF_EMISSA EMISSAO, ABF_NUMOS NUM_OS, ABF_SEQRC SEQUENCIA, ABF_SOLIC SOLICITANTE, " 
    cQryAux += " ABG_CODPRO CODIGO, B1_REFER REFERENCIA, B1_DESC DESCRICAO, ABG_UM UNID, ABG_QUANT QTD, ABG_NUMSA NSA , CP_QUJE QTD_ENTREGUE, B1_PRV1 PRECO, (B1_PRV1*ABG_QUANT) AS TOTAL_ORC,  " 
    cQryAux += " (CASE WHEN CP_QUJE>0 THEN (B1_PRV1*CP_QUJE) ELSE 0 END)  AS TOTAL_APL " 
    cQryAux += " FROM "+RetSqlname("ABF")+" ABF  " 
    cQryAux += " INNER JOIN "+RetSqlname("ABG")+" ABG ON ABF_FILIAL=ABG_FILIAL AND ABF_NUMOS=ABG_NUMOS AND ABF_SEQRC=ABG_SEQRC " 
    cQryAux += " AND ABF_ITEMOS=ABG_ITEMOS AND ABG.D_E_L_E_T_<>'*'  " 
    cQryAux += " INNER JOIN "+RetSqlname("SB1")+" B1 ON B1_FILIAL='"+XFILIAL("SB1")+"' AND ABG_CODPRO=B1_COD AND B1.D_E_L_E_T_<>'*' "
    cQryAux += " LEFT JOIN "+RetSqlname("SCP")+" CP ON CP_PRODUTO=ABG_CODPRO AND CP_FILIAL=ABG_FILIAL AND CP_NUM=ABG_NUMSA AND CP_ITEM=ABG_ITEMSA AND CP.D_E_L_E_T_<>'*' " 
    cQryAux += " WHERE ABF.D_E_L_E_T_<>'*' AND ABF_NUMOS='"+_cNumOs+"' and ABF_SEQRC='"+_cSeqRc+"' " 
	cQryAux += " ORDER BY ABF_NUMOS,ABF_SEQRC, ABG_CODPRO "
    cQryAux := ChangeQuery(cQryAux)
    	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "EMISSAO", "D")
	
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
		
		cVend := QRY_AUX->(NUM_OS)
		
		//Imprimindo a linha atual
		oSectDad1:PrintLine()
		
		oSectDad2:Init()
		
		While QRY_AUX->(NUM_OS) == cVend
		
			nAtual++
			oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
			oReport:IncMeter()
			oSectDad2:Printline()
		
			QRY_AUX->(DbSkip())
		EndDo	
	EndDo
	
	oReport:NLINEHEIGHT := 60
	
	oSectDad1:Finish()
	oSectDad2:Finish()
	QRY_AUX->(DbCloseArea())
	
	RestArea(aArea)
Return

