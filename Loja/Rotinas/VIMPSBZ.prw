#Include "Protheus.ch"
#include "TopConn.ch"
#INCLUDE "COLORS.CH"
#include "rwmake.ch"
#include "tbiconn.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "PRTOPDEF.CH"

//iMPORTA OU ATUALIZA ENDERE�O DOS PRODUTOS.

User Function VIMPSBZ()


	Processa( {|lEnd| ImpCad() 		} , "Por favor aguarde, importando EDERE�O DOS PRODUTOS ...")

RETURN

Static Function ImpCad()
	Local cArquivo  	:= ""
	Local cTipoArq 		:= "Todos os Arquivos (*.*)     | *.* | Arquivos Texto (*.TXT)     | *.TXT | Arquivos Separados por v�rgula (*.CSV)     | *.CSV |"
	Local cCadastro	  	:= OemToAnsi("Importa��o de pre�os")
	Local nHandle   	:= 0
	Local nOpca			:= 0
	Local aButtons		:= {}
	Local aSays			:= {}

	Aadd(aSays,OemToAnsi( "Esta rotina realiza a importa��o ou atualiza��o de pre�os" ) )
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
		adados[3]:= strtran(adados[3],".","") // RETIRA PONTO DA CASA DE MILHARES
		adados[3]:= strtran(adados[3],",",".") // SUBSTITUI VIRGULA DE DECIMAL POR PONTO.
		//aDados[3]:=iif(alltrim(adados[3])="T","1","2")
		//aDados[3]:=FwNoAccent(aDados[3]) // retira acentos


		U_IMPSBZ(adados)


		FT_FSKIP(1)

	EndDo



	IF Len(aDados) == 0
		MsgAlert("N�o existe dados para processar.")
	EndIF

	conout("Fim processando job")

Return(.T.)

/// ATUALIZA��O DE PRE�O SBZ
User Function IMPSBZ(adados)
	local codalter := ALLTRIM(aDados[1])
	local _cCodFil := aDados[2]
	local codProt :=""

	if _cCodFil =='1'
		_cCodFil := '0101'
	elseif _cCodFil =='3'
		_cCodFil := '0103'
	else
		_cCodFil := '0104'
	ENDIF
//---------------------------------------------------------
// Busca c�digo interno
//---------------------------------------------------------
	DbSelectArea("SB1")
	dbSetOrder(15)
	if dbseek(xFilial("SB1")+PadR(codalter,Len(SB1->B1_CODALTE)))
		codProt := SB1->B1_COD
	EndIF
	dbCloseArea()

	//---------------------------------------------------------
	// Atualiza os valores da SBZ
	//---------------------------------------------------------
	if !empty(codProt)
		DbSelectArea("SBZ")
		dbSetOrder(1) // FILIAL + CODIGO
		if dbseek(_cCodFil+codProt)
			RecLock("SBZ",.F.)
			SBZ->BZ_DESCLOC := ALLTRIM(aDados[3])
			msUnlock()
		else
			RecLock("SBZ",.T.)
			SBZ->BZ_FILIAL := _cCodFil
			SBZ->BZ_COD	   := codProt
			SBZ->BZ_LOCPAD := "01"
			SBZ->BZ_MCUSTD := '1'
			SBZ->BZ_TIPOCQ := 'M'
			SBZ->BZ_DTINCLU := dDataBase
			SBZ->BZ_CSLL 	:= '2'
			SBZ->BZ_LOCALIZ	:= 'N'
			SBZ->BZ_CTRWMS	:= '2'
			SBZ->BZ_DESCLOC := ALLTRIM(aDados[3])
			msUnlock()
		EndIF
		dbCloseArea()
	ENDIF


Return(.T.)
