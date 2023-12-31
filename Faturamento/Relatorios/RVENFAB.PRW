//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"

//Constantes
#Define STR_PULA		Chr(13)+Chr(10)

/*/{Protheus.doc} RVENFAB
Relat�rio - Vendas Por Fabricante   
@author Wilk Lima
@since 06/02/2022
@version 1.0
	@example
	RVENFAB2()
/*/

User Function RVENFAB()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""

	//Defini��es da pergunta
	cPerg := "RVENFAB"

	ValidPerg()
	If !Pergunte(cPerg, .t.)
		Return .f.
	EndIf

	//Se a pergunta n�o existir, zera a vari�vel
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
		cPerg := Nil
	EndIf

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
	Local oBreak := Nil
	
	//Cria��o do componente de impress�o
	oReport := TReport():New(	"RVENFAB",;		//Nome do Relat�rio
								"Vendas por Fabricante",;	//T�tulo
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, ser� impresso uma p�gina com os par�metros, conforme privil�gio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de c�digo que ser� executado na confirma��o da impress�o
								)		//Descri��o
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	//oReport:SetLandscape() // modo paisagem
	oReport:SetPortrait() // modo retrato
	
	// Definindo se faz a quebra por cliente no relat�rio.
	if MV_PAR09=='S'
	//Criando a se��o de dados
	oSectDad1 := TRSection():New(	oReport,;		//Objeto TReport que a se��o pertence
									"Fabricante",;		//Descri��o da se��o
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser� considerada como principal da se��o
	oSectDad1:SetTotalInLine(.F.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relat�rio
	TRCell():New(oSectDad1, "FABRICANTE", "QRY_AUX", "Codigo", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "NOME_FAB", "QRY_AUX", "Fabricante / Fornecedor", /*Picture*/, 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

	oSectDad2 := TRSection():New(	oReport,;		//Objeto TReport que a se��o pertence
									"Cliente",;		//Descri��o da se��o
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser� considerada como principal da se��o
	oSectDad2:SetTotalInLine(.F.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relat�rio
	TRCell():New(oSectDad2, "CLIENTE", "QRY_AUX", "Codigo", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "NOME_CLIENTE", "QRY_AUX", "Nome Cliente", /*Picture*/, 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "CGC_CLIENTE", "QRY_AUX", "CPF / CNPJ", /*Picture*/, 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

	//Criando a se��o de dados								////////////
	oSectDad3 := TRSection():New(	oReport,;		//Objeto TReport que a se��o pertence
									"Produtos",;		//Descri��o da se��o
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser� considerada como principal da se��o
	oSectDad3:SetTotalInLine(.F.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relat�rio
	//TRCell():New(oSectDad3, "DT_COBRANCA", "QRY_AUX", "Data", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad3, "CODIGO", "QRY_AUX", "C�digo", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad3, "REFERENCIA", "QRY_AUX", "Refer�ncia", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad3, "DESCRICAO", "QRY_AUX", "Descri��o", /*Picture*/, 80, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad3, "UN", "QRY_AUX", "Un.", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad3, "QUANTIDADE", "QRY_AUX", "Qtd.", "@E 99,999.99", 7, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad3, "PRECO_MEDIO", "QRY_AUX", "Prc. M�dio", "@E 99,999,999,999.99", 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad3, "VALOR","QRY_AUX", "Total" , "@E 99,999,999,999.99", 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad3, "CUSTO", "QRY_AUX", "Custo"	 , "@E 99,999,999,999.99", 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	//Adicione mais campos, caso necess�rio
	
	//Definindo a quebra
	oBreak := TRBreak():New(oSectDad1,{|| QRY_AUX->(FABRICANTE) },{|| "Total Fabricante" })
	oSectDad1:SetHeaderBreak(.T.)
	
	//Definindo a quebra
	oBreak1 := TRBreak():New(oSectDad2,{|| QRY_AUX->(CLIENTE) },{|| "Total Cliente" })
	oSectDad2:SetHeaderBreak(.T.)
	
	oSectDad2:SetHeaderSection(.T.)
	oSectDad3:SetHeaderSection(.T.)

	// TOTALIZADORES
	oFunTot1 := TRFunction():New(oSectDad3:Cell("CODIGO"),,"COUNT",oBreak1,,"@E 99,999.99")
	oFunTot1 := TRFunction():New(oSectDad3:Cell("QUANTIDADE"),,"SUM",oBreak1,,"@E 99,999,999,999.99")
	oFunTot1 := TRFunction():New(oSectDad3:Cell("VALOR"),,"SUM",oBreak1,,"@E 99,999,999,999.99")
	oFunTot1 := TRFunction():New(oSectDad3:Cell("CUSTO"),,"SUM",oBreak1,,"@E 99,999,999,999.99")
	oFunTot1:SetEndSection(.T.)
	oFunTot1:SetEndReport(.T.)
	
	else
		//Criando a se��o de dados
	oSectDad1 := TRSection():New(	oReport,;		//Objeto TReport que a se��o pertence
									"Fabricante",;		//Descri��o da se��o
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser� considerada como principal da se��o
	oSectDad1:SetTotalInLine(.F.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relat�rio
	TRCell():New(oSectDad1, "FABRICANTE", "QRY_AUX", "Codigo", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad1, "NOME_FAB", "QRY_AUX", "Fabricante / Fornecedor", /*Picture*/, 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

	//Criando a se��o de dados								
	oSectDad2 := TRSection():New(	oReport,;		//Objeto TReport que a se��o pertence
									"Produtos",;		//Descri��o da se��o
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser� considerada como principal da se��o
	oSectDad2:SetTotalInLine(.F.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relat�rio
	//TRCell():New(oSectDad2, "DT_COBRANCA", "QRY_AUX", "Data", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "CODIGO", "QRY_AUX", "C�digo", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "REFERENCIA", "QRY_AUX", "Refer�ncia", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "DESCRICAO", "QRY_AUX", "Descri��o", /*Picture*/, 80, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "UN", "QRY_AUX", "Un.", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "QUANTIDADE", "QRY_AUX", "Qtd.", "@E 99,999.99", 7, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "PRECO_MEDIO", "QRY_AUX", "Prc. M�dio", "@E 99,999,999,999.99", 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "VALOR","QRY_AUX", "Total" , "@E 99,999,999,999.99", 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "CUSTO", "QRY_AUX", "Custo"	 , "@E 99,999,999,999.99", 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	//Adicione mais campos, caso necess�rio
	
	//Definindo a quebra
	oBreak := TRBreak():New(oSectDad1,{|| QRY_AUX->(FABRICANTE) },{|| "Total Fabricante" })
	oSectDad1:SetHeaderBreak(.T.)
	
	//Definindo a quebra
	oBreak1 := TRBreak():New(oSectDad2,{|| QRY_AUX->(FABRICANTE) },{|| "Total Fabricante" })
	oSectDad2:SetHeaderBreak(.T.)
	
	oSectDad2:SetHeaderSection(.T.)

		//Totalizadores
	oFunTot1 := TRFunction():New(oSectDad3:Cell("CODIGO"),,"COUNT",oBreak,,"@E 99,999.99")
	oFunTot1 := TRFunction():New(oSectDad3:Cell("QUANTIDADE"),,"SUM",oBreak,,"@E 99,999,999,999.99")
	oFunTot1 := TRFunction():New(oSectDad3:Cell("VALOR"),,"SUM",oBreak,,"@E 99,999,999,999.99")
	oFunTot1 := TRFunction():New(oSectDad3:Cell("CUSTO"),,"SUM",oBreak,,"@E 99,999,999,999.99")
	oFunTot1:SetEndReport(.F.)
	Endif

	
     //Aqui, farei uma quebra  por se��o
	//oSectDad1:SetPageBreak(.T.)			
	//oSectDad1:SetTotalText("Totais do Fabricante ")	
	//oSectDad2:SetPageBreak(.T.)
	//oSectDad2:SetTotalText("Totais do Cliente ")		
	
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
	Local cVend2   := ""
	
	//Pegando as se��es do relat�rio
	oSectDad1 := oReport:Section(1)
	oSectDad2 := oReport:Section(2)
	
	IF MV_PAR09=='S' // DEFINE SE H� QUEBRA OPR CLIENTE
	oSectDad3 := oReport:Section(3)
	ENDIF
	//Montando consulta de dados
	// VENDAS
cQryAux += ""
IF MV_PAR09=='S' // DEFINE SE H� QUEBRA OPR CLIENTE
cQryAux += "select CODIGO, REFERENCIA , DESCRICAO, FABRICANTE , NOME_FAB, UN, SUM(QUANTIDADE) QUANTIDADE, "
cQryAux += " AVG(PRECO_MEDIO) PRECO_MEDIO, SUM(VALOR) VALOR, SUM(CUSTO) CUSTO, "
cQryAux += " CLIENTE, NOME_CLIENTE, CGC_CLIENTE "
ELSE
cQryAux += "select CODIGO, REFERENCIA , DESCRICAO, FABRICANTE , NOME_FAB, UN, SUM(QUANTIDADE) QUANTIDADE, "
cQryAux += " AVG(PRECO_MEDIO) PRECO_MEDIO, SUM(VALOR) VALOR, SUM(CUSTO) CUSTO "
ENDIF

cQryAux += " FROM ( "
cQryAux += "SELECT D2_COD CODIGO, B1_REFER REFERENCIA, B1_DESC DESCRICAO, " + STR_PULA  
cQryAux += "B1_CODFAB FABRICANTE, B1_FABRIC NOME_FAB,B1_UM UN, D2_QUANT QUANTIDADE,  " + STR_PULA  
cQryAux += "D2_PRCVEN PRECO_MEDIO,D2_TOTAL VALOR, D2_CUSTO1 CUSTO,   " + STR_PULA  
cQryAux += "A1.A1_COD CLIENTE, A1.A1_NOME NOME_CLIENTE, A1.A1_CGC CGC_CLIENTE " + STR_PULA  
cQryAux += " FROM "+RetSqlname("SD2")+" D2 INNER JOIN " + STR_PULA  
cQryAux += RetSqlname("SB1")+" B1 " + STR_PULA  
cQryAux += " ON B1_FILIAL=SUBSTRING(D2_FILIAL,1,2) AND B1_COD=D2_COD AND B1.D_E_L_E_T_<>'*' INNER JOIN " + STR_PULA  
cQryAux += RetSqlname("SA1")+" A1 ON A1_FILIAL= SUBSTRING(D2_FILIAL,1,2)  " + STR_PULA 
cQryAux += " AND D2.D2_CLIENTE=A1.A1_COD AND D2.D2_LOJA=A1.A1_LOJA AND A1.D_E_L_E_T_<>'*' INNER JOIN " + STR_PULA 
cQryAux += RetSqlname("SF4")+" F4 ON F4_FILIAL= SUBSTRING(D2_FILIAL,1,2)  " + STR_PULA  
cQryAux += " AND F4_CODIGO=D2_TES AND F4.D_E_L_E_T_<>'*' " + STR_PULA 
cQryAux += " WHERE D2.D_E_L_E_T_<>'*' AND  D2_TIPO='N' AND  "
// VENDAS UNI
IF MV_PAR05=='S'
cQryAux += " ((F4_DUPLIC='S' AND F4_ESTOQUE='S' ) OR ( D2_TES='507' )) "+ STR_PULA  
ELSE
cQryAux += " F4_DUPLIC='S' AND F4_ESTOQUE='S' " + STR_PULA  
ENDIF
cQryAux += " AND B1_CODFAB >= '"+MV_PAR01+"' AND B1_CODFAB <='"+MV_PAR02+"' " + STR_PULA  
cQryAux += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' " + STR_PULA  
cQryAux += " AND D2_FILIAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " + STR_PULA  
// DEVOLU��ES
IF MV_PAR06=='S'
cQryAux += " UNION ALL " + STR_PULA  
cQryAux += "SELECT D1_COD CODIGO, B1_REFER REFERENCIA, B1_DESC DESCRICAO, " + STR_PULA  
cQryAux += "B1_CODFAB FABRICANTE, B1_FABRIC NOME_FAB,B1_UM UN, (D1_QUANT*-1) QUANTIDADE, " + STR_PULA  
cQryAux += "(D1_VUNIT) PRECO_MEDIO, (D1_TOTAL*-1) VALOR, (D1_CUSTO*-1) CUSTO ,  " + STR_PULA  
cQryAux += " A1.A1_COD AS CLIENTE, A1.A1_NOME AS NOME_CLIENTE, A1.A1_CGC AS CGC_CLIENTE  " + STR_PULA  
cQryAux += " FROM "+RetSqlname("SD1")+" D1 INNER JOIN " + STR_PULA  
cQryAux += RetSqlname("SB1")+" B1 " + STR_PULA  
cQryAux += " ON B1_FILIAL=SUBSTRING(D1_FILIAL,1,2) AND B1_COD=D1_COD AND B1.D_E_L_E_T_<>'*' INNER JOIN  " + STR_PULA  
cQryAux += RetSqlname("SA1")+" A1 ON A1.A1_FILIAL= SUBSTRING(D1_FILIAL,1,2)  " + STR_PULA  
cQryAux += " AND A1.A1_COD=D1.D1_FORNECE AND A1.A1_LOJA=D1.D1_LOJA AND A1.D_E_L_E_T_<>'*' INNER JOIN " + STR_PULA  
cQryAux += RetSqlname("SF4")+" F4 ON F4_FILIAL= SUBSTRING(D1_FILIAL,1,2)  " + STR_PULA  
cQryAux += " AND F4_CODIGO=D1_TES AND F4.D_E_L_E_T_<>'*' " + STR_PULA  
cQryAux += " WHERE D1.D_E_L_E_T_<>'*' AND F4_ESTOQUE='S' AND D1_TIPO='D' " + STR_PULA  
cQryAux += " AND B1_CODFAB BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " + STR_PULA  
cQryAux += " AND D1_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' " + STR_PULA
cQryAux += " AND D1_FILIAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " + STR_PULA  
ENDIF
cQryAux += " ) AS TMP " + STR_PULA  

IF MV_PAR09=='S' // DEFINE SE H� QUEBRA POR CLIENTE.
cQryAux += " GROUP BY CODIGO,REFERENCIA , DESCRICAO, FABRICANTE , NOME_FAB, UN, CLIENTE, NOME_CLIENTE, CGC_CLIENTE " + STR_PULA  
cQryAux += " ORDER BY FABRICANTE,NOME_CLIENTE, CODIGO "
ELSE
cQryAux += " GROUP BY CODIGO,REFERENCIA , DESCRICAO, FABRICANTE , NOME_FAB, UN  " + STR_PULA  
cQryAux += " ORDER BY FABRICANTE, CODIGO "
ENDIF
cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da r�gua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	//TCSetField("QRY_AUX", "DT_COBRANCA", "D")
	
	IF MV_PAR09=='S' // DEFINE SE QUEBRA POR CLIENTE
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
		
		cVend := QRY_AUX->(FABRICANTE)
		
		//Imprimindo a linha atual
		oSectDad1:PrintLine()
		
		oSectDad2:Init()
		IF MV_PAR09=='S' // DEFINE SE QUEBRA POR CLIENTE
		oSectDad3:Init()
		ENDIF	

		While QRY_AUX->(FABRICANTE) == cVend
			
			cVend2 := QRY_AUX->(CLIENTE)
			oSectDad2:Printline()
			
			While QRY_AUX->(CLIENTE) == cVend2
		
				nAtual++
				oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
				oReport:IncMeter()
				oSectDad3:Printline()
				QRY_AUX->(DbSkip())
			EndDo	
			QRY_AUX->(DbSkip())
		EndDo
		QRY_AUX->(DbSkip())
	EndDo
	oSectDad1:Finish()
	oSectDad2:Finish()
	oSectDad3:Finish()
	QRY_AUX->(DbCloseArea())

	ELSE
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
		
		cVend := QRY_AUX->(FABRICANTE)
		
		//Imprimindo a linha atual
		oSectDad1:PrintLine()
		
		oSectDad2:Init()
		
		While QRY_AUX->(FABRICANTE) == cVend
		
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
	ENDIF	

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
	aAdd(aRegs, {cPerg,"01","Fabricante De       ?","","","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","","",""})
	aAdd(aRegs, {cPerg,"02","Fabricante At�      ?","","","mv_ch2","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","","",""})
	aAdd(aRegs, {cPerg,"03","Data De             ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs, {cPerg,"04","Data At�            ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs, {cPerg,"05","Inclui Vendas Uni   ?","","","mv_ch5","C",01,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs, {cPerg,"06","Deduz Devolu��es    ?","","","mv_ch6","C",01,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs, {cPerg,"07","Filial De           ?","","","mv_ch7","C",04,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
	aAdd(aRegs, {cPerg,"08","Filial At�          ?","","","mv_ch8","C",04,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
	aAdd(aRegs, {cPerg,"09","Quebra Por Cliente  ?","","","mv_ch9","C",01,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		
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
