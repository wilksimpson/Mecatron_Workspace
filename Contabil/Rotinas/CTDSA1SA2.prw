#INCLUDE "rwmake.ch"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTDSA1SA2 � Autor �Jose CArlos A Dias F� Data �  17/02/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Gera o Item Contabil conforme Clientes e Fornecedores      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CTDSA1SA2
//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������
@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geracao da Tabela CTD")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ir� gerar a tabela CTD - Itens Contabeis conforme"
@ 18,018 Say " os Registros das Tabelas SA1 - Clientes e SA2 - Fornecedores  "
@ 70,128 BMPBUTTON TYPE 01 ACTION (_nOpc:=1,oGeraTxt:End())
@ 70,158 BMPBUTTON TYPE 02 ACTION (_nOpc:=2,oGeraTxt:End())
Activate Dialog oGeraTxt Centered
If _nOpc =1
	Processa({|| RunCont() },"Processando...")
Endif
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  17/02/12   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function RunCont

Local _cNum := ""
//Local _cLoj	:= ""
Local _cNom	:= ""
Local _nRec := 1
_CQRY := " SELECT R_E_C_N_O_  RECSA1 FROM "+RetSqlName("SA1")
_CQRY += " WHERE  A1_FILIAL='" + XFILIAL("SA1") + "' "
//_CQRY += " AND NOT EXISTS(SELECT 1 FROM "+RetSqlName("CTD")+ " CTD WHERE CTD_FILIAL = '"+xFilial("CTD")+"' AND CTD_ITEM LIKE 'C'+A1_COD+A1_LOJA+'%' AND CTD.D_E_L_E_T_ <> '*' ) "
_CQRY += " AND D_E_L_E_T_<>'*' "
_CQRY := CHANGEQUERY(_CQRY)
DBUSEAREA(.T., "TOPCONN", TCGENQRY(,,_CQRY), 'TMPSA1', .F., .T.)
ProcRegua(TMPSA1->(RecCount())) // Numero de registros a processar
TMPSA1->(DbGoTop())

While !(TMPSA1->(EOF()))
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������
	IncProc("Clientes..."+StrZero(_nRec,10,0))
	SA1->(DbGoto(TMPSA1->RECSA1))	

	_cNum := ""

	if EMPTY(SA1->A1_CGC)
		_cNum:="C"+SA1->A1_COD+SA1->A1_LOJA
	ELSEIF SA1->A1_PESSOA=='J'
		_cNum:="C"+SUBSTR(SA1->A1_CGC,1,8)+SUBSTR(SA1->A1_CGC,13,2)
	ELSE
	    _cNum:="C"+SUBSTR(SA1->A1_CGC,1,8)+SUBSTR(SA1->A1_CGC,10,2)
	endif

	if !empty(_cNum)
		RecLock("SA1",.F.)
			SA1->A1_ITEM := _cNum
		MsUnLock()
	endif

	_cNom	:= Alltrim(SA1->A1_NOME)	
	DbSelectArea("CTD")
	DbSetOrder(1) //CTD_FILIAL, CTD_ITEM
	If !(DbSeek(xFilial("CTD")+_cNum))
		RecLock("CTD",.T.)
		CTD->CTD_FILIAL := xFilial("CTD")
		CTD->CTD_ITEM	:= _cNum
		CTD->CTD_CLASSE	:= '2'
		CTD->CTD_NORMAL := '0'
		CTD->CTD_DESC01 := _cNom
		CTD->CTD_BLOQ	:= SA1->A1_MSBLQL
		CTD->CTD_DTEXIS	:= CTOD("01/01/2011")
		CTD->CTD_CLOBRG	:= '2'
		CTD->CTD_ACCLVL	:= '1'
		MsUnLock()
	Endif	
	TMPSA1->(dbSkip())
	_nRec++
EndDo
TMPSA1->(DbcloseArea())

_CQRY := " SELECT R_E_C_N_O_  RECSA2 FROM "+RetSqlName("SA2")
_CQRY += " WHERE  A2_FILIAL='" + XFILIAL("SA2") + "' "
//_CQRY += " AND NOT EXISTS(SELECT 1 FROM "+RetSqlName("CTD")+ " CTD WHERE CTD_FILIAL = '"+xFilial("CTD")+"' AND CTD_ITEM LIKE 'F'+A2_COD+A2_LOJA+'%' AND CTD.D_E_L_E_T_ <> '*' ) "
_CQRY += " AND D_E_L_E_T_<>'*' "
_CQRY := CHANGEQUERY(_CQRY)
DBUSEAREA(.T., "TOPCONN", TCGENQRY(,,_CQRY), 'TMPSA2', .F., .T.)

ProcRegua(TMPSA2->(RecCount())) // Numero de registros a processar
TMPSA2->(dbGoTop())
_nRec := 1

While !(TMPSA2->(EOF()))
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������
	IncProc("Fornecedores.."+StrZero(_nRec,10,0))	
	SA2->(DbGoto(TMPSA2->RECSA2))
	
	_cNum := ""


	if EMPTY(SA2->A2_CGC)
		_cNum:="F"+SA2->A2_COD+SA2->A2_LOJA
	ELSEIF SA2->A2_TIPO=='J'
		_cNum:="F"+SUBSTR(SA2->A2_CGC,1,8)+SUBSTR(SA2->A2_CGC,13,2)
	ELSE
	    _cNum:="F"+SUBSTR(SA2->A2_CGC,1,8)+SUBSTR(SA2->A2_CGC,10,2)
	endif

	if !empty(_cNum)
		RecLock("SA2",.F.)
			SA2->A2_ITEM := _cNum
		MsUnLock()
	endif

	_cNom := Alltrim(SA2->A2_NOME)	
	DbSelectArea("CTD")
	DbSetOrder(1) //CTD_FILIAL, CTD_ITEM
	If !(DbSeek(xFilial("CTD")+_cNum))
		RecLock("CTD",.T.)
		CTD->CTD_FILIAL := xFilial("CTD")
		CTD->CTD_ITEM	:= _cNum
		CTD->CTD_CLASSE	:= '2'
		CTD->CTD_NORMAL := '0'
		CTD->CTD_DESC01 := _cNom
		CTD->CTD_BLOQ	:= SA2->A2_MSBLQL
		CTD->CTD_DTEXIS	:= CTOD("01/01/2011")
		CTD->CTD_CLOBRG	:= '2'
		CTD->CTD_ACCLVL	:= '1'
		MsUnLock()
	Endif	
	TMPSA2->(dbSkip())
	_nRec++
EndDo
TMPSA2->(DbCloseArea())

Return

//User Function CTBNFS
//Processa({|| RunCont() },"Gerando novos Itens Contabeis")
//return ParamIxb
//User Function CTBNFE1
//Processa({|| RunCont() },"Gerando novos Itens Contabeis")
//return ParamIxb
