#INCLUDE "PROTHEUS.CH"
#include "TBIConn.ch"
#include "TopConn.ch"
#include "TBICode.ch"
//#INCLUDE "orcam.ch"

#DEFINE CRLF Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Orcam	    ³ Autor ³ Denis Haruo         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime o orcamento de venda                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Orcam()                                                       ³±±
±±³Uso		 ³ Mecatron                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Orcam_FT()        // incluido pelo assistente de conversao do AP6 IDE em 06/09/01

	Local oReport
	local lPrepare := IIF(type("cEmpAnt")=="U", .t., .f.)

	private oBrush := TBrush():New(,CLR_LIGHTGRAY)
	private oFonte_10N	:= TFont():New('ARIAL',,10,.T.,.T.)
	private oFonte_09	:= TFont():New('ARIAL',,09,.T.,.f.)
	private oFonte_10	:= TFont():New('ARIAL',,10,.T.,.f.)
	private oFonte_11N	:= TFont():New('ARIAL',,11.5,.T.,.T.)
	private oFonte_11	:= TFont():New('ARIAL',,11.5,.T.,.f.)
	private oFonte_12N	:= TFont():New('ARIAL',,12,.T.,.T.)
	private oFonte_12	:= TFont():New('ARIAL',,12,.T.,.f.)
	private oFonte_14N	:= TFont():New('ARIAL',,14,.T.,.T.)
	private oFonte_14	:= TFont():New('ARIAL',,14,.T.,.f.)
	private oFonte_18N	:= TFont():New('ARIAL',,18,.T.,.T.)
	private oFonte_18	:= TFont():New('ARIAL',,18,.T.,.F.)
	private oBox

	if lPrepare
		//Utilizada para instancionar em modo debugger
		//******************************************
		PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'
		//******************************************

		//Ativa o modo de interface grafica: alerts, msgboxes, etc
		//default __cInternet := AUTOMATICO
		__cInternet := NIL
	end

//Carregando definições do Relatório
	oReport:= ReportDef()
//oReport:PrintDialog()
	oReport:Print()

	if lPrepare
		//Desabilitar quando em produção
		//***************
		RESET ENVIRONMENT
	end

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Denis Haruo           ³ Data ³ 29/10/20 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport
Local oPreNota
Local nItem := 0
Local aItemPed  := {}
Local aCabPed	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("Or�amento Mecatron","Emissao da Confirmacao do Pedido","MTR730", {|oReport| ReportPrint(oReport,oPreNota,@nItem,aItemPed,aCabPed)}," ")	// "Emissao da Confirmacao do Pedido"###"Emissao da confirmacao dos pedidos de venda, de acordo com"###"intervalo informado na opcaoo Parametros."
oReport:SetPortrait() 
oReport:SetTotalInLine(.F.)
oReport:SetDevice(6)
oReport:SetFile(SC5->C5_NUM)
oReport:SetEnvironment(2)
//oReport:SetPreview(.T.)
oReport:oPage:setPaperSize(9)


Pergunte(oReport:uParam,.F.)

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Denis Haruo         ³ Data ³ 29/10/20   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,oPreNota,nItem,aItemPed,aCabPed)

local ni := 0
local nXi := 0
Local _lIpi := .F.
Local nLinha := 0
Local nLinProd := 0
Local cTesProd := ""
Local nTotPed := 0
Local nControl := 0 
Local nValDesc := 0

//Dados do Cabeçalho do Pedido/Orcamento
dbSelectArea("SC5")
// posiciona no cliente
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
aCabPed := {SC5->C5_NUM,;
			SC5->C5_VEND1,;
			SC5->C5_CLIENTE,;
			SC5->C5_LOJACLI,;
			SC5->C5_EMISSAO,;
			SA1->A1_NOME,;
			SA1->A1_CGC,;
			SA1->A1_END,;
			SA1->A1_CEP,;
			SA1->A1_BAIRRO,;
			SA1->A1_EST,;
			SA1->A1_MUN,;
			SA1->A1_INSCR,;
			SA1->A1_EMAIL,;
			SA1->A1_DDD,;
			SA1->A1_TEL}



//Dados do Item do Pedido/Orcamento
dbSelectArea("SC6")
dbSetOrder(1)
dbSeek(xFilial("SC6")+SC5->C5_NUM)
do while !EOF() .and. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM
	aadd(aItemPed,{	SC6->C6_ITEM,;		//1
					SC6->C6_PRODUTO,;	//2
					SC6->C6_DESCRI,;	//3
					SC6->C6_QTDVEN,;		//4
					SC6->C6_UM,;		//5
					SC6->C6_PRCVEN,;	//6 Valor Unitario
					SC6->C6_VALOR,;	//7 Valor do Item
					SC6->C6_VALDESC })		//8 Desconto % 

    nTotPed += SC6->C6_VALOR

	dbskip()
end do

ImpCabecR4(oReport,aCabPed)

nLinha := 1010
//Imprimindo os itens do Pedido
oReport:FillRect( {nLinha,0021,1100,2400}, oBrush )  //Quadro 3 - Detalhes do Pedido
oReport:Say(1030,1180,"ITENS",oFonte_14N)
oReport:Say(1060,0040,"Codigo",oFonte_10N)
oReport:Say(1060,0180,"Refer.",oFonte_10N)
oReport:Say(1060,0340,"Descri��o",oFonte_10N)
oReport:Say(1060,1595,"Qtde.",oFonte_10N)
oReport:Say(1060,1700,"UM",oFonte_10N)
oReport:Say(1060,1830,"Valor",oFonte_10N)
oReport:Say(1060,1920,"%IPI",oFonte_10N)
oReport:Say(1060,2050,"IPI",oFonte_10N)
oReport:Say(1060,2170,"ST",oFonte_10N)
oReport:Say(1060,2320,"Total",oFonte_10N)
nLinha := 1120

//Totalizadores
nTotPed := 0
nValMerc := 0
nTotIPI := 0
nTotICMS := 0 
nQtdtens := 0
nValDesc := 0

//For ni := 1 to len(aItemPed)
For ni := 1 to len(aItemPed)
	
	oReport:Say(nLinha,0040,aItemPed[ni,2],oFonte_12)	//cod
	//oReport:Say(nLinha,0220,aItemPed[ni,3],oFonte_12)	
	

	oReport:Say(nLinha,1545,padL(transform(aItemPed[ni,4],"@E 9,999.99"),10),oFonte_12) //quant
	oReport:Say(nLinha,1700,aItemPed[ni,5],oFonte_12)	//um	
	oReport:Say(nLinha,1760,padL(transform(aItemPed[ni,6],"@E 999,999.99"),10),oFonte_12)	//valor unitario
	
	_lIpi := .F.
	nPIPI := 0
	_CodRefer := ''

	DbSelectArea('SB1')
	DbSetOrder(1)
	DBSEEK(xfilial('SB1')+aItemPed[ni,2])

	nPIPI := SB1->B1_IPI
	cTesProd := SB1->B1_TS
	_CodRefer := SB1->B1_REFER

	oReport:Say(nLinha,0180,_CodRefer,oFonte_12)	//cod Referencia

	IF POSICIONE("SF4",1,XFILIAL("SF4")+cTesProd,"F4_IPI") == "S" .AND. nPIPI>0
	_lIpi := .T.
	endif

	// só cálcula e informa IPI se tiver aliquota e a TES for para calcular IPI.
	IF _lIpi 
    oReport:Say(nLinha,1910,padL(transform(nPIPI,"@E 99"),5),oFonte_12)	//%IPI
	nVIPI := 0
	nVIPI := (aItemPed[ni,7] * nPIPI) / 100 //Calcando valor do IPI
	oReport:Say(nLinha,1960,padL(transform(nVIPI,"@E 9,999.99"),10),oFonte_12)	//IPI
	else
	nPIPI := 0
    oReport:Say(nLinha,1900,padL(transform(nPIPI,"@E 99"),5),oFonte_12)	//%IPI
	nVIPI := 0
	oReport:Say(nLinha,1960,padL(transform(nVIPI,"@E 9,999.99"),10),oFonte_12)	//IPI
	endif
		
	//Calculo para ICMS Solidario
	nVICMSOL := 0
	oReport:Say(nLinha,2080,padL(transform(nVICMSOL,"@E 9,999.99"),10),oFonte_12)	//ICMS ST

	//Total do Item
	oReport:Say(nLinha,2230,padL(transform((aItemPed[ni,7]+nVIPI+nVICMSOL),"@E 999,999.99"),10),oFonte_12)	//total

		//descric
	nLinProd := nLinha
	For nXi := 1 To MLCount(alltrim(aItemPed[ni,3]),65)
	oReport:Say(nLinProd,0410,MemoLine(aItemPed[ni,3],65,nXi),oFonte_09)
	nLinProd += 40
	Next nXi
//	nLinha += 30
	if MLCount(alltrim(aItemPed[ni,3]),65) == 1
	nLinha += 55
	else	
	nLinha += 85
	endif
	
	//Somando totais
	nValMerc 	+= aItemPed[ni,7]
	nValDesc 	+= aItemPed[ni,8]
	nTotIPI		+= nVIPI
	nTotICMS 	+= nVICMSOL
	nTotPed 	+= aItemPed[ni,7] + nVIPI + nVICMSOL
	nQtdtens 	+= aItemPed[ni,4]

	nControl ++ // controle de paginas
	if nControl >= 25
		nControl := 0
		ImpRodR4(oReport,nLinha)
		oReport:EndPage()
		oReport:StartPage() //StartPage
		ImpCabecR4(oReport,aCabPed)

		nLinha := 1010
		//Imprimindo os itens do Pedido
		oReport:FillRect( {nLinha,0021,1100,2400}, oBrush )  //Quadro 3 - Detalhes do Pedido
		oReport:Say(1030,1180,"ITENS",oFonte_14N)
		oReport:Say(1060,0040,"C�digo",oFonte_10N)
		oReport:Say(1060,0180,"Refer.",oFonte_10N)
		oReport:Say(1060,0340,"Descri��o",oFonte_10N)
		oReport:Say(1060,1595,"Qtde.",oFonte_10N)
		oReport:Say(1060,1700,"UM",oFonte_10N)
		oReport:Say(1060,1830,"Valor",oFonte_10N)
		oReport:Say(1060,1920,"%IPI",oFonte_10N)
		oReport:Say(1060,2050,"IPI",oFonte_10N)
		oReport:Say(1060,2170,"ST",oFonte_10N)
		oReport:Say(1060,2320,"Total",oFonte_10N)
		nLinha := 1120
	ENDIF

next
oReport:FillRect( {nLinha,0021,nLinha+60,2400}, oBrush )  //Quadro 3 - Detalhes do Pedido
oReport:Say(nLinha+20,1180,"TOTAIS",oFonte_14N)	//totalizadores
oReport:Say(nLinha+20,1970,padL(transform(nTotIPI ,"@E 999,999.99"),10),oFonte_10N)	//totalizadores
oReport:Say(nLinha+20,2100,padL(transform(nTotICMS,"@E 999,999.99"),10),oFonte_10N)	//totalizadores
oReport:Say(nLinha+20,2260,padL(transform(nValMerc+nTotIPI+nTotICMS,"@E 9,999,999.99"),10),oFonte_10N)	//totalizadores

/*********************
//Imprmindo os Rodapés
*********************/
nLinha += 100
//Resumo do Pedido
oReport:FillRect( {nLinha,0021,nLinha+80,2400}, oBrush )  //Quadro 5 - Detalhes do Pedido
oReport:Say(nLinha+30,1120,"RESUMO DO PEDIDO",oFonte_14N)

nLinha += 100
oReport:Say(nLinha,50,"Vendedor:",oFonte_14N)
oReport:Say(nLinha,1240,"Val. Merc.:",oFonte_14N)
oReport:Say(nLinha,1640,"Total do Pedido:",oFonte_14N)

nLinha += 50
cVendedor := SC5->C5_VEND1 + "-" + alltrim(posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NREDUZ"))   
oReport:Say(nLinha,50,cVendedor,oFonte_14) //Cod + Nome Vend
oReport:Say(nLinha,1240,LTrim("R$ "+transform(nTotPed,"@E 9,999,999.99")),oFonte_14)	//totalizadores
oReport:Say(nLinha,1640,LTrim("R$ "+transform(nTotPed,"@E 9,999,999.99")),oFonte_14)	//totalizadores

nLinha += 80 
oReport:Say(nLinha,50,"Transportadora:",oFonte_14N)
oReport:Say(nLinha,1240,"Valor Frete:",oFonte_14N)
oReport:Say(nLinha,1640,"Tipo Frete:",oFonte_14N)

nLinha += 50
cTransp := alltrim(posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NREDUZ")) 
oReport:Say(nLinha,50,cTransp,oFonte_14)
oReport:Say(nLinha,1240,LTrim("R$ "+transform(SC5->C5_FRETE,"@E 999,999.99")),oFonte_14)
oReport:Say(nLinha,1640,IIF(SC5->C5_TPFRETE == "C","CIF","FOB"),oFonte_14)

nLinha += 80
oReport:Say(nLinha,0050,"Qtde. Itens:",oFonte_14N)
oReport:Say(nLinha,0440,"Valor IPI:",oFonte_14N)
oReport:Say(nLinha,0840,"Valor ICMS ST:",oFonte_14N)
oReport:Say(nLinha,1240,"Creditos:",oFonte_14N)
oReport:Say(nLinha,1640,"Descontos:",oFonte_14N)
oReport:Say(nLinha,2040,"Despesas:",oFonte_14N)

nLinha += 50
oReport:Say(nLinha,0050,LTrim(transform(nQtdtens,"@E 999,999")),oFonte_14)
oReport:Say(nLinha,0440,LTrim("R$ "+transform(nTotIPI,"@E 999,999.99")),oFonte_14)
oReport:Say(nLinha,0840,LTrim("R$ "+transform(nTotICMS,"@E 999,999.99")),oFonte_14)
oReport:Say(nLinha,1240,LTrim("R$ "+transform(0,"@E 9,999,999.99")),oFonte_14)//SL1->L1_CREDITO   
oReport:Say(nLinha,1640,LTrim("R$ "+transform(nValDesc,"@E 9,999,999.99")),oFonte_14)
oReport:Say(nLinha,2040,LTrim("R$ "+transform(SC5->C5_DESPESA,"@E 9,999,999.99")),oFonte_14)

nLinha += 80
oReport:Say(nLinha,0050,"Cond. Pagto:",oFonte_14N)
oReport:Say(nLinha,0840,"Especie:",oFonte_14N)
oReport:Say(nLinha,1640,"Banco/AG/CC :",oFonte_14N)
nLinha += 50
IF !EMPTY(SC5->C5_CONDPAG)
	DBSelectArea("SE4")
	dbSetOrder(1)
	DBSEEK(XFILIAL("SE4")+SC5->C5_CONDPAG)
oReport:Say(nLinha,0050,SE4->E4_DESCRI,oFonte_14)
oReport:Say(nLinha,0840,SE4->E4_FORMA,oFonte_14) 
ENDIF
oReport:Say(nLinha,1640,"",oFonte_14) // dados bancário

nLinha += 55
oReport:Say(nLinha,0050,"Numero da Parcela:",oFonte_14N)
oReport:Say(nLinha,0840,"Valor:",oFonte_14N)
oReport:Say(nLinha,1640,"Vencimento:",oFonte_14N)
/*
//Verificando Condicao de pagamento negociada SL4
nNumParc := 0
cQry := ""
cQry += " select * from "+RetSQLName("SL4")+" "
cQry += " WHERE L4_FILIAL = '"+xFilial("SL4")+"' and "
cQry += " 		L4_NUM = '"+SL1->L1_NUM+"' and "
cQry += " 		D_E_L_E_T_ = '' "
TcQuery cQry NEW ALIAS 'QRY'
DBSelectArea("QRY")
DBGoTop()
do while !EOF()
	nNumParc += 1
	nLinha += 50
	oReport:Say(nLinha,0050,cValToChar(nNumParc),oFonte_14)
	oReport:Say(nLinha,0840,LTrim("R$ "+transform(QRY->L4_VALOR,"@E 999,999.99")),oFonte_14)
	oReport:Say(nLinha,1640,DTOC(STOD(QRY->L4_DATA)),oFonte_14)
	oReport:Say(nLinha,1970,QRY->L4_FORMA,oFonte_14)
dbskip()
end do 
QRY->(DbCloseArea())
*/
//Observações da Nota
	nLinha += 90

	cMsg := ""
	IF !EMPTY(SC5->C5_OBS)
		cMsg += SC5->C5_OBS
	endif

/*/IF !EMPTY(SL1->L1_MOTOBOY) 
	cMsg += ALLTRIM(POSICIONE("SA2",1,XFILIAL("SA2")+SL1->L1_MOTOBOY,"A2_NOME"))
endif
/*/
oReport:Box(nLinha,0020,nLinha+200,2400,oBox) //Quadro 6
oReport:Say(nLinha+50,50,"Observa��es Gerais:",oFonte_14N)

For nXi := 1 To MLCount(cMsg,110)
	oReport:Say(nLinha+100,080,MemoLine(cMsg,110,nXi),oFonte_10)
	nLinha += 40
Next nXi

//Area de Assinatura do Cliente
nLinha += 350
oReport:Say(nLinha		,340,"__________________________________",oFonte_14)
oReport:Say(nLinha+50	,440,"Assinatura do Conferente",oFonte_14)

oReport:Say(nLinha		,1240,"__________________________________",oFonte_14)
oReport:Say(nLinha+50	,1440,"Assinatura do Cliente",oFonte_14)

nLinha += 200
oReport:Say(nLinha,740,"DOCUMENTO AUXILIAR DE VENDA. SEM VALOR FISCAL!",oFonte_14)


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImpCabecR4³ Autor ³ Denis Haruo          ³ Data ³ 29/10/20  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabecR4(oReport,aCabPed)
	Local nPrinLin  := 0
	Local _Situac	:= "Liberado"

//local oFonte_14N:= TFont():New('ARIAL',,14,.T.,.T.)
//local oFonte_14	:= TFont():New('ARIAL',,14,.T.,.f.)
//local oFonte_18N:= TFont():New('ARIAL',,18,.T.,.T.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa impressao do cabecalho                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:HideHeader()			// Nao imprime cabecalho padrao do Protheus
	oReport:HideFooter()			// Nao imprime rodapé padrao do Protheus


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha as caixas do cabecalho Dados da Empresa             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Box(0020,0020,3400,2400,oBox) //Quadro 1 - Dados da Empresa

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Informacoes do Quadro 1: Dados da Empresa        
// Logotipo + Textos           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//TReport():SayBitmap( <nRow> , <nCol> , <cBitmap> , <nWidth> , <nHeight> , <nRaster> ) 
	oReport:SayBitmap(0060,0080,'\imagens\mecatron.jpg',532,324)
	nPrinLin += 30
	oReport:Say(nPrinLin+020,0710,ALLTRIM(SM0->M0_NOMECOM),oFonte_14N)
	oReport:Say(nPrinLin+070,0710,"CNPJ: "+TRANSFORM(ALLTRIM(SM0->M0_CGC), "@r 99.999.999/9999-99"),oFonte_14) //10.441.638/0001-11
	oReport:Say(nPrinLin+120,0710,"Endere�o: "+SM0->M0_ENDENT,oFonte_14)
	oReport:Say(nPrinLin+170,0710,"Bairro: "+SM0->M0_BAIRENT,oFonte_14)
	oReport:Say(nPrinLin+220,0710,"Cidade: "+alltrim(SM0->M0_CIDENT)+" / "+SM0->M0_ESTENT+" - CEP: "+SM0->M0_CEPENT,oFonte_14)
	oReport:Say(nPrinLin+270,0710,"Telefone: "+SM0->M0_TEL ,oFonte_14)
	oReport:Say(nPrinLin+320,0710,"E-mail: contato@mecatron.net",oFonte_14)
	cDataEmissao := cValToChar(day(SC5->C5_EMISSAO))+"/"+cValToChar(month(SC5->C5_EMISSAO))+"/"+cValToChar(year(SC5->C5_EMISSAO))
	oReport:Say(nPrinLin+340,1550,"Data de Emiss�o: "+cDataEmissao+ " as "+time() ,oFonte_14N)

	IF  !EMPTY(SC5->C5_NOTA)
		_Situac	:= "Faturado"
	elseif EMPTY(SC5->C5_NOTA) .and. SC5->C5_LIBEROK == "S"
		_Situac	:= "Pedido de Venda Liberado"
	else
		_Situac	:= "Pedido de Venda"
	endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha as caixas do cabecalho dados do cliente             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPrinLin := 420

	dbSelectArea("SA1")
	dbSetOrder(1)
	dbseek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	oReport:Box(nPrinLin,0020,0510,2400,oBox) //Quadro 2 - Numero do Pedido
	oReport:FillRect( {nPrinLin,0021,0510,2400}, oBrush )
	oReport:Say(0440,0830,"PEDIDO DE VENDA No.: "+SC5->C5_NUM  ,oFonte_18N)
	oReport:Say(0440,1890,"(Situa��o: "+_Situac+")",oFonte_18)

	oReport:Box(510,020,1010,2400,oBox) //Quadro 3 - Detalhes do Cliente
//***Primeira linha***
	oReport:Say(550,50,"Codigo:",oFonte_14N)
	oReport:Say(600,50,SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI,oFonte_14)
	oReport:Say(550,540,"Nome:",oFonte_14N)
	oReport:Say(600,540,alltrim(SA1->A1_NOME),oFonte_14)
	oReport:Say(550,1670,"CPF/CGC:",oFonte_14N)
	oReport:Say(600,1670,SA1->A1_CGC,oFonte_14)
//***FIM Primeira linha***

//***Segunda Linha***
	oReport:Say(650,50,"Endere�o:",oFonte_14N)
	oReport:Say(700,50,alltrim(SA1->A1_END),oFonte_14)
	oReport:Say(650,1040,"Complemento:",oFonte_14N)
	oReport:Say(700,1040,alltrim(SA1->A1_COMPLEM),oFonte_14)
	oReport:Say(650,1670,"Bairro:",oFonte_14N)
	oReport:Say(700,1670,alltrim(SA1->A1_BAIRRO),oFonte_14)

//***Terceira Linha***
	oReport:Say(770,50,"CEP:",oFonte_14N)
	oReport:Say(820,50,SA1->A1_CEP,oFonte_14)
	oReport:Say(770,540,"Telefone:",oFonte_14N)
	oReport:Say(820,490,SA1->A1_DDD +" "+SA1->A1_TEL,oFonte_14)
	oReport:Say(770,1040,"Telefone 2:",oFonte_14N)
	oReport:Say(820,0990,SA1->A1_DDD +" "+SA1->A1_FAX,oFonte_14)
	oReport:Say(770,1670,"E-mail:",oFonte_14N)
	oReport:Say(820,1670,alltrim(SA1->A1_EMAIL),oFonte_14)
//***FIM Terceira Linha***

//***QUARTA LINHA***
	oReport:Say(890,50,"Cidade:",oFonte_14N)
	oReport:Say(940,50,alltrim(SA1->A1_MUN),oFonte_14)
	oReport:Say(890,1670,"Contato:",oFonte_14N)
	oReport:Say(940,1670,alltrim(SA1->A1_CONTATO),oFonte_14)
//***FIM QUARTA LINHA***

Return( .T. )

/*/
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������Ŀ��
	���Fun��o    �ImpRodR4� Autor � wilk Lima          � Data � 09/02/22      ���
	�������������������������������������������������������������������������Ĵ��
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
/*/
Static Function ImpRodR4(oReport,nLinha)
	oReport:FillRect( {nLinha,0021,nLinha+60,2400}, oBrush )  //Quadro 3 - Detalhes do Pedido
//oReport:Say(nLinha+20,1180,"CONTINUA NA PR�XIMA P�GINA",oFonte_14N)	//totalizadores

/*********************
//Imprmindo os Rodap�s
*********************/
nLinha += 100
//Resumo do Pedido
oReport:FillRect( {nLinha,0021,nLinha+80,2400}, oBrush )  //Quadro 5 - Detalhes do Pedido
oReport:Say(nLinha+30,1120,"CONTINUA NA PR�XIMA P�GINA",oFonte_14N)

nLinha += 100
oReport:Say(nLinha,50,"Vendedor:",oFonte_14N)
//oReport:Say(nLinha,1240,"Val. Merc.:",oFonte_14N)
//oReport:Say(nLinha,1640,"Total do Pedido:",oFonte_14N)

nLinha += 50
cVendedor := SL1->L1_VEND + "-" + alltrim(posicione("SA3",1,xFilial("SA3")+SL1->L1_VEND,"A3_NREDUZ"))   
oReport:Say(nLinha,50,cVendedor,oFonte_14) //Cod + Nome Vend
//oReport:Say(nLinha,1240,LTrim("R$ "+transform(SL1->L1_VALMERC,"@E 999,999.99")),oFonte_14)	//totalizadores
//oReport:Say(nLinha,1640,LTrim("R$ "+transform(SL1->L1_VLRLIQ,"@E 999,999.99")),oFonte_14)	//totalizadores




//Area de Assinatura do Cliente
nLinha += 150
oReport:Say(nLinha		,340,"__________________________________",oFonte_14)
oReport:Say(nLinha+50	,440,"Assinatura do Conferente",oFonte_14)

oReport:Say(nLinha		,1240,"__________________________________",oFonte_14)
oReport:Say(nLinha+50	,1440,"Assinatura do Cliente",oFonte_14)

nLinha += 400
oReport:Say(nLinha,740,"DOCUMENTO AUXILIAR DE VENDA. SEM VALOR FISCAL!",oFonte_14)

Return( .T. )
