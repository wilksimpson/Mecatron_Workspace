#Include "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � SF1110I  � Autor �  Wilk Lima   � Data �23/06/2020�		   ��
�������������������������������������������������������������������������Ĵ��
���Descri��o � Permite gravar o historico do titulo no financeiro         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para clientes Microsiga.                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function SF1100I()
Local _cTpNf := SF1->F1_TIPO
Local _cNomFor := ""
Private _cArea := GetArea()

// GRAVA NOME DO FORNECEDOR QUANDO NOTA DE COMPLEMENTO OU FRETE.
IF _cTpNf $ 'N/C' 
	DbSelectArea("SA2")
	DbSetOrder(1)
	DbSeek(XFILIAL("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
	_cNomFor := SA2->A2_NOME
	DBCloseArea()
ENDIF

// GRAVA NOME DO CLIENTE QUANDO NOTA DE DEVOLU��O OU BENEFICI�RIO.
IF _cTpNf $ 'D/B' 
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(XFILIAL("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)
	_cNomFor := SA1->A1_NOME
	DBCloseArea()
ENDIF

if !EMPTY(_cNomFor)
	SF1->F1_NOMFOR := _cNomFor
ENDIF

@ 00,00 TO 150,620 DIALOG oDlg1 TITLE "DADOS FINANCEIRO"
oGt      := NIL
_cBanco  := Space(03)
_cHist := Space(60)
@ 010,005 Say OemToAnsi("Historico")
@ 010,040 GET _cHist VALID .t. Object oGt SIZE 200,30
@ 024,005 Say OemToAnsi("Cart�o de cr�dito?")
@ 024,040 GET _cBanco VALID .t. F3 "SA6" Object oGt SIZE 40,30

@ 040,080 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
@ 040,130 BMPBUTTON TYPE 1 ACTION Grava()
ACTIVATE DIALOG oDlg1 CENTER


Restarea(_cArea)

Return()

//�������������������������Ŀ
//�Grava historio no SF1/SE2�
//���������������������������

Static Function Grava()

DbSelectArea("SE2")
DbSetOrder(6)
DbGoTop()
DbSeek(xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC)
While !EOF() .AND. SE2->E2_NUM == SF1->F1_DOC ;
	.AND. SE2->E2_PREFIXO == SF1->F1_SERIE;
	.AND. SE2->E2_FORNECE == SF1->F1_FORNECE;
	.AND. SE2->E2_LOJA == SF1->F1_LOJA
	
    WHILE !RECLOCK("SE2");ENDDO
	SE2->E2_HIST    := _cHist   
	SE2->E2_PORTADO := _cBanco   
	MsUnlock()
	
	DbSelectArea("SE2")
	SE2->(DbSkip())
End



Close(oDlg1)
RestArea(_cArea)

return()
