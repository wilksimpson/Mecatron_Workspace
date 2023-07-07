#Include "Protheus.ch"
#include "TopConn.ch"
#INCLUDE "COLORS.CH"
#include "rwmake.ch"
#include "tbiconn.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "PRTOPDEF.CH"

//iMPORTA OU ATUALIZA PREÇO NO CADASTRO DE PRODUTOS E SB0.

User Function VIMPPRC()


	Processa( {|lEnd| ImpCad() 		} , "Por favor aguarde, importando tabela de preços ...")

RETURN

Static Function ImpCad()
	Local cArquivo  	:= ""
	Local cTipoArq 		:= "Todos os Arquivos (*.*)     | *.* | Arquivos Texto (*.TXT)     | *.TXT | Arquivos Separados por vírgula (*.CSV)     | *.CSV |"
	Local cCadastro	  	:= OemToAnsi("Importação de preços")
	Local nHandle   	:= 0
	Local nOpca			:= 0
	Local aButtons		:= {}
	Local aSays			:= {}

	Aadd(aSays,OemToAnsi( "Esta rotina realiza a importação ou atualização de preços" ) )
	Aadd(aButtons, { 1,.T.,{|| nOpca := 1, FechaBatch()}} )
	Aadd(aButtons, { 2,.T.,{|| nOpca := 0, FechaBatch()}} )

	FormBatch( cCadastro , aSays , aButtons )

	IF nOpca == 0
		Return(.T.)
	EndIF

	cDir		:= cGetFile(cTipoArq,"Selecione o arquivo que será importado",0,,.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
	cArquivo	:= SubStr(cDir,RAT("\",cDir) + 1,Len(cDir))
	cPathImp	:= SubStr(cDir,1,RAT("\",cDir))

	IF !Empty(cDir)
		nHandle	 := FT_FUSE(cDir)
		Processa( {|lEnd| ImpCadGerais() } , "Lendo Arquivo...")
		FClose(nHandle)
	EndIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImpCadGerais 		³  Eduardo Patriani     ³ Data ³ 23/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importa dados.                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpCadGerais()


	FT_FGOTOP()
	ProcRegua(FT_FLASTREC())

	While ! FT_FEOF()
		conout("Inicio processando job")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Leitura do arquivo texto.                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cDados := FT_FREADLN()
		aDados := Separa(cDados,';',.T.)
		adados[3]:= strtran(adados[3],".","") // RETIRA PONTO DA CASA DE MILHARES
		adados[3]:= strtran(adados[3],",",".") // SUBSTITUI VIRGULA DE DECIMAL POR PONTO.
		//aDados[3]:=iif(alltrim(adados[3])="T","1","2")
		//aDados[3]:=FwNoAccent(aDados[3]) // retira acentos


		U_IMPSB0(adados)


		FT_FSKIP(1)

	EndDo



	IF Len(aDados) == 0
		MsgAlert("Não existe dados para processar.")
	EndIF

	conout("Fim processando job")

Return(.T.)

/// ATUALIZAÇÃO DE PREÇO SB1 E SB0
User Function IMPSB0(adados)
local codalter := ALLTRIM(aDados[2])
local codProt :=""

//---------------------------------------------------------
// Atualiza os valores da SB1
//---------------------------------------------------------
	DbSelectArea("SB1")
	dbSetOrder(15)
	if dbseek(xFilial("SB1")+PadR(codalter,Len(SB1->B1_CODALTE)))
		codProt := SB1->B1_COD
		RecLock("SB1",.F.)
		SB1->B1_DESC := ALLTRIM(aDados[1])
		SB1->B1_PRV1 := VAL(aDados[3])
		msUnlock()
	EndIF
	dbCloseArea()

//	-------------------------------------------------------
// Inclui ou atualiza os valores da SB0
//---------------------------------------------------------
	IF !EMPTY(codProt)
	DbSelectArea("SB0")
	dbSetOrder(1)
	if dbseek(xFilial("SB0")+codProt)
		RecLock("SB0",.F.)
		SB0->B0_PRV1 := VAL(aDados[3])
		msUnlock()
	else
		RecLock("SB0",.T.)
		SB0->B0_FILIAL := xFilial("SB0")
		SB0->B0_COD := codProt
		SB0->B0_PRV1 := VAL(aDados[3])
		SB0->B0_SERVFIN := '2'
		SB0->B0_ECFLAG  := '2'
		msUnlock()
	EndIF
	dbCloseArea()
ENDIF





Return(.T.)
