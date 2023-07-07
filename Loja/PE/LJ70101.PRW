#Include "Protheus.ch"
#include "TopConn.ch"
#INCLUDE "COLORS.CH"
#include "rwmake.ch"
#DEFINE DS_MODALFRAME 128

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
//±±ºPrograma  LJ70101    º Autor João Felipe Costa Braga Data ³ 05.02.2021 º±±
//±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
//±±ºDescricao ³ REPONSAVEL PELA AÇÃO DE ESCOLHER A TABELA DE PRECO         º±±
//±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function LJ70101()
	Local lRet := .T. //Retorno da funcao
	Local cOperacao 	:= PARAMIXB[1]

	If cOperacao  == "1" //1=O ponto de entrada é executado antes de incluir o item na venda
	

	ElseIf cOperacao  == "2" //2=O ponto de entrada é executado após incluir o item na venda

		//Obtem a tabela de preço atual do item
		cDifIcm := POSICIONE("SA1",1,XFILIAL("SA1")+M->LQ_CLIENTE+M->LQ_LOJA,"A1_ICMSDIF")
			IF cDifIcm == "S"
				cTab := "3"
			ELSE
				cTab := "1"
			ENDIF
			
			RETPRECO(cTab)
//			LJ7ALTCF()
	
	EndIf

Return lRet

//FUNCAO VALID LQ_CLIENTE
User Function  LJPrcCli()
Local _NI := 0
Local _bRet := .T.
Local cTab  := ""

	//EVITA A LIMPEZA DA FORMA DE PAGAMENTO PARA OS FATURISTAS 
	IF SL1->L1_NUM != M->LQ_NUM .OR. SL1->L1_CLIENTE != M->LQ_CLIENTE
		
		cDifIcm := POSICIONE("SA1",1,XFILIAL("SA1")+M->LQ_CLIENTE+M->LQ_LOJA,"A1_ICMSDIF")
			IF cDifIcm == "S"
				cTab := "3"
			ELSE
				cTab := "1"
			ENDIF

		FOR _NI:=1 TO LEN(ACOLS)
			If !aCols[_NI][Len(aCols[_NI])]
				N:=_NI
				RETPRECO(cTab)
			Endif
		NEXT

	ENDIF

return _bRet


//RESPONSAVEL POR RETORNAR O PREÇO DO PRODUTO DE ACORDO COM A TABELA DE PREÇO
Static function RETPRECO(cTab)

	Local _nPosCod   	:= AsCan(aheader,{|x|Alltrim(x[2])="LR_PRODUTO"})
	Local _nPosvLUNT 	:= AsCan(aheader,{|x|Alltrim(x[2])="LR_VRUNIT"})
	Local nPosVlItem 	:= AsCan(aheader,{|x|Alltrim(x[2])="LR_VLRITEM"})
	Local nPosTAB    	:= AsCan(aposcpodet,{|x|Alltrim(x[1])="LR_PRCTAB"})
	Local nPosTAB1   	:= AsCan(aposcpodet,{|x|Alltrim(x[1])="LR_TABELA"})
	Local nPosqtd    	:= AsCan(aheader,{|x|Alltrim(x[2])="LR_QUANT"})
	Local nPosDesc		:= aPosCpo[Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_DESC"})][2]
	Local nPosValDesc	:= aPosCpo[Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_VALDESC"})][2]
	Local nPosTES   	:= AsCan(aposcpodet,{|x|Alltrim(x[1])="LR_TES"})
	Local nPosCF		:= Ascan(aPosCpoDet,{|x| AllTrim(Upper(x[1])) == "LR_CF"})
	Local nPosClasFis 	:= Ascan(aPosCpo,{|x| AllTrim(Upper(x[1])) == "LR_CLASFIS"})			// Classifica��o 
	Local nPosNLote  	:= Ascan(aPosCpoDet,{|x| AllTrim(Upper(x[1])) == "LR_NLOTE"})			// Posicao do Sub Lote
	Local nPosLoteCTL	:= Ascan(aPosCpoDet,{|x| AllTrim(Upper(x[1])) == "LR_LOTECTL"})			// Posicao do Lote

	Local _cTp := cTab
	Local nX := 0
	
	DbSelectarea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(dbgotop())
	DbSelectarea("SB0")
	SB0->(DbSetOrder(1))
	SB0->(dbgotop())

	IF EMPTY(acols[n,_nPosCod])
		return
	ENDIF


	IF 	SB1->(DbSeek(xFilial("SB1")+acols[n,_nPosCod])) .AND. SB0->(DbSeek(xFilial("SB0")+acols[n,_nPosCod]))
		//ALTERA O PREÇO DO PRODUTO

		IF cNivel > 5
			nPrc := PrcPrd(&("SB0->B0_PRV"+_cTp))
		ELSE
			nPrc := &("SB0->B0_PRV"+_cTp)
		ENDIF

		acols[n,_nPosvLUNT] := nPrc
		M->LR_VRUNIT := nPrc
		M->LR_PRCTAB := nPrc
		M->LR_TABELA := _cTp
		M->LR_VLRITEM := M->LR_VRUNIT * acols[n,nPosqtd]
		acols[n,nPosVlItem] := M->LR_VLRITEM
		aCols[n][nPosDesc]		:= 0
		aCols[n][nPosValDesc]	:= 0
		IF _cTp == "3"
			acolsdet[n][nPosTes]	:= "504"
			aColsDet[n][nPosCF]	:= MaFisRet(n,"IT_CF")
			aCols[n][nPosClasFis] := iIf(ExistFunc("Lj7RetClasFis"), Lj7RetClasFis(/*cProd*/,"504",aColsDet[n][nPosNLote], aColsDet[n][nPosLoteCTL],/*nItens*/n), Space(TamSx3("LR_CLASFIS")[1]))
			M->LR_CLASFIS := aCols[n][nPosClasFis]
			M->LR_TES := "504"
		ENDIF

		//ATUALIZA O TOTALIZADOR DETALHE
		LJ7DETALHE()

		acolsdet[n,nPosTAB1] := _cTp
		acolsdet[n,nPosTAB] := nPrc



		nAuxTotal := 0
		For nX := 1 To Len(aCols)
			If !aCols[nX][Len(aCols[nx])]
				If MaFisFound("IT",nX) //.and. ( MaFisRet(nX,"IT_QUANT") <> acols[nX,nPosqtd] .OR. MaFisRet(nX,"IT_VALMERC") <> acols[nX,nPosVlItem])
					MaFisAlt("IT_QUANT",acols[nX,nPosqtd],nX)
					MaFisAlt("IT_VALMERC",acols[nX,nPosVlItem],nX)
					MaFisAlt("IT_TOTAL",acols[nX,nPosqtd]*acols[nX,nPosVlItem],nX)
					aColsDet[nX][nPosCF]	:= MaFisRet(nX,"IT_CF")

					IF _cTp == "3"
						MaFisAlt("IT_TES","504",nX)
					ENDIF
					MaFisRecal("", nX)

				EndIf

				nAuxTotal := nAuxTotal + If( MaFisFound("IT",nX),MaFisRet( nX, "IT_TOTAL" ),aCols[nX][nPosVlItem] )
			endif
		next
		Lj7T_Subtotal	( 2, nAuxTotal )
		Lj7T_Total		( 2, Lj7T_Subtotal(2) - Lj7T_DescV(2) )
		Lj7ZeraPgtos()
		aDesconto		:= { 0, 0, 0 }
	
	ELSE
		ALERT("Tabela de preco do produto "+acols[n,_nPosCod]+" nao foi localizada. Por favor, verifique o pre�o dos itens no or�amento")
	ENDIF

	if valtype(oGetVA) <> 'U'
		oGetVA:oBrowse:REFRESH()
	endif
Return

Static Function PrcPrd(nPrc)
	Local nPrcBkp := nPrc
	@ 200,1 to 250,210 dialog Ofovb TITLE oemtoansi("Informe o pre�o")
	iw_say(30,10,"Pre�o:")
	@ 010,010 Get nPrc PICTURE PesqPict("SLR","LR_VRUNIT") VALID(nPrc >= nPrcBkp) SIZE 50,50
	@ 010,080 BMPBUTTON TYPE 01 ACTION close(Ofovb)
	ACTIVATE DIALOG Ofovb CENTERED

	IF nPrc < nPrcBkp
		nPrc := nPrcBkp
	ENDIF

Return nPrc
