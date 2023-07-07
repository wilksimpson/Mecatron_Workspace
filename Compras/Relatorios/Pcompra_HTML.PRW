#include "topconn.ch"
#include "rwmake.ch"
#Include 'Protheus.ch'
#INCLUDE "TOTVS.CH"
#define EXCLUSIVO .F.

User Function PC_HTML()
	Local aArea:= GetArea()

	SETPRVT("cArqTMP,LCria,aCampos,_xFil,cNum,Ent_End,Ent_Bai,Ent_CEP,Ent_Cid,Ent_Est")
/*
/////////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------------------//
// Programa  | PC_HTML  |Autor  | Jose Macedo        | Data |  30/01/2014  //
//-------------------------------------------------------------------------//
// Descrição | Pedido de Compra em HTML                                    //
//-------------------------------------------------------------------------//
// Uso       | Compras                                                     //
//-------------------------------------------------------------------------//
//-------------------------------------------------------------------------//
/////////////////////////////////////////////////////////////////////////////
*/  

// Mostra parametros com ENDERECO PARA ENTREGA


//lPerg := Pergunte("ENDENT",.T.)
//If !lPerg
//    Return
//Endif    


	If  !FUNNAME() $ "CNTA121#MATA121#COM001"
		dbSelectArea("SC7")
		aRotina := { { "Procurar   ",'AxPesqui', 0, 1 } ,;
			{ "Imprimir PC",'U_fCriaTMP()', 0, 2 } }
		cCadastro := "IMPRESSAO PEDIDOS DE COMPRAS"
		mBrowse(01,01,30,70,"SC7",,"C7_CONAPRO<>'L'")
		dbSelectArea("SC7")
		Set Filter To
	Elseif FUNNAME() $"CNTA121"
		dbSelectArea("CND")
		dbGoto(aArea[3])
		dbSelectArea("CNE")
		dbSetOrder(5) //CNE_FILIAL+CNE_CONTRA+CNE_REVISA+CNE_NUMMED
		DBSEEK(CND->CND_FILIAL+CND->CND_CONTRA+CND->CND_REVISA+CND->CND_NUMMED)
		_xFil := CND->CND_FILIAL
		cNum := CNE->CNE_PEDIDO
		IF EMPTY(cNum)
			msgStop("Medição não encerrada ou não há uma medição de compras, favor selecionar uma medição válida.")
			return
		ELSE
			U_fCriaTMP()
		ENDIF
	ELSE
		_xFil := SC7->C7_FILIAL
		cNum := SC7->C7_NUM
		U_fCriaTMP()
	EndIf
	RestArea(aArea)
Return(Nil)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CRIA ARQUIVO DE TRABALHO
User Function fCriaTMP()

	cEmpAtual:= SM0->(M0_CODIGO+M0_CODFIL)

	If SM0->M0_CODIGO = '99'
		SM0->(dbSeek("01"))
	EndIf

	cArqTMP  := CriaTrab(Nil,.f.) // "PCOMPRA"
	aCampos  := {}
	AADD(aCAMPOS,{"NUM"		,"C",006,0})
	AADD(aCAMPOS,{"IT"		,"C",003,0})
	AADD(aCAMPOS,{"QUANT"	,"N",018,4})
	AADD(aCAMPOS,{"UM"		,"C",002,0})
	AADD(aCAMPOS,{"CODPROD"	,"C",009,0})
	AADD(aCAMPOS,{"CODFOR"	,"C",009,0})
	AADD(aCAMPOS,{"DESPROD"	,"C",200,0})
	AADD(aCAMPOS,{"CONTA"	,"C",006,0})
	AADD(aCAMPOS,{"SC"		,"C",006,0})
	AADD(aCAMPOS,{"UNIT"	,"N",014,2})
	AADD(aCAMPOS,{"IPI"		,"N",005,2})
	AADD(aCAMPOS,{"VALOR"	,"N",014,2})
	AADD(aCAMPOS,{"EMISSAO" ,"D",008,0})
	AADD(aCAMPOS,{"VALDESC" ,"N",014,2})
	AADD(aCAMPOS,{"VALIPI"	,"N",014,2})
	AADD(aCAMPOS,{"VALFRET" ,"N",014,2})
	AADD(aCAMPOS,{"EMP_CAB1","C",090,0})
	AADD(aCAMPOS,{"EMP_CAB2","C",090,0})
	AADD(aCAMPOS,{"EMP_CAB3","C",090,0})
	AADD(aCAMPOS,{"EMP_CAB4","C",090,0})
	AADD(aCAMPOS,{"CODFORN" ,"C",006,0})
	AADD(aCAMPOS,{"NOMFORN" ,"C",050,0})
	AADD(aCAMPOS,{"CONTATO"	,"C",020,0})
	AADD(aCAMPOS,{"FONE"	,"C",014,0})
	AADD(aCAMPOS,{"ENDERECO","C",050,0})
	AADD(aCAMPOS,{"BAIRRO"  ,"C",025,0})
	AADD(aCAMPOS,{"CIDADE"  ,"C",025,0})
	AADD(aCAMPOS,{"CEP"		,"C",009,0})
	AADD(aCAMPOS,{"ESTADO"  ,"C",002,0})
	AADD(aCAMPOS,{"CNPJ"	,"C",020,0})
	AADD(aCAMPOS,{"IEST"	,"C",020,0})
	AADD(aCAMPOS,{"DESCONTO","N",014,2})
	AADD(aCAMPOS,{"TPFRETE" ,"C",090,0})
	AADD(aCAMPOS,{"CONDPAG" ,"C",040,0})
	AADD(aCAMPOS,{"PRAZOENT","C",025,0})
	AADD(aCAMPOS,{"ENTREGA1","C",050,0})
	AADD(aCAMPOS,{"ENTREGA2","C",050,0})
	AADD(aCAMPOS,{"COBRANCA","C",090,0})
	AADD(aCAMPOS,{"SOLICITA","C",025,0})
	AADD(aCAMPOS,{"TES"		,"C",003,0})
	AADD(aCAMPOS,{"RAMAL"	,"C",004,0})
	AADD(aCAMPOS,{"CODCC"	,"C",009,0})
	AADD(aCAMPOS,{"CC"		,"C",036,0})
	AADD(aCAMPOS,{"COMPRA"	,"C",025,0})
	AADD(aCAMPOS,{"OBS"		,"C",600,0})
	AADD(aCAMPOS,{"EMPRESA"	,"C",002,0})
	AADD(aCAMPOS,{"FILIAL"	,"C",002,0})
	AADD(aCAMPOS,{"PC"		,"C",001,0})
	AADD(aCAMPOS,{"APROV1"  ,"C",030,0})
	AADD(aCAMPOS,{"APROV2"  ,"C",030,0})
	AADD(aCAMPOS,{"DATALI"  ,"C",010,0})
	AADD(aCAMPOS,{"HORALI"  ,"C",010,0})
// local

	If Select("TMP") > 0
		TMP->(dbCloseArea())
	EndIf
	DbCreate(cArqTMP,aCAMPOS)
	dbUseArea(.T.,, cArqTMP, "TMP", EXCLUSIVO )
	dbSelectArea("TMP")

	Processa( {|| ImprimePC() },"Selecionando Registros...",,.T. )

Return(Nil)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ImprimePC()



	dbSelectArea("SC7")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(_xFil+cNum,.T.)
	cArqAtual := Alias()
	nOrdAtual := dbSetOrder()
	nRegAtual := Recno()
	cSolic    := ""
	lOk       := .f.
	nTotDesc  := 0
	cAprov1   := cAprov2 := ""
	cDATALI   :=SPACE(10)
	cHORALI   :=SPACE(10)
	cItem	  := C7_ITEM
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
	dbSelectArea("SE4")
	dbSetOrder(1)
	dbSeek(xFilial("SE4")+SC7->C7_COND)
	dbSelectArea("SC1")
	dbSetOrder(1)
	dbSelectArea("SY1")
	dbSetOrder(3)
	dbSeek(xFilial("SY1")+SC7->C7_USER)



	MV_PAR01:=Ent_End := SM0->M0_ENDCOB
	MV_PAR02:=Ent_Bai := SM0->M0_BAIRCOB
	MV_PAR03:=Ent_CEP := SM0->M0_CEPCOB
	MV_PAR04:=Ent_Cid := SM0->M0_CIDCOB
	MV_PAR05:=Ent_Est := SM0->M0_ESTCOB


	While !SC7->(Eof()) .And. (SC7->C7_FILIAL+SC7->C7_NUM) == (_xFil+cNum)
		lOk := .t.
		nStr:= 41
		//cDescri := POSICIONE("SB1",1,XFILIAL("SB1")+SC7->C7_PRODUTO,"B1_DESC")//Trim(C7_DESCRI)
		// Monta descrição do produto
		dbSelectArea("SC1")
		dbSeek(SC7->C7_FILIAL+SC7->C7_NUMSC+SC7->C7_ITEMSC)

		//dbSelectArea("SB1")
		//dbSetOrder(1)
		//dbSeek(xFilial("SB1")+SC7->C7_PRODUTO)

		cDATALI:=""
		cHORALI:=""
		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(SC7->C7_FILIAL+"PC"+SC7->C7_NUM)
		While !Eof() .And. SCR->(CR_FILIAL+Alltrim(SCR->CR_NUM))==SC7->(C7_FILIAL+C7_NUM) .And. SCR->CR_TIPO == "PC"
			If SCR->CR_STATUS = "02"
				cAprov1 := "Aguardando Lib."
			EndIf
			If SCR->CR_STATUS$"03/05"
				// cAprov1 := If(SCR->CR_NIVEL="01" .And. cAprov1 = "",AllTrim(UsrFullName(SCR->CR_USER)),cAprov1)
				// cAprov2 := If(SCR->CR_NIVEL="02" .And. cAprov2 = "",AllTrim(UsrFullName(SCR->CR_USER)),cAprov2)
				cAprov1 := If(SCR->CR_NIVEL=="1 " .And. empty(cAprov1),POSICIONE("SAK",1,XFILIAL("SAK")+SCR->CR_APROV,"AK_NOME"),cAprov1)
				cAprov2 := If(SCR->CR_NIVEL=="2 " .And. empty(cAprov2),POSICIONE("SAK",1,XFILIAL("SAK")+SCR->CR_APROV,"AK_NOME"),cAprov2)
				cDATALI := IF(EMPTY(cDATALI),DTOC(SCR->CR_DATALIB),cDATALI)
				cHORALI := IF(EMPTY(cHORALI),SUBSTR(TIME(),1,5),cHORALI)
//         ALERT(cAprov1)
			EndIf
			dbSelectArea("SCR")
			dbSkip()
		End

		dbSelectArea("TMP")
		RecLock("TMP",.T.)
		fDetalhe()
		fCabecalho()
		fRodape()
		MsUnLock()

		dbSelectArea("SC7")
		dbSkip()
		cSolic:=TMP->SOLICITA

	End

	nTotReg := TMP->(RecCount())

	If lOk
//   VerParametros()	
		nGoReg := 1
		Page_HTML()
	Else
		Alert("Nao foram encontrados registros para este PC !!!")
	EndIf

	dbSelectArea(cArqAtual)
	dbSetOrder(nOrdAtual)
	dbGoTo(nRegAtual)

Return(Nil)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDetalhe()
	FIELD->IT		:= StrZero(Val(SC7->C7_ITEM),3)
	FIELD->QUANT	:= SC7->C7_QUANT
	FIELD->UM		:= SC7->C7_UM
	FIELD->CODPROD	:= SC7->C7_PRODUTO
	FIELD->CODFOR	:= POSICIONE('SB1',1,XFILIAL('SA1')+SC7->C7_PRODUTO,'B1_REFER')
	FIELD->DESPROD	:= SC7->C7_DESCRI
	FIELD->CONTA	:= SC7->C7_CONTA
	FIELD->SC		:= SC7->C7_NUMSC
	FIELD->UNIT		:= SC7->C7_PRECO
	FIELD->IPI		:= SC7->C7_IPI
	FIELD->VALOR	:= SC7->C7_TOTAL
	FIELD->VALDESC	:= SC7->C7_VLDESC
	FIELD->VALIPI	:= SC7->C7_VALIPI
	FIELD->VALFRET	:= SC7->(C7_VALFRE+C7_DESPESA)

RETURN
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fCabecalho()

	FIELD->EMP_CAB1	:= Trim(SM0->M0_NOMECOM)
	FIELD->EMP_CAB2	:= Trim(SM0->M0_ENDENT)+" - "+Trim(SM0->M0_BAIRENT)+" - CEP: "+;
		Transform(SM0->M0_CEPENT,"@R 99999-999")+" - "+Rtrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT
	FIELD->EMP_CAB3	:= "Tel.: (091) 3366-5205  - Tel.2: "+Trim(SM0->M0_TEL)
	FIELD->EMP_CAB4	:= "C.N.P.J.: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")+"    Inscr. Estadual: "+Rtrim(SM0->M0_INSC)
	FIELD->NUM		:= SC7->C7_NUM
	FIELD->EMISSAO	:= SC7->C7_EMISSAO
	FIELD->CODFORN	:= SC7->C7_FORNECE
	FIELD->NOMFORN	:= SA2->A2_NOME
	FIELD->CONTATO	:= If(Empty(SC7->C7_CONTATO),SA2->A2_CONTATO,SC7->C7_CONTATO)
	FIELD->FONE		:= SA2->A2_TEL
	FIELD->ENDERECO	:= Rtrim(SA2->A2_END)+If(!Empty(SA2->A2_NR_END),", "+SA2->A2_NR_END,"")
	FIELD->BAIRRO	:= SA2->A2_BAIRRO
	FIELD->CIDADE	:= SA2->A2_MUN
	FIELD->CEP		:= Transform(SA2->A2_CEP,"@R 99999-999")
	FIELD->ESTADO	:= SA2->A2_EST
	FIELD->CNPJ		:= Transform(SA2->A2_CGC,If(Len(Rtrim(SA2->A2_CGC))=14,"@R 99.999.999/9999-99","@R 999.999.999-99"))
	FIELD->IEST		:= SA2->A2_INSCR

RETURN
//////////////////////////////////////////////////////////////////////////////////////
Static Function fRodape()
	_DESCCC:=SPACE(35)
	_TRANSP:=""
	IF !EMPTY(ALLTRIM(SC7->C7_CC))
		DBSELECTAREA("CTT")
		DBSETORDER(1)
		DBSEEK(XFILIAL("CTT")+SC7->C7_CC)
		IF !FOUND()
			_DESCCC:=ALLTRIM(SC7->C7_CC)+" - Nao cadastrado"
		ELSE
			_DESCCC:=ALLTRIM(SC7->C7_CC)+" - "+CTT->CTT_DESC01
		ENDIF
		DBSELECTAREA("TMP")
	ENDIF

	IF SC7->C7_TPFRETE="C"
		FIELD->TPFRETE := "CIF"
	else
		_TRANSP := "FOB / "+POSICIONE("SA2",1,XFILIAL("SA2")+SC7->C7_TRANSP+SC7->C7_TRANSLJ,"A2_NOME")
		FIELD->TPFRETE := ALLTRIM(_TRANSP)+IF(SC7->C7_FRETCON>0," / valor negociado: "+alltrim(Transform(SC7->C7_FRETCON,"@E 9,999.99")),"")
	ENDIF




	FIELD->CONDPAG	:= SE4->E4_DESCRI
	FIELD->PRAZOENT	:= If(SC7->C7_DATPRF > SC7->C7_EMISSAO,Strzero(SC7->C7_DATPRF-SC7->C7_EMISSAO,3)+" dia(s)  -  ","")+dtoc(SC7->C7_DATPRF)
	FIELD->ENTREGA1	:= Trim(Ent_End)+" - "+Trim(Ent_Bai)
	FIELD->ENTREGA2	:= "CEP: "+Transform(Ent_CEP,"@R 99999-999")+" - "+Rtrim(Ent_Cid)+" - "+Ent_Est

	FIELD->COBRANCA	:= Trim(SM0->M0_ENDCOB)+" - "+Trim(SM0->M0_BAIRCOB)+" - CEP: "+;
		Transform(SM0->M0_CEPCOB,"@R 99999-999")+" - "+Rtrim(SM0->M0_CIDCOB)+" - "+SM0->M0_ESTCOB
	If !Trim(SC1->C1_SOLICIT) $ Trim(cSolic)
		cSolic := cSolic+If(Trim(cSolic)<>"",", ","")+Trim(SC1->C1_SOLICITA)
	EndIf

	FIELD->SOLICITA	:= cSolic
	FIELD->RAMAL	:= "9999"
	FIELD->TES  	:= SC7->C7_TES
	FIELD->CODCC	:= SC7->C7_CC
	FIELD->CC		:= _DESCCC
	FIELD->COMPRA	:= Alltrim(UsrFullName(SC7->C7_USER))

	if !empty(SC7->C7_TRANSP)
		FIELD->OBS		:= SC7->C7_OBSM + ". Não nos responsabilizamos pelo frete, caso não seja respeitada a empresa indicada."
	else
		FIELD->OBS		:= SC7->C7_OBSM
	endif

	FIELD->EMPRESA	:= SM0->M0_CODIGO
	FIELD->FILIAL	:= SM0->M0_CODFIL
	FIELD->PC		:= SC7->C7_CONAPRO
	FIELD->APROV1   := cAprov1
	FIELD->APROV2   := cAprov2
	FIELD->DATALI   := cDATALI
	FIELD->HORALI   := cHORALI
RETURN
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Monta Pï¿½gina HTML
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function Page_HTML()
	Local i:=1
//TMP->(dbCloseArea())
	if nTotReg <= 26
		nItens := 1
	Else
		nItens := Ceiling(nTotReg/26)
	EndIf

	//cBitMap:= "cbaaFat.Bmp"

//cRemote := GetMV("US_REMOTE")+If(Right(Rtrim(GetMV("US_REMOTE")),1)="\","","\")
	cDrive  := "C:\relatorio_protheus\"    // ONDE VAI FICAR O arquivoTmp.HTML



//*****************************************
	//Pesquiso pelos diretorios de resultado
	//*****************************************
	if !ExistDir(cDrive)
		if MakeDir(cDrive) != 0
			msgStop("Não foi possível criar o diretório de resultadios relatorio_protheus. Contate o Suporte TI")
			return
		endif
	Endif



	nDesc:= nFrete := nIPI := nBruto := nValLiq := 0

	cPc  := TMP->NUM

	For i:=1 To nItens

		cFim := chr(13)+chr(10)

		// dbUseArea(.T.,, cArqTMP, "TMP", EXCLUSIVO )
		dbSelectArea("TMP")
		dbGoTo(nGoReg)

		Pg      := ""

		cArq    := cDrive+"PC_"+cPc+"-"+alltrim(SA2->A2_NOME)+StrZero(i,2)+".HTML"

		nHdl	:= fCreate(cArq)
		cEOL    := "CHR(13)+CHR(10)"
		If Empty(cEOL)
			cEOL := CHR(13)+CHR(10)
		Else
			cEOL := Trim(cEOL)
			cEOL := &cEOL
		Endif

		If nHdl == -1
			MsgAlert("O arquivo de nome "+AllTrim(cArq)+" nao pode ser criado! Verifique os parametros.","Atencao!")
			fClose(nHdl)
			Return
		Endif

		Pg :='<HTML> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<script> ' + cFim ; fWrite(nHdl,Pg,Len(pG))

		Pg :='ie4up=nav4up=false; ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='var agt = navigator.userAgent.toLowerCase(); ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='var major = parseInt(navigator.appVersion); ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='if ((agt.indexOf("msie") != -1) && (major >= 4)) ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='ie4up = true; ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='if ((agt.indexOf("mozilla") != -1)  && (agt.indexOf("spoofer") == -1) && (agt.indexOf("compatible") == -1) && ( major>= 4)) ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='nav4up = true; ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</script> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<STYLE> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='A {text-decoration:none} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='A IMG {border-style:none; border-width:0;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='DIV {position:absolute; z-index:25;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.fc1-0 { COLOR:000000;FONT-SIZE:5PT;FONT-FAMILY:Arial;FONT-WEIGHT:NORMAL;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.fc1-1 { COLOR:000000;FONT-SIZE:13PT;FONT-FAMILY:Arial;FONT-WEIGHT:BOLD;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.fc1-2 { COLOR:000000;FONT-SIZE:9PT;FONT-FAMILY:Arial;FONT-WEIGHT:NORMAL;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.fc1-3 { COLOR:000000;FONT-SIZE:8PT;FONT-FAMILY:Arial;FONT-WEIGHT:BOLD;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.fc1-4 { COLOR:000000;FONT-SIZE:8PT;FONT-FAMILY:Times New Roman;FONT-WEIGHT:BOLD;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.fc1-5 { COLOR:000000;FONT-SIZE:6PT;FONT-FAMILY:Arial;FONT-WEIGHT:NORMAL;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.fc1-6 { COLOR:000080;FONT-SIZE:21PT;FONT-FAMILY:Comic Sans MS;FONT-WEIGHT:BOLD;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		//	Pg :='.fc1-7 { COLOR:000000;FONT-SIZE:6PT;FONT-FAMILY:Courier New;FONT-WEIGHT:NORMAL;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.fc1-7 { COLOR:000000;FONT-SIZE:7PT;FONT-FAMILY:Arial;FONT-WEIGHT:NORMAL;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.fc1-8 { COLOR:000000;FONT-SIZE:5PT;FONT-FAMILY:Arial;FONT-WEIGHT:BOLD;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.fc1-9 { COLOR:000000;FONT-SIZE:7PT;FONT-FAMILY:Arial;FONT-WEIGHT:BOLD;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.fc1-10 { COLOR:000000;FONT-SIZE:6PT;FONT-FAMILY:Courier New;FONT-WEIGHT:BOLD;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.fc1-11 { COLOR:000000;FONT-SIZE:7PT;FONT-FAMILY:Courier New;FONT-WEIGHT:NORMAL;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.fc1-12 { COLOR:000000;FONT-SIZE:5PT;FONT-FAMILY:Courier New;FONT-WEIGHT:NORMAL;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.ad1-0 {border-color:000000;border-style:none;border-bottom-width:0PX;border-left-width:0PX;border-top-width:0PX;border-right-width:0PX;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.ad1-1 {border-color:000000;border-style:none;border-bottom-width:0PX;border-left-width:0PX;border-top-width:0PX;border-right-width:0PX;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.ad1-2 {border-color:000000;border-style:none;border-bottom-style:solid;border-bottom-width:1PX;border-left-style:solid;border-left-width:1PX;border-top-style:solid;border-top-width:1PX;border-right-style:solid;border-right-width:1PX;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.ad1-3 {border-color:000000;border-style:none;border-bottom-width:0PX;border-left-style:solid;border-left-width:1PX;border-top-width:0PX;border-right-width:0PX;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.ad1-4 {border-color:000000;border-style:none;border-bottom-width:0PX;border-left-width:0PX;border-top-style:solid;border-top-width:1PX;border-right-width:0PX;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.ad1-5 {border-color:000000;border-style:none;border-bottom-style:solid;border-bottom-width:1PX;border-left-style:solid;border-left-width:1PX;border-top-style:solid;border-top-width:1PX;border-right-style:solid;border-right-width:1PX;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='.ad1-6 {border-color:000000;border-style:none;border-bottom-style:solid;border-bottom-width:1PX;border-left-style:solid;border-left-width:1PX;border-top-style:solid;border-top-width:1PX;border-right-style:solid;border-right-width:1PX;} ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</STYLE> ' + cFim ; fWrite(nHdl,Pg,Len(pG))

		Pg :='<TITLE>PEDIDO DE COMPRAS - '+NUM+If(nTotReg>26,"/"+StrZero(i,2),"")+'</TITLE>' + cFim ; fWrite(nHdl,Pg,Len(pG))

		Pg :='<BODY BGCOLOR="FFFFFF"LEFTMARGIN=0 TOPMARGIN=0 BOTTOMMARGIN=0 RIGHTMARGIN=0> ' + cFim ; fWrite(nHdl,Pg,Len(pG))

		Pg :='<div style="left:597PX;top:4PX;border-color:000000;border-style:solid;border-width:0px;border-left-width:1PX;height:137PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="0px" height="131PX"><td>&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:164PX;top:4PX;border-color:000000;border-style:solid;border-width:0px;border-left-width:1PX;height:137PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="0px" height="131PX"><td>&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:4PX;top:175PX;border-color:000000;border-style:solid;border-width:0px;border-top-width:1PX;width:744PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:4PX;top:207PX;border-color:000000;border-style:solid;border-width:0px;border-top-width:1PX;width:744PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:541PX;top:143PX;border-color:000000;border-style:solid;border-width:0px;border-left-width:1PX;height:33PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="0px" height="27PX"><td>&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:644PX;top:144PX;border-color:000000;border-style:solid;border-width:0px;border-left-width:1PX;height:32PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="0px" height="26PX"><td>&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:597PX;top:175PX;border-color:000000;border-style:solid;border-width:0px;border-left-width:1PX;height:33PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="0px" height="27PX"><td>&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:444PX;top:207PX;border-color:000000;border-style:solid;border-width:0px;border-left-width:1PX;height:33PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="0px" height="27PX"><td>&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:101PX;top:207PX;border-color:000000;border-style:solid;border-width:0px;border-left-width:1PX;height:33PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="0px" height="27PX"><td>&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:204PX;top:207PX;border-color:000000;border-style:solid;border-width:0px;border-left-width:1PX;height:33PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="0px" height="27PX"><td>&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:5PX;top:259PX;border-color:000000;border-style:solid;border-width:0px;border-top-width:1PX;width:744PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:5PX;top:275PX;border-color:000000;border-style:solid;border-width:0px;border-top-width:1PX;width:744PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))

		Pg :='<div style="left:4PX;top:850PX;border-color:000000;border-style:solid;border-width:0px;border-top-width:1PX;width:745PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:4PX;top:880PX;border-color:000000;border-style:solid;border-width:0px;border-top-width:1PX;width:745PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:4PX;top:939PX;border-color:000000;border-style:solid;border-width:0px;border-top-width:1PX;width:744PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:540PX;top:907PX;border-color:000000;border-style:solid;border-width:0px;border-top-width:1PX;width:209PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:540PX;top:811PX;border-color:000000;border-style:solid;border-width:0px;border-left-width:1PX;height:199PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="0px" height="154PX"><td>&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:660PX;top:811PX;border-color:000000;border-style:solid;border-width:0px;border-left-width:1PX;height:199PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="0px" height="155PX"><td>&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:284PX;top:811PX;border-color:000000;border-style:solid;border-width:0px;border-left-width:1PX;height:129PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="0px" height="123PX"><td>&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:108PX;top:876PX;border-color:000000;border-style:solid;border-width:0px;border-left-width:1PX;height:64PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="0px" height="58PX"><td>&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))

		Pg :='<DIV class="box" style="z-index:10; border-color:000000;border-style:solid;border-bottom-style:solid;border-bottom-width:1PX;border-left-style:solid;border-left-width:1PX;border-top-style:solid;border-top-width:1PX;border-right-style:solid;border-right-width:1PX;left:4PX;top:4PX;width:744PX;height:136PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table border=0 cellpadding=0 cellspacing=0 width=737px height=129px><TD>&nbsp;</TD></TABLE> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))

		Pg :='<DIV class="box" style="z-index:10; border-color:000000;border-style:solid;border-bottom-style:solid;border-bottom-width:1PX;border-left-style:solid;border-left-width:1PX;border-top-style:solid;border-top-width:1PX;border-right-style:solid;border-right-width:1PX;left:4PX;top:143PX;width:744PX;height:96PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table border=0 cellpadding=0 cellspacing=0 width=737px height=89px><TD>&nbsp;</TD></TABLE> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))

		Pg :='<DIV class="box" style="z-index:10; border-color:000000;border-style:solid;border-bottom-style:solid;border-bottom-width:1PX;border-left-style:solid;border-left-width:1PX;border-top-style:solid;border-top-width:1PX;border-right-style:solid;border-right-width:1PX;left:4PX;top:242PX;width:744PX;height:569PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table border=0 cellpadding=0 cellspacing=0 width=737px height=563px><TD>&nbsp;</TD></TABLE> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))

		Pg :='<DIV class="box" style="z-index:10; border-color:000000;border-style:solid;border-bottom-style:solid;border-bottom-width:1PX;border-left-style:solid;border-left-width:1PX;border-top-style:solid;border-top-width:1PX;border-right-style:solid;border-right-width:1PX;left:4PX;top:811PX;width:744PX;height:198PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table border=0 cellpadding=0 cellspacing=0 width=737px height=153px><TD>&nbsp;</TD></TABLE> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))

   		/*	Pg :='<DIV class="box" style="z-index:10; border-color:000000;border-style:solid;border-bottom-style:solid;border-bottom-width:1PX;border-left-style:solid;border-left-width:1PX;border-top-style:solid;border-top-width:1PX;border-right-style:solid;border-right-width:1PX;left:4PX;top:970PX;width:744PX;height:20PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG)) */
	 
			Pg :='<DIV style="left:604PX;top:12PX;width:136PX;height:32PX;TEXT-ALIGN:CENTER;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<table width="131PX" border=0 cellpadding=0 cellspacing=0> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<tr><td ALIGN="CENTER" class="fc1-0">OBRIGATÓRIO INFORMAR </td></tr> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<tr><td ALIGN="CENTER" class="fc1-0">NÚMERO DO PEDIDO DE COMPRA </td></tr> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<tr><td ALIGN="CENTER" class="fc1-0">NA NOTA FISCAL.</td></tr></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='</DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))

			Pg :='<DIV style="left:606PX;top:60PX;width:40PX;height:28PX;TEXT-ALIGN:CENTER;"><span class="fc1-1">PC.'+NUM+If(nTotReg>26,"/"+StrZero(i,2),"")+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			//			Pg :='<DIV style="left:660PX;top:60PX;width:72PX;height:24PX;TEXT-ALIGN:RIGHT;"><span class="fc1-1">'+NUM+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:604PX;top:100PX;width:64PX;height:17PX;TEXT-ALIGN:CENTER;"><span class="fc1-2">Emissão:</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:676PX;top:100PX;width:64PX;height:14PX;TEXT-ALIGN:CENTER;"><span class="fc1-3">'+dToc(EMISSAO)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:172PX;top:60PX;width:416PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-4">'+Rtrim(EMP_CAB1)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:172PX;top:83PX;width:416PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-5">'+RTrim(EMP_CAB2)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:172PX;top:100PX;width:416PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-5">'+RTrim(EMP_CAB3)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:172PX;top:116PX;width:416PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-5">'+RTrim(EMP_CAB4)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:172PX;top:10PX;width:416PX;height:40PX;TEXT-ALIGN:CENTER;"><span class="fc1-1">PEDIDO  DE  COMPRA</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))

				If PC <> "L"
			   Pg :='<DIV style="z-index:15;left:183PX;top:60PX;width:405PX;height:52PX;">' + cFim ; fWrite(nHdl,Pg,Len(pG))
			   Pg :='</DIV>    ' + cFim ; fWrite(nHdl,Pg,Len(pG))
				EndIf

			Pg :='<DIV style="z-index:11;left:10PX;top:6PX;width:64PX;height:60PX;">' + cFim ; fWrite(nHdl,Pg,Len(pG))
			//Pg :='<img  SRC="'+cLogo+'">' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<a href="https://www.mecatron.net/"><img src="https://i.ibb.co/5KwSwzC/MECATRON.png" alt="logo" border="0"></a>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='</DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))

			Pg :='<DIV style="left:12PX;top:151PX;width:400PX;height:8PX;"><span class="fc1-8">RAZÃO SOCIAL</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:12PX;top:161PX;width:400PX;height:19PX;"><span class="fc1-7">'+Rtrim(NOMFORN)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:452PX;top:151PX;width:76PX;height:8PX;"><span class="fc1-8">COD. FORNEC.</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:452PX;top:161PX;width:76PX;height:19PX;"><span class="fc1-7">'+Rtrim(CODFORN)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:548PX;top:151PX;width:88PX;height:8PX;"><span class="fc1-8">CONTATO</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:548PX;top:162PX;width:88PX;height:19PX;"><span class="fc1-7">'+Rtrim(CONTATO)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:652PX;top:151PX;width:88PX;height:8PX;"><span class="fc1-8">TELEFONE</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:652PX;top:162PX;width:88PX;height:19PX;"><span class="fc1-7">'+Rtrim(FONE)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:12PX;top:183PX;width:400PX;height:8PX;"><span class="fc1-8">ENDEREÇO</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:12PX;top:193PX;width:400PX;height:19PX;"><span class="fc1-7">'+Rtrim(ENDERECO)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:452PX;top:183PX;width:120PX;height:8PX;"><span class="fc1-8">BAIRRO</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:452PX;top:193PX;width:112PX;height:19PX;"><span class="fc1-7">'+Rtrim(BAIRRO)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:604PX;top:183PX;width:128PX;height:10PX;"><span class="fc1-8">CIDADE</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:604PX;top:193PX;width:128PX;height:19PX;"><span class="fc1-7">'+Rtrim(CIDADE)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:12PX;top:215PX;width:80PX;height:8PX;"><span class="fc1-8">CEP</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:12PX;top:225PX;width:80PX;height:16PX;"><span class="fc1-7">'+Rtrim(CEP)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:108PX;top:215PX;width:56PX;height:8PX;"><span class="fc1-8">ESTADO</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:108PX;top:225PX;width:56PX;height:16PX;"><span class="fc1-7">'+ESTADO+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:212PX;top:215PX;width:224PX;height:8PX;"><span class="fc1-8">C.N.P.J.</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:212PX;top:225PX;width:224PX;height:16PX;"><span class="fc1-7">'+Rtrim(CNPJ)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:452PX;top:215PX;width:272PX;height:8PX;"><span class="fc1-8">INSCR. ESTADUAL</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:452PX;top:225PX;width:272PX;height:16PX;"><span class="fc1-7">'+Rtrim(IEST)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG))

			Pg :='<DIV style="left:20PX;top:244PX;width:720PX;height:24PX;TEXT-ALIGN:CENTER;"><span class="fc1-9"> QUEIRAM NOS FORNECER OS MATERIAIS ABAIXO ESPECIFICADOS CONFORME NOSSAS CONDIÇÕES GERAIS EM PODER DE V.Sas.:</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:4PX;top:263PX;width:32PX;height:11PX;TEXT-ALIGN:CENTER;"><span class="fc1-8"> ITEM</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:44PX;top:263PX;width:48PX;height:11PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">QUANT.</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:108PX;top:263PX;width:24PX;height:11PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">UN.</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:148PX;top:263PX;width:48PX;height:11PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">CÓDIGO</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:212PX;top:263PX;width:216PX;height:11PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">DESCRIÇÃO</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
			//			Pg :='<DIV style="left:444PX;top:263PX;width:48PX;height:11PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">CONTA</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
			//			Pg :='<DIV style="left:492PX;top:263PX;width:48PX;height:11PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">S.C.</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:548PX;top:263PX;width:32PX;height:11PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">Cod Refer</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:615PX;top:263PX;width:72PX;height:11PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">PREÇO UNIT.</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
			//			Pg :='<DIV style="left:628PX;top:263PX;width:32PX;height:11PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">IPI</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
			Pg :='<DIV style="left:660PX;top:263PX;width:80PX;height:11PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">VALOR TOTAL</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))

			nRec := Recno()    
			nIt := 0
			nLin := 284
			lPula:= .t.
    		_DESCCC:=""	
				While !Eof() .And. NUM = cPc .And. lPula
				Pg :='<DIV style="left:4PX;top:'+StrZero(nLin,3)+'PX;width:32PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-7">'+Rtrim(IT)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
				Pg :='<DIV style="left:44PX;top:'+StrZero(nLin,3)+'PX;width:48PX;height:10PX;TEXT-ALIGN:RIGHT;"><span class="fc1-9">'+Transform(QUANT,"@E 999,999.99")+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
				Pg :='<DIV style="left:108PX;top:'+StrZero(nLin,3)+'PX;width:24PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-9">'+UM+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
				Pg :='<DIV style="left:140PX;top:'+StrZero(nLin,3)+'PX;width:64PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-9">'+Rtrim(CODPROD)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 

				Pg :='<DIV style="left:212PX;top:'+StrZero(nLin,3)+'PX;width:272PX;height:24PX;"><span class="fc1-9">'+Rtrim(DESPROD)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 

				// 	Pg :='<DIV style="left:444PX;top:'+StrZero(nLin,3)+'PX;width:48PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-7">'+Rtrim(CONTA)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
				//	Pg :='<DIV style="left:492PX;top:'+StrZero(nLin,3)+'PX;width:48PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-7">'+Rtrim(SC)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 	
				Pg :='<DIV style="left:548PX;top:'+StrZero(nLin,3)+'PX;width:32PX;height:10PX;TEXT-ALIGN:CENTER;"><span class="fc1-7">'+ALLTRIM(CODFOR)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
				Pg :='<DIV style="left:615PX;top:'+StrZero(nLin,3)+'PX;width:64PX;height:10PX;TEXT-ALIGN:RIGHT;"><span class="fc1-9">'+Transform(UNIT,"@E 9,999,999.9999")+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
				//	Pg :='<DIV style="left:628PX;top:'+StrZero(nLin,3)+'PX;width:32PX;height:10PX;TEXT-ALIGN:CENTER;"><span class="fc1-7">'+Transform(IPI,"@E 99.99")+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
				Pg :='<DIV style="left:660PX;top:'+StrZero(nLin,3)+'PX;width:72PX;height:10PX;TEXT-ALIGN:RIGHT;"><span class="fc1-9">'+Transform(VALOR,"@E 99,999,999.99")+'</span></DIV><BR>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
				nLin+=20                                          

					IF !(ALLTRIM(CODCC)$_DESCCC) .AND. !EMPTY(ALLTRIM(CODCC))
        		   		_DESCCC:=_DESCCC+ALLTRIM(CC)+" * "
					ENDIF
	    		nDesc   += VALDESC       
	    	nFrete  += VALFRET
	    	nIPI    += VALIPI
	    	nBruto  += VALOR
	    	nValLiq := nBruto+nFrete+nIPI-nDesc

			dbSkip()
			nGoReg++
			If nLin > 803
		   		lPula := .f.
			EndIf

		End
		IF !EMPTY(_DESCCC) .AND. nLIN<720   // SE TIVER ESPAï¿½O SOBRANDO, SERï¿½ IMPRESSO A DESCRIï¿½ï¿½O DO CCUSTO
       		nLIN:=720
	   		Pg :='<DIV style="left:212PX;top:'+StrZero(nLin,3)+'PX;width:272PX;height:24PX;"><span class="fc1-9">'+_DESCCC+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		ENDIF


		Pg :='<DIV style="left:8PX;top:819PX;width:84PX;height:11PX;"><span class="fc1-8">DESCONTO</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:292PX;top:819PX;width:240PX;height:10PX;"><span class="fc1-8">TIPO FRETE / TRANSPORTADORA</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:556PX;top:819PX;width:64PX;height:16PX;"><span class="fc1-8">VALOR BRUTO </span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:556PX;top:851PX;width:64PX;height:16PX;"><span class="fc1-8">TOTAL DESC.</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:556PX;top:883PX;width:64PX;height:16PX;"><span class="fc1-8">TOTAL IPI</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:556PX;top:915PX;width:64PX;height:16PX;"><span class="fc1-8">TOTAL FRETE/DESP.</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:556PX;top:947PX;width:64PX;height:16PX;"><span class="fc1-8">TOTAL GERAL</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:628PX;top:819PX;width:16PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">R$</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:628PX;top:851PX;width:16PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">R$</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:628PX;top:883PX;width:16PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">R$</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:628PX;top:915PX;width:16PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">R$</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		//	Pg :='<DIV style="left:628PX;top:947PX;width:16PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">R$</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:8PX;top:851PX;width:260PX;height:10PX;"><span class="fc1-8">COND. DE PAGAMENTO</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:292PX;top:851PX;width:240PX;height:8PX;"><span class="fc1-8">PRAZO DE ENTREGA</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:10PX;top:883PX;width:66PX;height:8PX;"><span class="fc1-8">TRANSPORTE</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:116PX;top:883PX;width:152PX;height:8PX;"><span class="fc1-8">HORÁRIO DE RECEBIMENTO</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:292PX;top:883PX;width:240PX;height:8PX;"><span class="fc1-8">LOCAL DE ENTREGA</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:36PX;top:899PX;width:64PX;height:8PX;"><span class="fc1-7">RETIRA</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:36PX;top:915PX;width:64PX;height:16PX;"><span class="fc1-7">ENTREGA</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:10PX;top:947PX;width:520PX;height:8PX;"><span class="fc1-8">OBSERVAÇÕES :</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		//Pg :='<DIV style="left:10PX;top:979PX;width:728PX;height:16PX;"><span class="fc1-8">OBSERVAï¿½ï¿½ES : </span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))

		If TMP->(Eof())
		TMP->(dbGoTop())
		Pg :='<DIV class="box" style="z-index:10; border-color:000000;border-style:solid;border-bottom-style:solid;border-bottom-width:1PX;border-left-style:solid;border-left-width:1PX;border-top-style:solid;border-top-width:1PX;border-right-style:solid;border-right-width:1PX;left:4PX;top:1010PX;width:744PX;height:30PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table border=0 cellpadding=0 cellspacing=0 width=737px height=46px><TD>&nbsp;</TD></TABLE> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:148PX;top:1010PX;border-color:000000;border-style:solid;border-width:0px;border-left-width:1PX;height:30PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="0px" height="47PX"><td>&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:332PX;top:1010PX;border-color:000000;border-style:solid;border-width:0px;border-left-width:1PX;height:30PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="0px" height="47PX"><td>&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:468PX;top:1010PX;border-color:000000;border-style:solid;border-width:0px;border-left-width:1PX;height:30PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="0px" height="47PX"><td>&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<div style="left:604PX;top:1010PX;border-color:000000;border-style:solid;border-width:0px;border-left-width:1PX;height:30PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="0px" height="47PX"><td>&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</div> ' + cFim ; fWrite(nHdl,Pg,Len(pG))

  	    Pg :='<DIV style="left:628PX;top:947PX;width:16PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">R$</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:68PX;top:826PX;width:72PX;height:12PX;TEXT-ALIGN:RIGHT;"><span class="fc1-7">'+Transform(nDesc,"@E 999,999.99")+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		Pg :='<DIV style="left:292PX;top:826PX;width:240PX;height:19PX;"><span class="fc1-11">'+TpFrete+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		 
		Pg :='<DIV style="left:116PX;top:899PX;width:152PX;height:40PX;"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="147PX" border=0 cellpadding=0 cellspacing=0> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<tr><td class="fc1-7">Segunda a sexta-feira, das </td></tr> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<tr><td class="fc1-7">07:00 h as 11:30 h e das </td></tr></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="147PX" border=0 cellpadding=0 cellspacing=0><td class="fc1-7">13:00 h as 16:30 h</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		
		Pg :='<DIV style="left:9PX;top:861PX;width:261PX;height:16PX;"><span class="fc1-8">'+Rtrim(CONDPAG)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		Pg :='<DIV style="left:292PX;top:861PX;width:240PX;height:16PX;"><span class="fc1-8">'+Rtrim(PRAZOENT)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		Pg :='<DIV style="left:292PX;top:893PX;width:248PX;height:16PX;"><span class="fc1-8">'+Rtrim(ENTREGA1)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		Pg :='<DIV style="left:292PX;top:909PX;width:248PX;height:16PX;"><span class="fc1-8">'+Rtrim(ENTREGA2)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		Pg :='<DIV style="left:15PX;top:957PX;width:517PX;height:16PX;"><span class="fc1-8">'+Rtrim(OBS)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
	   //	Pg :='<DIV style="left:75PX;top:979PX;width:664PX;height:15PX;"><span class="fc1-9">'+Rtrim(OBS)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		
		Pg :='<DIV style="left:660PX;top:819PX;width:72PX;height:18PX;TEXT-ALIGN:RIGHT;"><span class="fc1-9">'+Transform(nBruto,"@E 9,999,999.99")+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		Pg :='<DIV style="left:660PX;top:851PX;width:72PX;height:16PX;TEXT-ALIGN:RIGHT;"><span class="fc1-9">'+Transform(nDesc,"@E 9,999,999.99")+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		Pg :='<DIV style="left:660PX;top:883PX;width:72PX;height:16PX;TEXT-ALIGN:RIGHT;"><span class="fc1-9">'+Transform(nIPI,"@E 9,999,999.99")+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		Pg :='<DIV style="left:660PX;top:915PX;width:72PX;height:16PX;TEXT-ALIGN:RIGHT;"><span class="fc1-9">'+Transform(nFrete,"@E 9,999,999.99")+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		Pg :='<DIV style="left:660PX;top:947PX;width:72PX;height:18PX;TEXT-ALIGN:RIGHT;"><span class="fc1-9">'+Transform(nValLiq,"@E 9,999,999.99")+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		
		Pg :='<DIV style="left:12PX;top:899PX;width:11PX;height:8PX;" class="ad1-2"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="6PX" border=0 cellpadding=0 cellspacing=0><td class="fc1-12">&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		
		Pg :='</DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		 
		Pg :='<DIV style="left:12PX;top:915PX;width:11PX;height:8PX;" class="ad1-2"> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<table width="6PX" border=0 cellpadding=0 cellspacing=0><td class="fc1-12">&nbsp;</td></table> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		 
		Pg :='<DIV style="left:12PX;top:1012PX;width:128PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">SOLICITANTE </span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:156PX;top:1012PX;width:168PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">C.CUSTO</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:340PX;top:1012PX;width:120PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">COMPRADOR</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:12PX;top:1022PX;width:128PX;height:32PX;TEXT-ALIGN:CENTER;"><span class="fc1-7">'+Rtrim(SOLICITA)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		Pg :='<DIV style="left:156PX;top:1022PX;width:168PX;height:32PX;TEXT-ALIGN:CENTER;"><span class="fc1-7">'+Rtrim(CODCC)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		Pg :='<DIV style="left:340PX;top:1022PX;width:120PX;height:32PX;TEXT-ALIGN:CENTER;"><span class="fc1-7">'+Rtrim(COMPRA)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		
		Pg :='<DIV style="left:468PX;top:1012PX;width:132PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">APROVADOR 1</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:612PX;top:1012PX;width:128PX;height:16PX;TEXT-ALIGN:CENTER;"><span class="fc1-8">APROVADOR 2</span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='<DIV style="left:468PX;top:1022PX;width:128PX;height:32PX;TEXT-ALIGN:CENTER;"><span class="fc1-7">'+Rtrim(APROV1)+"-"+DATALI+"-"+ALLTRIM(HORALI)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		Pg :='<DIV style="left:612PX;top:1022PX;width:128PX;height:32PX;TEXT-ALIGN:CENTER;"><span class="fc1-0">'+Rtrim(APROV2)+'</span></DIV>' + cFim ; fWrite(nHdl,Pg,Len(pG)) 
		Else
        Pg := '<DIV style="left:34PX;top:1000PX;width:725PX;height:24PX;TEXT-ALIGN:CENTER;"><span class="fc1-9"> CONTINUA NA PRÓXIMA PÁGINA </span></DIV> ' + cFim ; fWrite(nHdl,Pg,Len(pG))	
		EndIf
	
		Pg :='<BR> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
		Pg :='</BODY></HTML> ' + cFim ; fWrite(nHdl,Pg,Len(pG))
	
		fClose(nHdl)                        
	
		// TMP->(dbCloseArea())
	
		WaitRun("Explorer "+cArq,0)

	Next i
	
Return


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Verifca Parametros Auxiliares, cria caso nï¿½o existam
STATIC Function VerParametros()
	dbSelectArea("SX6")
	If !dbSeek("  US_IMPSP")
	    RecLock("SX6",.T.)
	    X6_VAR		:= "US_IMPSP"
	    X6_TIPO		:= "C"
	    X6_DESCRIC	:= "Gera Formulário de Solicitaï¿½ï¿½o de Pagamento ?  (S)im  N(ao)"
	    X6_PROPRI	:= "U"  
	    X6_CONTEUD  := "N"
	    MsUnLock()
	EndIf
	dbSelectArea("SX6")
	If !dbSeek("  US_CTNFE")
    	RecLock("SX6",.T.)
	    X6_VAR		:= "US_CTNFE"
    	X6_TIPO		:= "C"
	    X6_DESCRIC	:= "CONTABILIZA N. FISCAL ENTRADA On Line ?  (S)im  N(ao)"
    	X6_PROPRI	:= "U"  
	    X6_CONTEUD  := "S"
    	MsUnLock()
	EndIf
	dbSelectArea("SX6")
	If !dbSeek("  US_INSSEMP")
	    RecLock("SX6",.T.)
	    X6_VAR		:= "US_INSSEMP"
	    X6_TIPO		:= "C"
	    X6_DESCRIC	:= "Contabiliza INSS parte Empresa,no Ctas Pagar e NFE ?  (S)im  N(ao)"
	    X6_PROPRI	:= "U"  
	    X6_CONTEUD  := "S"
	    MsUnLock()
	EndIf
	dbSelectArea("SX6")
	If !dbSeek("  US_APRFIN")
	    RecLock("SX6",.T.)
	    X6_VAR		:= "US_APRFIN"
	    X6_TIPO		:= "C"	
    	X6_DESCRIC	:= "Utiliza Controle Aprovacao no Financeiro ?  (S)im  N(ao)" 
    	X6_PROPRI	:= "U"  
	    X6_CONTEUD  := "N"
    	MsUnLock()
	EndIf
	dbSelectArea("SX6")
	If !dbSeek("  US_REMOTE")
	    RecLock("SX6",.T.)
	    X6_VAR		:= "US_REMOTE"
	    X6_TIPO		:= "C"	
    	X6_DESCRIC	:= "Mapeamento para Diretorio Remote (Drive)" 
    	X6_PROPRI	:= "U"  
	    X6_CONTEUD  := ""
    	MsUnLock()
	EndIf
	dbSelectArea("SX6")
	If !dbSeek("  US_HTML")
	    RecLock("SX6",.T.)
	    X6_VAR		:= "US_HTML"
	    X6_TIPO		:= "C"	
    	X6_DESCRIC	:= "Path para Gravação de HTML's" 
    	X6_PROPRI	:= "U"  
	    X6_CONTEUD  := ""
    	MsUnLock()
	EndIf
	dbSelectArea("SX6")
	If !dbSeek("  US_MAXPC")
	    RecLock("SX6",.T.)
	    X6_VAR		:= "US_MAXPC"
	    X6_TIPO		:= "N"	
    	X6_DESCRIC	:= "% Máximo para divergencia do PC x NF" 
    	X6_PROPRI	:= "U"  
	    X6_CONTEUD  := "10"
    	MsUnLock()
	EndIf
	dbSelectArea("SX6")
	If !dbSeek("  US_MINPC")
	    RecLock("SX6",.T.)
	    X6_VAR		:= "US_MINPC"
	    X6_TIPO		:= "N"	
    	X6_DESCRIC	:= "% minimo para divergencia do PC x NF" 
    	X6_PROPRI	:= "U"  
	    X6_CONTEUD  := "10"
    	MsUnLock()
	EndIf
	dbSelectArea("SX6")
	If !dbSeek("  US_HISTNFE")
	    RecLock("SX6",.T.)
	    X6_VAR		:= "US_HISTNFE"
	    X6_TIPO		:= "C"	
    	X6_DESCRIC	:= "Informa Historico Financeiro na N.F. Entrada ?" 
	    X6_DESC1	:= ""
    	X6_PROPRI	:= "U"  
	    X6_CONTEUD  := "N"
    	MsUnLock()
	EndIf
	dbSelectArea("SX6")
	If !dbSeek("  US_CPGPC")
	    RecLock("SX6",.T.)
	    X6_VAR	:= "US_CPGPC"
	    X6_TIPO	:= "C"	
	    X6_DESCRIC	:= "Gera Titulo Provisorio no C.Pagar, na aprov. do PC ?  (S)im  N(ao)" 
	    X6_PROPRI	:= "U"  
    	X6_CONTEUD  := "N"
   	    MsUnLock()
	EndIf
                      
Return(Nil)


