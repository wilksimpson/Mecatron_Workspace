#Include "Protheus.ch"
#include "TopConn.ch"
#INCLUDE "COLORS.CH"
#include "rwmake.ch"
#include "tbiconn.ch"
#INCLUDE "FWMVCDEF.CH"

//Importa plano de contas e plano referencial
// Autor: Wilk Lima
// 15/12/2021

User Function VIMPctb()


	Processa( {|lEnd| ImpCad() 		} , "Por favor aguarde, importando plano de contas ...")

RETURN

Static Function ImpCad()
	Local cArquivo  	:= ""
	Local cTipoArq 		:= "Todos os Arquivos (*.*)     | *.* | Arquivos Texto (*.TXT)     | *.TXT | Arquivos Separados por vírgula (*.CSV)     | *.CSV |"
	Local cCadastro	  	:= OemToAnsi("Importação dos cadastros contábeis")
	Local nHandle   	:= 0
	Local nOpca			:= 0
	Local aButtons		:= {}
	Local aSays			:= {}

	Aadd(aSays,OemToAnsi( "Esta rotina realiza a importação contas contábeis" ) )
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

	Local aDados := {}
	Private aCab        := {}
	Private aItens      := {}


	FT_FGOTOP()
	ProcRegua(FT_FLASTREC())

	While ! FT_FEOF()
		conout("Inicio processando job")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Leitura do arquivo texto.                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cDados := FT_FREADLN()
		aDados := Separa(cDados,';',.T.)
		//adados[9]:= strtran(adados[9],",",".")
		//aDados[3]:=iif(alltrim(adados[3])="T","1","2")
		aDados[3]:=FwNoAccent(aDados[3]) // retira acentos


		U_IMPCT1(adados)


		FT_FSKIP(1)

	EndDo



	IF Len(aDados) == 0
		MsgAlert("Não existe dados para processar.")
	EndIF

	conout("Fim processando job")

Return(.T.)

/// ROTINA AUTOMATICA - INCLUSAO DE CONTA CONTABIL CTB
User Function IMPCT1(adados)
	local _NATCTA := ''
	local _NTSPED := ''
	local _INDNAT := ''
//	-------------------------------------------------------
// Preencho os valores da CT1
//---------------------------------------------------------

// ajusta campos de naturezas sped
	IF SUBSTRING(aDados[1],1,1)=='1'
		_NATCTA := "01"
		_NTSPED := "01"
		_INDNAT := "1"
	elseif SUBSTRING(aDados[1],1,1)=='2'
		_NATCTA := "02"
		_NTSPED := "02"
		_INDNAT := "2"
	elseif SUBSTRING(aDados[1],1,1)=='3'
		_NATCTA :="03"
		_NTSPED :="03"
		_INDNAT :="4"
	elseif SUBSTRING(aDados[1],1,1)=='4'
		_NATCTA :="04"
		_NTSPED :="04"
		_INDNAT :="5"
	elseif SUBSTRING(aDados[1],1,1)=='5'
		_NATCTA :="05"
		_NTSPED :="05"
		_INDNAT :="3"
	else
		_NATCTA :="09"
		_NTSPED :="09"
		_INDNAT :="9"
	EndIF

	DbSelectArea("CT1")
	dbSetOrder(1)
	if dbseek(xFilial("CT1")+PadR(aDados[1],Len(CT1->CT1_CONTA)))
		RecLock("CT1",.F.)
		CT1->CT1_DESC01 := aDados[3]
		msUnlock()
	else
		RecLock("CT1",.T.)
		CT1->CT1_FILIAL := xFilial("CT1")
		CT1->CT1_CONTA 	:= aDados[1]
		CT1->CT1_DESC01 := aDados[3]
		CT1->CT1_CLASSE := aDados[2]
		CT1->CT1_NORMAL := aDados[10]
		CT1->CT1_DTEXIS := CTOD(aDados[7])
		CT1->CT1_NATCTA := _NATCTA
		CT1->CT1_NTSPED := _NTSPED
		CT1->CT1_INDNAT := _INDNAT
		CT1->CT1_INDNAT := _INDNAT
		CT1->CT1_RES	:= aDados[5]
		CT1->CT1_CTASUP	:= aDados[12]
		CT1->CT1_CODANT	:= aDados[11]
		CT1->CT1_BLOQ	:= '2'
		CT1->CT1_DC		:= '0'
		CT1->CT1_NCUSTO	:= 0
		CT1->CT1_CVD02	:= '1'
		CT1->CT1_CVD03	:= '1'
		CT1->CT1_CVD04	:= '1'
		CT1->CT1_CVD05	:= '1'
		CT1->CT1_CVC02	:= '1'
		CT1->CT1_CVC03	:= '1'
		CT1->CT1_CVC04	:= '1'
		CT1->CT1_CVC05	:= '1'
		CT1->CT1_ACITEM	:= '1'
		CT1->CT1_ACCUST	:= '1'
		CT1->CT1_ACCLVL	:= '1'
		CT1->CT1_AGLSLD	:= '1'
		CT1->CT1_CCOBRG	:= '1'
		CT1->CT1_ITOBRG	:= '1'
		CT1->CT1_CLOBRG	:= '1'
		CT1->CT1_LALUR	:= '0'
		CT1->CT1_LALHIR	:= '2'
		CT1->CT1_ACATIV	:= '2'
		CT1->CT1_ATOBRG	:= '2'
		CT1->CT1_ACET05	:= '2'
		CT1->CT1_05OBRG	:= '2'
		CT1->CT1_INTP	:= '1'
		CT1->CT1_PVARC	:= '1'
		msUnlock()
	EndIF
	dbCloseArea()



//---------------------------------------------------------
// Preencho os valores da CVD
//---------------------------------------------------------
	IF !EMPTY(aDados[6])
		DbSelectArea("CVD")
		dbSetOrder(1) //CVD_FILIAL+CVD_CONTA+CVD_ENTREF+CVD_CTAREF+CVD_CUSTO+CVD_VERSAO
		if dbseek(xFilial("CVD")+PadR(aDados[1],Len(CVD->CVD_CONTA))+"10"+PadR(aDados[6],Len(CVD->CVD_CTAREF)))
			RecLock("CVD",.F.)
			CVD->CVD_CTAREF := aDados[6]
			msUnlock()
		else
			RecLock("CVD",.T.)
				CVD->CVD_FILIAL := xFilial('CVD')
				CVD->CVD_ENTREF := '10'
				CVD->CVD_CODPLA := '2021'
				CVD->CVD_CONTA 	:= aDados[1]
				CVD->CVD_CTAREF := aDados[6]
				CVD->CVD_TPUTIL := 'A'
				CVD->CVD_CLASSE := aDados[2]
				CVD->CVD_VERSAO := '0001'
				CVD->CVD_NATCTA := _NATCTA
				CVD->CVD_CTASUP := gctasup(aDados[6])
				msUnlock()
			EndIF
			dbCloseArea()
		EndIf


		Return


Static Function gctasup(ctasup)
	local _qtd := 0
	local  n   := 0

	_qtd := len(ctasup)

	if _qtd==1
		ctasup := ''
	EndIf

	if _qtd==4
		ctasup := SubStr(ctasup,1,1)
	EndIf

	if _qtd>4
		n :=_qtd-3
		ctasup := SubStr(ctasup,1,n)
	EndIf

Return ctasup
