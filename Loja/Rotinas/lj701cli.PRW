#INCLUDE "protheus.ch"
#INCLUDE "RWMAKE.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �FRTAltCli � Autor � Cesar Eduardo Valadao � Data �20/07/2000���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Alteracao do Cliente	(F10)                                 ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � SIGAFRT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
uSER Function LJ701CLI(_cCliente,_cLoja,_nValor)
Public _lBloq := .t.
Public _lnoFin  := .f.
Public _nSaldo := 0
Public _cNomcli := "Obrigado! Volte Sempre" +chr(10)
cStatus := ""
cbmp = "BOMBE"
adados :=""


//CrdAExtrato( 2 , SA1->A1_CGC)
//CrdAExtrato( 1 , SA1->A1_CGC)

_lBloq := u_LjCreCli( _cCliente, _cLoja, , , , @cStatus,,@cBmp,_nValor,@adados,@_lNoFin,@_nSaldo )  

/*If !_lBloq
	DEFINE MSDIALOG oDlgMotCre FROM 47,130 TO 175,490;
	TITLE OemToAnsi("An�lise de Cr�dito") PIXEL
	
	DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 12,14 BOLD
	
	// Resultado
	@ 04,41 TO 41,175 LABEL "Resultado" OF oDlgMotCre PIXEL
	@ 13,44 Say OemToAnsi(cStatus) SIZE 130,27 OF oDlgMotCre PIXEL FONT oFont COLOR CLR_RED
	
	@ 4,04 BITMAP RESOURCE cBmp OF oDlgMotCre PIXEL SIZE 32,32 ADJUST When .F. NOBORDER
	
	//�������������������������Ŀ
	//� Botoes para confirmacao �
	//���������������������������
	DEFINE SBUTTON FROM 47, 148 oButton2 TYPE 1 ENABLE OF oDlgMotCre ;
	ACTION (oDlgMotCre:End()) PIXEL
	
	ACTIVATE MSDIALOG oDlgMotCre CENTERED
	oFont:end()
Endif


if !empty(adados) 
	cbmp = "BOMBE"

	DEFINE MSDIALOG oDlgMotCre FROM 47,130 TO 175,490;
	TITLE OemToAnsi("An�lise de Cr�dito") PIXEL
	
	DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 12,14 BOLD
	
	// Resultado
	@ 04,41 TO 41,175 LABEL "Resultado" OF oDlgMotCre PIXEL
	@ 13,44 Say OemToAnsi(aDados) SIZE 130,27 OF oDlgMotCre PIXEL FONT oFont COLOR CLR_RED
	
	@ 4,04 BITMAP RESOURCE cBmp OF oDlgMotCre PIXEL SIZE 32,32 ADJUST When .F. NOBORDER
	
	//�������������������������Ŀ
	//� Botoes para confirmacao �
	//���������������������������
	DEFINE SBUTTON FROM 47, 148 oButton2 TYPE 1 ENABLE OF oDlgMotCre ;
	ACTION (oDlgMotCre:End()) PIXEL
	
	ACTIVATE MSDIALOG oDlgMotCre CENTERED
	oFont:end()
Endif
  */
Return(_lBloq)
//Return(_lBloq)
