
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M020INC   �Autor  WILK LIMA           � Data �  11/05/2022  ���
�������������������������������������������������������������������������͹��
���Desc.     � CRIA ITEM CONTABIL A PARTIR DA INCLUSAO DO FORNECEDOR      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Mecatron                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function M020INC()
	Local aDadosAuto := {}		// Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica
	Local 	cItemcont:=""
	Private lMsHelpAuto := .f.	// Determina se as mensagens de help devem ser direcionadas para o arq. de log
	Private lMsErroAuto := .f.	// Determina se houve alguma inconsistencia na execucao da rotina em relacao aos

	IF SA2->A2_TIPO=='J'
		cItemcont:="F"+SUBSTR(A2_CGC,1,8)+SUBSTR(A2_CGC,13,2)
	Else
		cItemcont:="F"+SUBSTR(A2_CGC,1,8)+SUBSTR(A2_CGC,10,2)
	ENDIF

	dbSelectArea("CTD")
	dbSetOrder(1)
	dbseek(xFilial("CTD")+cItemcont)
	If !EMPTY(SA2->A2_CGC)
		aDadosAuto:= {	{'CTD_ITEM'   , cItemcont	, Nil},;	// Especifica qual o C�digo do item contabil
		{'CTD_CLASSE'    , "2"			, Nil},;	// Especifica a classe do Centro de Custo, que  poder� ser: - Sint�tica: Centros de Custo totalizadores dos Centros de Custo Anal�ticos - Anal�tica: Centros de Custo que recebem os valores dos lan�amentos cont�beis
		{'CTD_NORMAL'    , "0"			, Nil},;	// Indica a classifica��o do centro de custo. 1-Receita ; 2-Despesa
		{'CTD_DESC01'    , SA2->A2_NOME , Nil},;	// Indica a Nomenclatura do item contabil na Moeda 1
		{'CTD_BLOQ'  , "2"			    , Nil},;	// Indica se o Centro de Custo est� ou n�o bloqueado para os lan�amentos cont�beis.
		{'CTD_DTEXIS' , CTOD("01/01/11"), Nil},;	// Especifica qual a Data de In�cio de Exist�ncia para este Centro de Custo
		{'CTD_CCLP' , cItemcont			, Nil}}  	// Indica o Centro de Custo de Apura��o de Resultado.


		MSExecAuto({|x, y| CTBA040(x, y)},aDadosAuto, 3)

		If lMsErroAuto
			lRetorno := .F.
			MostraErro()
		Else
			lRetorno:=.T.	
				RecLock("SA2",.F.)
				SA2->A2_ITEM := cItemcont
				MsUnLock()
		EndIf
	EndIf


Return
