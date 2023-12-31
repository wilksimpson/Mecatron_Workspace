//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} REQUIOS
Relat�rio - LISTA DE MATERIAIS REQUISITADOS NA OS
@author Wilk Lima
@since 14/02/2022
@version 1.0
	@example
	REQUIOS()
/*/
	
User Function REQUIOS()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	PRIVATE _cNumOs := ABF->ABF_NUMOS
	PRIVATE _cSeqRc := ABF->ABF_SEQRC
	

	//Cria as defini��es do relat�rio
	oReport := fReportDef()
	
	//Ser� enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 1 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.T.)
		oReport:Print(.F., "", .T.)
	//Sen�o, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf
	//
	RestArea(aArea)
Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Fun��o que monta a defini��o do relat�rio                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectDad1 := Nil
	Local oSectDad2 := Nil
	Local oSectDad3 := Nil
	//Local oBreak := Nil

	//Cria��o do componente de impress�o
	oReport := TReport():New(	"REQUIOS",;		//Nome do Relat�rio
								"Lista de Materiais da OS",;	//T�tulo
								,;		//Pergunte ... Se eu defino a pergunta aqui, ser� impresso uma p�gina com os par�metros, conforme privil�gio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de c�digo que ser� executado na confirma��o da impress�o
								)		//Descri��o
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	//oReport:SetLandscape() // modo paisagem
	oReport:SetPortrait() // modo retrato
	oReport:cFontBody := 'Courier New' 
	oReport:nFontBody := 8 
	oReport:NLINEHEIGHT := 45
	//Criando a se��o de dados
	oSectDad1 := TRSection():New(	oReport,;		//Objeto TReport que a se��o pertence
									"Ordem de Servico",;		//Descri��o da se��o
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser� considerada como principal da se��o
	oSectDad1:SetTotalInLine(.F.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relat�rio
	TRCell():New(oSectDad1, "NUM_OS", "QRY_AUX", "Ord. Servico", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "SEQUENCIA", "QRY_AUX", "Seq. ", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "SOLICITANTE", "QRY_AUX", "Solicitante", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "NSA", "QRY_AUX", "Num. SA", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "EMISSAO", "QRY_AUX", "Emiss�o", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	
	//Criando a se��o de dados								
	oSectDad2 := TRSection():New(	oReport,;		//Objeto TReport que a se��o pertence
									"Produtos",;		//Descri��o da se��o
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser� considerada como principal da se��o
	oSectDad2:SetTotalInLine(.T.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relat�rio
	TRCell():New(oSectDad2, "CODIGO", "QRY_AUX", "C�digo", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "REFERENCIA", "QRY_AUX", "Refer�ncia", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "DESCRICAO", "QRY_AUX", "Descri��o", /*Picture*/, 60, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "UNID", "QRY_AUX", "Un.", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "QTD", "QRY_AUX", "Qtd Solic", "@E 99,999.99", 7, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "QTD_ENTREGUE", "QRY_AUX", "Qtd Entreg", "@E 99,999.99", 7, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "ENDERECO", "QRY_AUX", "Endere�o", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*CENTER*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	//Adicione mais campos, caso necess�rio
	oSectDad2:SetHeaderSection(.T.)

	//Criando a se��o de dados								
	oSectDad3 := TRSection():New(	oReport,;		//Objeto TReport que a se��o pertence
									"Termo",;		//Descri��o da se��o
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser� considerada como principal da se��o
	
	//Colunas do relat�rio
	TRCell():New(oSectDad3, "ASS1","","Ass. Solicitante",,40,,{|| "__________________________________" },"CENTER") 
	TRCell():New(oSectDad3, "ASS2","","Ass. Aprovador",,40,,{|| "__________________________________" },"CENTER") 
	TRCell():New(oSectDad3, "ASS3","","Ass. Almoxarifado",,40,,{|| "__________________________________" },"CENTER") 
	//TRCell():New(oSectDad2, "ENDERECO", "QRY_AUX", "Endere�o", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*CENTER*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)


Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Fun��o que imprime o relat�rio                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad1 := Nil
	Local oSectDad2 := Nil
	Local oSectDad3 := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	Local cVend    := ""

	//Pegando as se��es do relat�rio
	oSectDad1 := oReport:Section(1)
	oSectDad2 := oReport:Section(2)
	oSectDad3 := oReport:Section(3)
	
	//Montando consulta de dados
	// VENDAS

        
    cQryAux := "" 
    cQryAux += " SELECT ABF_EMISSA EMISSAO, ABF_NUMOS NUM_OS, ABF_SEQRC SEQUENCIA, ABF_SOLIC SOLICITANTE, " 
    cQryAux += " ABG_CODPRO CODIGO, B1_REFER REFERENCIA, B1_DESC DESCRICAO, ABG_UM UNID, ABG_QUANT QTD, ABG_NUMSA NSA , BZ_DESCLOC ENDERECO, CP_QUJE QTD_ENTREGUE " 
    cQryAux += " FROM "+RetSqlname("ABF")+" ABF  " 
    cQryAux += " INNER JOIN "+RetSqlname("ABG")+" ABG ON ABF_FILIAL=ABG_FILIAL AND ABF_NUMOS=ABG_NUMOS AND ABF_SEQRC=ABG_SEQRC " 
    cQryAux += " AND ABF_ITEMOS=ABG_ITEMOS AND ABG.D_E_L_E_T_<>'*'  " 
    cQryAux += " INNER JOIN "+RetSqlname("SB1")+" B1 ON B1_FILIAL='"+XFILIAL("SB1")+"' AND ABG_CODPRO=B1_COD AND B1.D_E_L_E_T_<>'*' "
    cQryAux += " LEFT JOIN "+RetSqlname("SBZ")+" BZ ON BZ_COD=B1_COD AND BZ_FILIAL='"+XFILIAL("SBZ")+"' AND BZ_LOCPAD='01' AND BZ.D_E_L_E_T_<>'*' " 
    cQryAux += " LEFT JOIN "+RetSqlname("SCP")+" CP ON CP_PRODUTO=ABG_CODPRO AND CP_FILIAL=ABG_FILIAL AND CP_NUM=ABG_NUMSA AND CP_ITEM=ABG_ITEMSA AND CP.D_E_L_E_T_<>'*' " 
    cQryAux += " WHERE ABF.D_E_L_E_T_<>'*' AND ABF_NUMOS='"+_cNumOs+"' and ABF_SEQRC='"+_cSeqRc+"' " 
	cQryAux += " ORDER BY ABF_NUMOS,ABF_SEQRC, ABG_CODPRO "
    cQryAux := ChangeQuery(cQryAux)
    	
	//Executando consulta e setando o total da r�gua
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
	
		//inicializo a primeira se��o
		oSectDad1:Init()
			
		//Incrementando a r�gua
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
	oSectDad3:Init()
	oSectDad3:Printline()
	
	oSectDad1:Finish()
	oSectDad2:Finish()
	oSectDad3:Finish()
	QRY_AUX->(DbCloseArea())
	
	RestArea(aArea)
Return

