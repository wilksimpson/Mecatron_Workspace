#Include "Protheus.ch"
#include "TopConn.ch"
#INCLUDE "COLORS.CH"
#include "rwmake.ch"
#include "tbiconn.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "PRTOPDEF.CH"

//iMPORTA SE2.

User Function VIMPSE2()


	Processa( {|lEnd| ImpCad() 		} , "Por favor aguarde, importando Contas a Pagar ...")

RETURN

Static Function ImpCad()
	Local cArquivo  	:= ""
	Local cTipoArq 		:= "Todos os Arquivos (*.*)     | *.* | Arquivos Texto (*.TXT)     | *.TXT | Arquivos Separados por vírgula (*.CSV)     | *.CSV |"
	Local cCadastro	  	:= OemToAnsi("Importação de Contas a Pagar")
	Local nHandle   	:= 0
	Local nOpca			:= 0
	Local aButtons		:= {}
	Local aSays			:= {}

	Aadd(aSays,OemToAnsi( "Esta rotina realiza a importação DE Contas a Pagar" ) )
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
		adados[10]:= strtran(adados[10],".","") // RETIRA PONTO DA CASA DE MILHARES
		adados[10]:= strtran(adados[10],"/","") // SUBSTITUI VIRGULA DE DECIMAL POR PONTO.
		adados[10]:= strtran(adados[10],"-","") // SUBSTITUI VIRGULA DE DECIMAL POR PONTO.
		adados[8]:=  strtran(adados[8],",",".") // altera virgula por ponto.


		U_IMPSE2(adados)


		FT_FSKIP(1)

	EndDo



	IF Len(aDados) == 0
		MsgAlert("Não existe dados para processar.")
	EndIF

	conout("Fim processando job")

Return(.T.)

/// GRAVA IMPORTAÇÃO DE TÍTULOS A PAGAR
User Function IMPSE2(adados)
	local codalter := ''
	local LJalter  := ''
	LOCAL aArray := {}
	PRIVATE lMsErroAuto := .F.

	DbSelectArea('SA2')
	DbSetOrder(3)
	IF DBSEEK(XFILIAL("SA2")+PadR(aDados[10],Len(SA2->A2_CGC)))
		codalter := SA2->A2_COD
		LJalter := SA2->A2_LOJA
	ENDIF

	IF !EMPTY(codalter)
		aArray := { { "E2_PREFIXO"  , "IMP"             		, NIL },;
			{ "E2_NUM"      , RIGHT(alltrim(aDados[5]),9)		, NIL },;
			{ "E2_PARCELA"  , STRZERO(VAL(aDados[6]),2)			, NIL },;
			{ "E2_TIPO"     , aDados[11]        , NIL },;
			{ "E2_NATUREZ"  , aDados[9]         , NIL },;
			{ "E2_FORNECE"  , codalter          , NIL },;
			{ "E2_LOJA"     , LJalter           , NIL },;
			{ "E2_EMISSAO"  , CtoD(aDados[4])	, NIL },;
			{ "E2_VENCTO"   , CtoD(aDados[7])	, NIL },;
			{ "E2_VENCREA"  , CtoD(aDados[7])   , NIL },;
			{ "E2_VALOR"    , val(adados[8])    , NIL } }

		MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão


		If lMsErroAuto
			MostraErro()
		Endif

	ENDIF

Return(.T.)
