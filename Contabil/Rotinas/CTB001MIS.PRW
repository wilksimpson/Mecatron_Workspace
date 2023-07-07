#INCLUDE "RWMAKE.CH"
/*/{Protheus.doc} CTB001MIS
Libera ou inibe documentos de Entrada Para Contabilização.
@type function
@version  
@author wilks
@since 30/05/2022
@return variant, return_description
/*/
USER FUNCTION CTB001MIS()
LOCAL _CAREA	:= GETAREA()
LOCAL CPERG  	:= "CTB001MIS"
LOCAL NOPC, OMARK, ODLG
LOCAL BOK     	:= {|| NOPC:=1,ODLG:END() }
LOCAL BCANCEL 	:= {|| NOPC:=0,ODLG:END() }
LOCAL APERGS  	:= {}
Local ACAMPOS 	:= {}
Local oTempTable
Local cAliasBrw := "COMTEMP"
Local cQuery
Local cQuer2

PRIVATE CMARCA			:= GETMARK()
PRIVATE LINVERTE		:= .F.
PRIVATE LEXEC      	:= .F.
PRIVATE CINDEXNAME	:= ''
PRIVATE CINDEXKEY  	:= ''
PRIVATE CFILTER    	:= ''
PRIVATE NLASTKEY 		:= 0


//-------------------
//Criação do objeto
//-------------------
oTempTable := FWTemporaryTable():New( cAliasBrw )
//--------------------------
//Monta os campos da tabela
//--------------------------
//ACAMPOS:={}
AADD(ACAMPOS	,{"F1_OK"		,"C"	,02	,0})
AADD(ACAMPOS	,{"F1_DOC"		,"C"	,09	,0})
AADD(ACAMPOS	,{"F1_SERIE"	,"C"	,03	,0})
AADD(ACAMPOS	,{"F1_FORNECE"	,"C"	,06	,0})
AADD(ACAMPOS	,{"F1_LOJA"		,"C"	,02	,0})
AADD(ACAMPOS	,{"F1_NOME"		,"C"	,50	,0})
AADD(ACAMPOS	,{"F1_VALMERC"	,"N"	,14	,2})
AADD(ACAMPOS	,{"F1_EMISSAO"	,"D"	,08	,0})
AADD(ACAMPOS	,{"F1_DTLANC"	,"D"	,08	,0})
oTemptable:SetFields( ACAMPOS )
//------------------
//Criação da tabela
//------------------
oTempTable:Create()
cQuer2 := oTempTable:GetRealName()
//MPSysOpenQuery( cQuer2, 'QRYTMP' )
DbSelectArea(cAliasBrw)

ACAMPOS2:={}
AADD(ACAMPOS2	,{"F1_OK"		,	," "				})
AADD(ACAMPOS2	,{"F1_DOC"		,	,"NF"				})
AADD(ACAMPOS2	,{"F1_SERIE"	,	,"Serie"			})
AADD(ACAMPOS2	,{"F1_FORNECE"	,	,"CLIENTEdor"	})
AADD(ACAMPOS2	,{"F1_LOJA"		,	,"Loja"			})
AADD(ACAMPOS2	,{"F1_NOME"		,	,"Nome"			})
AADD(ACAMPOS2	,{"F1_VALMERC"	,	,"Valor"			})
AADD(ACAMPOS2	,{"F1_EMISSAO"	,	,"Dt. Digit."	})
AADD(ACAMPOS2	,{"F1_DTLANC"	,	,"Dt. Lanc."	})



PERGUNTE (CPERG,.T.)

//Wnrel := SetPrint(cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)
/*
If nLastKey == 27
Set Filter to
DbSelectArea("TRBCOM")
DbCloseArea("TRBCOM")
Return
Endif

SetDefault(aReturn,cString)
*/

IF NLASTKEY == 27
	SET FILTER TO
	DBSELECTAREA(cAliasBrw)
	DBCLOSEAREA(cAliasBrw)
	RETURN
ENDIF

CQUERY	:= "SELECT "
CQUERY	+= "   * "
CQUERY	+= "FROM "
CQUERY	+= "   " + RETSQLNAME("SF1") + " "
CQUERY	+= "WHERE "
CQUERY	+= "   F1_FILIAL = '" + XFILIAL("SF1") + "' "
CQUERY	+= "   AND F1_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
CQUERY	+= "   AND F1_DOC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
CQUERY	+= "   AND F1_SERIE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
CQUERY	+= "   AND D_E_L_E_T_ <> '*' "

CQUERY	:= CHANGEQUERY(CQUERY)

DBUSEAREA(.T., "TOPCONN", TCGENQRY(,,CQUERY),"TF1",.F., .T.)

DBSELECTAREA("TF1")
DBGOTOP()
WHILE !EOF()
	DBSELECTAREA(cAliasBrw)
	//DBGOTOP()
	
	//WHILE !EOF() //Enquando 
	RECLOCK(cAliasBrw,.T.) 
	REPLACE F1_OK		WITH CMARCA
	REPLACE F1_DOC		WITH TF1->F1_DOC
	REPLACE F1_SERIE	WITH TF1->F1_SERIE
	REPLACE F1_FORNECE	WITH TF1->F1_FORNECE
	REPLACE F1_LOJA		WITH TF1->F1_LOJA
	REPLACE F1_NOME		WITH POSICIONE("SA2",1,XFILIAL("SA2") + TF1->F1_FORNECE + TF1->F1_LOJA,"A2_NOME")
	REPLACE F1_VALMERC	WITH TF1->F1_VALMERC
	REPLACE F1_EMISSAO	WITH STOD(TF1->F1_EMISSAO)
	REPLACE F1_DTLANC	WITH STOD(TF1->F1_DTLANC)
	MSUNLOCK()
	//ENDDO
	DBSELECTAREA("TF1")
	TF1->(DBSKIP())
ENDDO

DBSELECTAREA(cAliasBrw)
DBGOTOP()

DEFINE MSDIALOG ODLG TITLE "Seleção de Notas Fiscais de SAIDA  -  " + IIF(MV_PAR07 == 1,"Inibir Contabilização","Liberar Contabilização") FROM 00,00 TO 520,990 PIXEL
OMARK := MSSELECT():NEW(cAliasBrw, "F1_OK", ,ACAMPOS2 ,.F. ,CMARCA ,{032 ,003 ,240 ,480 } , , , )
OMARK:OBROWSE:REFRESH()
OMARK:OBROWSE:LHASMARK    := .T.
oMARK:oBROWSE:bALLMARK := {|| U_MALLBrwd(cMarca,lInverte,.T.)}
ACTIVATE MSDIALOG ODLG CENTER ON INIT ENCHOICEBAR(ODLG,BOK,BCANCEL,,)

IF NOPC == 1
	PROCESSA({|LEND|CTB002MIS()})
ENDIF

DBSELECTAREA(cAliasBrw)
DBCLOSEAREA(cAliasBrw)
//---------------------------------
//Exclui a tabela
//---------------------------------
oTempTable:Delete() 

DBSELECTAREA("TF1")
DBCLOSEAREA("TF1")
RETURN NIL


STATIC FUNCTION CTB002MIS()
DBSELECTAREA("COMTEMP")
COMTEMP->(DBGOTOP())

WHILE COMTEMP->(!EOF())
	IF COMTEMP->F1_OK != CMARCA
		COMTEMP->(DBSKIP())
		LOOP
	ENDIF    

                
	
	
	DBSELECTAREA("SF1")
	SF1->(DBSETORDER(1))
	IF SF1->(DBSEEK(XFILIAL("SF1") + COMTEMP->F1_DOC + COMTEMP->F1_SERIE + COMTEMP->F1_FORNECE + COMTEMP->F1_LOJA))
		WHILE !RECLOCK("SF1",.F.);ENDDO
		IF MV_PAR07 == 1
			SF1->F1_DTLANC  := DDATABASE
		ENDIF
		
		IF MV_PAR07 == 2
			SF1->F1_DTLANC  := CTOd("  /  /    ")
		ENDIF
		
		
		SF1->(DBCOMMIT())
		SF1->(MSUNLOCK())
	ENDIF
	
	COMTEMP->(DBSKIP()) //TRBCOM
ENDDO


RETURN()


RESTAREA(_CAREA)
RETURN(.T.)


//==============================================
User Function MALLBrwd(cMarca,lInverte,lAll)
//==============================================

Local aArea := GetArea()

If lAll
	Dbselectarea("COMTEMP")
	Dbgotop()
	While !eof()              
	    RECLOCK("COMTEMP",.F.)
		F1_OK := IF(F1_OK == "  ",cMARCA,"  ")   
		MSUNLOCK()
		Dbskip()
	End
Endif

RestArea(aArea)
Return .t.

