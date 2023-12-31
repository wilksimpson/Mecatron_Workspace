#Include "Protheus.ch"
#include "TopConn.ch"
#INCLUDE "COLORS.CH"
#include "rwmake.ch"
#include "tbiconn.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "PRTOPDEF.CH"

//iMPORTA ncm.

User Function VIMPNCM()


	Processa( {|lEnd| ImpCad() 		} , "Por favor aguarde, importando NCMs ...")

RETURN

Static Function ImpCad()
	Local cArquivo  	:= ""
	Local cTipoArq 		:= "Todos os Arquivos (*.*)     | *.* | Arquivos Texto (*.TXT)     | *.TXT | Arquivos Separados por v�rgula (*.CSV)     | *.CSV |"
	Local cCadastro	  	:= OemToAnsi("Importa��o de NCM")
	Local nHandle   	:= 0
	Local nOpca			:= 0
	Local aButtons		:= {}
	Local aSays			:= {}

	Aadd(aSays,OemToAnsi( "Esta rotina realiza a importa��o DE NCM" ) )
	Aadd(aButtons, { 1,.T.,{|| nOpca := 1, FechaBatch()}} )
	Aadd(aButtons, { 2,.T.,{|| nOpca := 0, FechaBatch()}} )

	FormBatch( cCadastro , aSays , aButtons )

	IF nOpca == 0
		Return(.T.)
	EndIF

	cDir		:= cGetFile(cTipoArq,"Selecione o arquivo que ser� importado",0,,.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
	cArquivo	:= SubStr(cDir,RAT("\",cDir) + 1,Len(cDir))
	cPathImp	:= SubStr(cDir,1,RAT("\",cDir))

	IF !Empty(cDir)
		nHandle	 := FT_FUSE(cDir)
		Processa( {|lEnd| ImpCadGerais() } , "Lendo Arquivo...")
		FClose(nHandle)
	EndIF

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ImpCadGerais 		�  Eduardo Patriani     � Data � 23/03/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Importa dados.                                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ImpCadGerais()


	FT_FGOTOP()
	ProcRegua(FT_FLASTREC())

	While ! FT_FEOF()
		conout("Inicio processando job")
		//����������������������������������������������������������������Ŀ
		//� Leitura do arquivo texto.                                      �
		//������������������������������������������������������������������
		cDados := FT_FREADLN()
		aDados := Separa(cDados,';',.T.)
		//adados[3]:= strtran(adados[3],".","") // RETIRA PONTO DA CASA DE MILHARES
		//adados[3]:= strtran(adados[3],",",".") // SUBSTITUI VIRGULA DE DECIMAL POR PONTO.
		//aDados[3]:=iif(alltrim(adados[3])="T","1","2")
		//aDados[3]:=FwNoAccent(aDados[3]) // retira acentos


		U_IMPNCM(adados)


		FT_FSKIP(1)

	EndDo



	IF Len(aDados) == 0
		MsgAlert("N�o existe dados para processar.")
	EndIF

	conout("Fim processando job")

Return(.T.)

/// ATUALIZA��O DE PRE�O SB1 E SB0
User Function IMPNCM(adados)
local codalter := ALLTRIM(aDados[1])
//local codProt :=""

//---------------------------------------------------------
// Atualiza os valores da SYD
//---------------------------------------------------------
	DbSelectArea("SYD")
	dbSetOrder(1)
	if !dbseek(xFilial("SYD")+PadR(codalter,Len(SYD->YD_TEC)))
		RecLock("SYD",.T.)
		SYD->YD_FILIAL := xFilial("SYD")
		SYD->YD_TEC := codalter
		SYD->YD_DESC_P := ALLTRIM(aDados[2])
		SYD->YD_UNID := 'UN'
		msUnlock()
	EndIF
	dbCloseArea()

Return(.T.)
