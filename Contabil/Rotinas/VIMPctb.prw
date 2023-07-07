#Include "Protheus.ch"
#include "TopConn.ch"
#INCLUDE "COLORS.CH"
#include "rwmake.ch"
#include "tbiconn.ch"
#INCLUDE "FWMVCDEF.CH"

Static __oModelAut := NIL //variavel oModel para substituir msexecauto em MVC

User Function VIMPctb()


	Processa( {|lEnd| ImpCad() 		} , "Por favor aguarde, importando lançamentos contábeis ...")

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


		U_ModelCT1(adados)


		FT_FSKIP(1)

	EndDo



	IF Len(aDados) == 0
		MsgAlert("Não existe dados para processar.")
	EndIF

	conout("Fim processando job")

Return(.T.)

/// ROTINA AUTOMATICA - INCLUSAO DE CONTA CONTABIL CTB
User Function ModelCT1(adados)
	Local nOpcAuto :=0
	Local nX
	Local oCT1
	Local aLog
	Local cLog :=""
	Local lRet := .T.

	If __oModelAut == Nil //somente uma unica vez carrega o modelo CTBA020-Plano de Contas CT1
		__oModelAut := FWLoadModel('CTBA020')
	EndIf


	nOpcAuto:=3


	__oModelAut:SetOperation(nOpcAuto) // 3 - Inclusão | 4 - Alteração | 5 - Exclusão
	__oModelAut:Activate() //ativa modelo

//---------------------------------------------------------
// Preencho os valores da CT1
//---------------------------------------------------------
	oCT1 := __oModelAut:GetModel('CT1MASTER') //Objeto similar enchoice CT1
	oCT1:SETVALUE('CT1_CONTA',aDados[1])
	oCT1:SETVALUE('CT1_DESC01',aDados[3])
	oCT1:SETVALUE('CT1_CLASSE',aDados[2])
	oCT1:SETVALUE('CT1_NORMAL' ,aDados[10])
	oCT1:SETVALUE('CT1_DTEXIS' ,CTOD(aDados[7]))

	IF SUBSTRING(aDados[1],1,1)=='1'
		oCT1:SETVALUE('CT1_NATCTA' ,"01")
		oCT1:SETVALUE('CT1_NTSPED' ,"01")
		oCT1:SETVALUE('CT1_INDNAT' ,"1")
	elseif SUBSTRING(aDados[1],1,1)=='2'
		oCT1:SETVALUE('CT1_NATCTA' ,"02")
		oCT1:SETVALUE('CT1_NTSPED' ,"02")
		oCT1:SETVALUE('CT1_INDNAT' ,"2")
	elseif SUBSTRING(aDados[1],1,1)=='3'
		oCT1:SETVALUE('CT1_NATCTA' ,"03")
		oCT1:SETVALUE('CT1_NTSPED' ,"03")
		oCT1:SETVALUE('CT1_INDNAT' ,"4")
	elseif SUBSTRING(aDados[1],1,1)=='4'
		oCT1:SETVALUE('CT1_NATCTA' ,"04")
		oCT1:SETVALUE('CT1_NTSPED' ,"04")
		oCT1:SETVALUE('CT1_INDNAT' ,"5")
	elseif SUBSTRING(aDados[1],1,1)=='5'
		oCT1:SETVALUE('CT1_NATCTA' ,"05")
		oCT1:SETVALUE('CT1_NTSPED' ,"05")
		oCT1:SETVALUE('CT1_INDNAT' ,"3")
	else
		oCT1:SETVALUE('CT1_NATCTA' ,"09")
		oCT1:SETVALUE('CT1_NTSPED' ,"09")
		oCT1:SETVALUE('CT1_INDNAT' ,"9")
	EndIF


//---------------------------------------------------------
// Preencho os valores da CVD
//---------------------------------------------------------

	oCVD := __oModelAut:GetModel('CVDDETAIL') //Objeto similar getdados CVD
	oCVD:SETVALUE('CVD_FILIAL' ,CVD->(xFilial('CVD')))
	oCVD:SETVALUE('CVD_ENTREF','10')
	oCVD:SETVALUE('CVD_CODPLA',PadR('2021',Len(CVD->CVD_CODPLA)))
	oCVD:SETVALUE('CVD_CTAREF',PadR(aDados[6], Len(CVD->CVD_CTAREF)))
	oCVD:SETVALUE('CVD_TPUTIL','A')
	oCVD:SETVALUE('CVD_CLASSE',aDados[2])
	oCVD:SETVALUE('CVD_VERSAO',PadR('0001',Len(CVD->CVD_VERSAO)))
	oCVD:SETVALUE('CVD_CUSTO' ,"")

//---------------------------------------------------------
// Preencho os valores da CTS
//---------------------------------------------------------


	oCTS := __oModelAut:GetModel('CTSDETAIL') //Objeto similar getdados CTS
	oCTS:SETVALUE('CTS_FILIAL' ,CTS->(xFilial('CTS')))
	oCTS:SETVALUE('CTS_CODPLA' ,'001')
	oCTS:SETVALUE('CTS_CONTAG' ,"1.01.01.01.01       ")


	If __oModelAut:VldData() //validacao dos dados pelo modelo

		__oModelAut:CommitData() //gravacao dos dados

	else

		aLog := __oModelAut:GetErrorMessage() //Recupera o erro do model quando nao passou no VldData

//laco para gravar em string cLog conteudo do array aLog
		For nX := 1 to Len(aLog)
			If !Empty(aLog[nX])
				cLog += Alltrim(aLog[nX]) + CRLF
			EndIf
		Next nX

		lMsErroAuto := .T. //seta variavel private como erro
		AutoGRLog(cLog) //grava log para exibir com funcao mostraerro
//		mostraerro()
		lRet := .F. //retorna false

	EndIf

	__oModelAut:DeActivate() //desativa modelo

Return( lRet )

Return


