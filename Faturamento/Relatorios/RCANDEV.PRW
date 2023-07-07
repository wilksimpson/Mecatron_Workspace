//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} RCANDEV
Relatório - Notas Canceladas e Devolvidas   
@author Wilk Lima
@since 14/03/2022
@version 1.0
	@example
	RCANDEV()
/*/
	
User Function RCANDEV()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "RCANDEV"

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
	oReport := TReport():New(	"RCANDEV",;		//Nome do Relatório
								"Notas Canceladas e Devolvidas no Periodo",;	//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandscape() // modo paisagem
	//oReport:SetPortrait() // modo retrato
	
	//Criando a seção de dados
	oSectDad1 := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Tipos",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad1:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad1, "TIPO", "QRY_AUX", "Tipo", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	//TRCell():New(oSectDad1, "NOME_FAB", "QRY_AUX", "Fabricante / Fornecedor", /*Picture*/, 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

	//Criando a seção de dados								
	oSectDad2 := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Notas",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad2:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad2, "EMPRESA", "QRY_AUX", "Filial", /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "EMISSAO", "QRY_AUX", "Emissao", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "DOC", "QRY_AUX", "Documento", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "SERIE", "QRY_AUX", "Serie", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "CODIGO", "QRY_AUX", "Cod Cli", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "LJCLI", "QRY_AUX", "Loj", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "CLIENTE", "QRY_AUX", "Cliente", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "VALOR", "QRY_AUX", "Valor", "@E 99,999,999,999.99", 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "DT_CANDEV","QRY_AUX", "Dt Can/Dev" , /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "VLCANDEV", "QRY_AUX", "Vlr Can/Dev" , "@E 99,999,999,999.99", 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "DOC_DEV", "QRY_AUX", "Doc. Devol", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad2, "SERIE_DEV", "QRY_AUX", "Ser. Devol", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	//Adicione mais campos, caso necessário
	
	//Definindo a quebra
	oBreak := TRBreak():New(oSectDad1,{|| QRY_AUX->(TIPO) },{|| "Tipo" })
	oSectDad1:SetHeaderBreak(.T.)
	
	//Definindo a quebra
	oBreak1 := TRBreak():New(oSectDad2,{|| QRY_AUX->(TIPO) },{|| "Tipo" })
	oSectDad2:SetHeaderBreak(.T.)
	
	oSectDad2:SetHeaderSection(.T.)
	
	//Totalizadores
	oFunTot1 := TRFunction():New(oSectDad2:Cell("EMPRESA"),,"COUNT",oBreak,,"@E 99,999")
	oFunTot1 := TRFunction():New(oSectDad2:Cell("VALOR"),,"SUM",oBreak,,"@E 99,999,999,999.99")
	oFunTot1 := TRFunction():New(oSectDad2:Cell("VLCANDEV"),,"SUM",oBreak,,"@E 99,999,999,999.99")
	oFunTot1:SetEndReport(.F.)
	
     //Aqui, farei uma quebra  por seção
	oSectDad1:SetPageBreak(.T.)
	oSectDad1:SetTotalText("Totais por Tipo ")			
	
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
cQryAux += ""
cQryAux += " SELECT TIPO, EMPRESA, DOC, SERIE, CODIGO, LJCLI, CLIENTE, EMISSAO, " + STR_PULA
cQryAux += " VALOR, DT_CANDEV, VLCANDEV, DOC_DEV, SERIE_DEV " + STR_PULA
cQryAux += " FROM ( " + STR_PULA
cQryAux += " SELECT 'CAN' TIPO, FT_FILIAL EMPRESA, FT_NFISCAL DOC, FT_SERIE SERIE, FT_CLIEFOR CODIGO, FT_LOJA LJCLI,A1_NOME CLIENTE, " + STR_PULA
cQryAux += " FT_EMISSAO EMISSAO, SUM(FT_VALCONT) VALOR, FT_DTCANC DT_CANDEV, SUM(FT_VALCONT) VLCANDEV, '' DOC_DEV, '' SERIE_DEV " + STR_PULA  
cQryAux += " FROM "+RetSqlname("SFT")+ " FT INNER JOIN " + STR_PULA  
cQryAux += RetSqlname("SA1")+ " A1 ON " + STR_PULA  
cQryAux += " SUBSTRING(FT_FILIAL,1,2)=A1_FILIAL AND FT_CLIEFOR=A1_COD AND FT_LOJA=A1_LOJA AND A1.D_E_L_E_T_<>'*' " + STR_PULA  
cQryAux += " WHERE FT.D_E_L_E_T_<>'*'  AND FT_DTCANC>' ' AND FT_TIPOMOV='S' " + STR_PULA  
cQryAux += " AND FT_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + STR_PULA  
cQryAux += " AND FT_CLIEFOR BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " + STR_PULA  
cQryAux += " AND FT_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " + STR_PULA  
cQryAux += " GROUP BY FT_FILIAL, FT_NFISCAL, FT_SERIE, FT_CLIEFOR, FT_LOJA, FT_EMISSAO, FT_DTCANC,A1_NOME "+ STR_PULA 
cQryAux += " UNION ALL  "+ STR_PULA 
cQryAux += " SELECT 'DEV' TIPO, F2_FILIAL EMPRESA, F2_DOC DOC, F2_SERIE SERIE, F2_CLIENTE CODIGO, F2_LOJA LJCLI,A1_NOME CLIENTE, "+ STR_PULA 
cQryAux += " F2_EMISSAO EMISSAO, F2_VALBRUT VALOR,D1_EMISSAO DT_CANDEV,  SUM(D1_TOTAL) VLCANDEV, D1_DOC DOC_DEV, D1_SERIE SERIE_DEV "+ STR_PULA 
cQryAux += " FROM "+RetSqlname("SF2")+" F2 INNER JOIN "+ STR_PULA 
cQryAux += RetSqlname("SA1")+" A1 ON SUBSTRING(F2_FILIAL,1,2)=A1_FILIAL AND F2_CLIENTE=A1_COD AND F2_LOJA=A1_LOJA AND A1.D_E_L_E_T_<>'*' "+ STR_PULA 
cQryAux += " INNER JOIN "+RetSqlname("SD1")+" D1 ON D1_TIPO='D' AND D1_FILORI=F2_FILIAL  "+ STR_PULA 
cQryAux += " AND D1_NFORI=F2_DOC AND D1_SERIORI=F2_SERIE AND D1.D_E_L_E_T_<>'*' "+ STR_PULA 
cQryAux += " WHERE F2.D_E_L_E_T_<>'*' "+ STR_PULA 
cQryAux += " AND D1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + STR_PULA 
cQryAux += " AND F2_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " + STR_PULA  
cQryAux += " AND F2_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " + STR_PULA  
cQryAux += " GROUP BY F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_EMISSAO, F2_VALBRUT, D1_EMISSAO, D1_DOC, D1_SERIE, A1_NOME "+ STR_PULA 
cQryAux += " ) AS TMP "+ STR_PULA 
cQryAux += " ORDER BY TIPO,EMISSAO, SERIE, DOC "
cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	TCSetField("QRY_AUX", "EMISSAO", "D")
	TCSetField("QRY_AUX", "DT_CANDEV", "D")
	
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
		
		cVend := QRY_AUX->(TIPO)
		
		//Imprimindo a linha atual
		oSectDad1:PrintLine()
		
		oSectDad2:Init()
		
		While QRY_AUX->(TIPO) == cVend
		
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
	aAdd(aRegs, {cPerg,"01","Data De             ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs, {cPerg,"02","Data Até            ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs, {cPerg,"03","Cliente De          ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","","",""})
	aAdd(aRegs, {cPerg,"04","Cliente Até         ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","","",""})
	aAdd(aRegs, {cPerg,"07","Filial De           ?","","","mv_ch5","C",04,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
	aAdd(aRegs, {cPerg,"08","Filial Até          ?","","","mv_ch6","C",04,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
		
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
