#Include "Protheus.ch"
#include "TopConn.ch"
#INCLUDE "COLORS.CH"
#include "rwmake.ch"
#include "tbiconn.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "PRTOPDEF.CH"

//iMPORTA OU ATUALIZA PREÇO NO CADASTRO DE PRODUTOS E SB0.

User Function VIMPSLD()

	Local aItems:= {}
	Local cCombo1 := ''

	aAdd(aItems , "0000=[Selecione a Empresa]")
	aAdd(aItems , "0101=[Matriz]")
	aAdd(aItems , "0103=[Parauapebas]")
	aAdd(aItems , "0104=[Marituba]")

	/*/DEFINE DIALOG _oDlgS TITLE "Selecione Empresa" FROM 178,181 TO 310,468 PIXEL 
	@ 002, 001 MSCOMBOBOX oEdit1 VAR cOpcao ITEMS aItems SIZE 140, 013 OF _oDlgS PIXEL COLORS 0, 16777215
	ACTIVATE MSDIALOG _oDlgS CENTERED
/*/
	DEFINE DIALOG oDlg TITLE "Importa Saldo Inicial" FROM 180,180 TO 550,700 PIXEL
	// Usando New
	cCombo1:= aItems[1]
	oCombo1 := TComboBox():New(02,02,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},;
		aItems,100,20,oDlg,,{||Processa( {|lEnd| ImpCad(cCombo1) 		} , "Por favor aguarde, importando tabela de preços ...")};
		,,,,.T.,,,,,,,,,'cCombo1')
	ACTIVATE DIALOG oDlg CENTERED



RETURN

Static Function ImpCad(cCombo1)
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
		Processa( {|lEnd| ImpCadGerais(cCombo1) } , "Lendo Arquivo...")
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

Static Function ImpCadGerais(cCombo1)


	FT_FGOTOP()
	ProcRegua(FT_FLASTREC())

	While ! FT_FEOF()
		conout("Inicio processando job")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Leitura do arquivo texto.                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cDados := FT_FREADLN()
		aDados := Separa(cDados,';',.T.)
		adados[8]:= strtran(adados[8],",",".")
		adados[9]:= strtran(adados[9],",",".")
		//aDados[3]:=iif(alltrim(adados[3])="T","1","2")
		//aDados[3]:=FwNoAccent(aDados[3]) // retira acentos


		U_MyMata220(adados,cCombo1)


		FT_FSKIP(1)

	EndDo



	IF Len(aDados) == 0
		MsgAlert("Não existe dados para processar.")
	EndIF

	conout("Fim processando job")

Return(.T.)




User Function MyMata220(adados,cCombo1)
	Local PARAMIXB1 := {}
	Local PARAMIXB2 := 3
	Local cProd	:= aDados[2]
	Local cProd2	:= ""
	Local cArmazem	:= "01"
	Local nQtdIni 	:= VAL(aDados[8])
	Local nCustUnit	:= VAL(aDados[9])
	Local nCustTot	:= 0
	PRIVATE lMsErroAuto := .F.

	nCustTot := ROUND(nQtdIni*nCustUnit,2)
		// localiza código ou referencia
		cProd2 := AchaSB1(cProd)

	Begin Transaction

		IF !EMPTY(cProd2)
			aadd(PARAMIXB1,{"B9_FILIAL",cCombo1,})
			aadd(PARAMIXB1,{"B9_COD",cProd2,})
			aadd(PARAMIXB1,{"B9_LOCAL",cArmazem,})
			aadd(PARAMIXB1,{"B9_QINI",nQtdIni,})
			aadd(PARAMIXB1,{"B9_VINI1",nCustTot,})
			aadd(PARAMIXB1,{"B9_CM1",nCustUnit,})
			

			MSExecAuto({|x,y| mata220(x,y)},PARAMIXB1,PARAMIXB2)

			/*/
			If !lMsErroAuto
				ConOut("Incluido com sucesso! "+cProd)
			Else
				ConOut("Erro na inclusao!")
				MostraErro()
			EndIf
			/*/
		ENDIF


	End Transaction
	//RESET ENVIRONMENT

Return Nil


Static Function AchaSB1(cProd)
local _cod:= ""
LOCAL aAreaAnt := GETAREA()


		// verifica se o código é a referencia.
		DbSelectArea("SB1")
		dbSetOrder(14)
		if dbseek(xFilial("SB1")+PadR(cProd,Len(SB1->B1_REFER)))
			_cod := SB1->B1_COD
		ENDIF

		// verifica se o código é o interno.
		DbSelectArea("SB1")
		dbSetOrder(1)
		if dbseek(xFilial("SB1")+PadR(cProd,Len(SB1->B1_COD)))
			_cod := SB1->B1_COD
		ENDIF


RESTAREA(aAreaAnt)   // Retorna o ambiente anterior
Return _cod
