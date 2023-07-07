/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³m030inc   ºAutor  ³WILK LIMA           º Data ³  11/05/2022 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Gravar o item contabil do Cliente na inclusao            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mecatron                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function M030INC()
	local _aArea := getArea()
	Local aDadosAuto := {}		// Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica
	Local 	cItemcont:=""
	Private lMsHelpAuto := .f.	// Determina se as mensagens de help devem ser direcionadas para o arq. de log
	Private lMsErroAuto := .f.	// Determina se houve alguma inconsistencia na execucao da rotina em relacao aos

	If PARAMIXB # 3
		IF SA1->A1_PESSOA=='J'
			cItemcont:="C"+SUBSTR(A1_CGC,1,8)+SUBSTR(A1_CGC,13,2)
		Else
			cItemcont:="C"+SUBSTR(A1_CGC,1,8)+SUBSTR(A1_CGC,10,2)
		ENDIF

		dbSelectArea("CTD")
		dbSetOrder(1)
		dbseek(xFilial("CTD")+cItemcont)
		If !EMPTY(SA1->A1_CGC)
			aDadosAuto:= {	{'CTD_ITEM'   , cItemcont	, Nil},;	// Especifica qual o Código do item contabil
			{'CTD_CLASSE'    , "2"			, Nil},;	// Especifica a classe do Centro de Custo, que  poderá ser: - Sintética: Centros de Custo totalizadores dos Centros de Custo Analíticos - Analítica: Centros de Custo que recebem os valores dos lançamentos contábeis
			{'CTD_NORMAL'    , "0"			, Nil},;	// Indica a classificação do centro de custo. 1-Receita ; 2-Despesa
			{'CTD_DESC01'    , SA1->A1_NOME , Nil},;	// Indica a Nomenclatura do item contabil na Moeda 1
			{'CTD_BLOQ'  , "2"			    , Nil},;	// Indica se o Centro de Custo está ou não bloqueado para os lançamentos contábeis.
			{'CTD_DTEXIS' , CTOD("01/01/11"), Nil},;	// Especifica qual a Data de Início de Existência para este Centro de Custo
			{'CTD_CCLP' , cItemcont			, Nil}}  	// Indica o Centro de Custo de Apuração de Resultado.


			MSExecAuto({|x, y| CTBA040(x, y)},aDadosAuto, 3)

			If lMsErroAuto
				lRetorno := .F.
				MostraErro()
			Else
				lRetorno:=.T.
					RecLock("SA1",.F.)
					SA1->A1_ITEM := cItemcont
					MsUnLock()
			EndIf
		EndIf


	endif
	RestArea(_aARea)
Return()

