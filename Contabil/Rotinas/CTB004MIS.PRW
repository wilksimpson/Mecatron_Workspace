#INCLUDE "RWMAKE.CH"
/*/{Protheus.doc} CTB004MIS
Libera ou inibe documentos de saída Para Contabilização.
@type function
@version  
@author wilks
@since 30/05/2022
@return variant, return_description
/*/
USER FUNCTION CTB004MIS()
	LOCAL _CAREA	:= GETAREA()
	LOCAL CPERG  	:= "CTB001MIS"
	LOCAL NOPC, OMARK, ODLG
	LOCAL BOK     	:= {|| NOPC:=1,ODLG:END() }
	LOCAL BCANCEL 	:= {|| NOPC:=0,ODLG:END() }
	LOCAL APERGS  	:= {}
	Local oTempTable

	Private cAliasBrw := GetNextAlias()

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
	ACAMPOS:={}
	AADD(ACAMPOS	,{"F2_OK"		,"C"	,02	,0})
	AADD(ACAMPOS	,{"F2_DOC"		,"C"	,09	,0})
	AADD(ACAMPOS	,{"F2_SERIE"	,"C"	,03	,0})
	AADD(ACAMPOS	,{"F2_CLIENTE"	,"C"	,06	,0})
	AADD(ACAMPOS	,{"F2_LOJA"		,"C"	,02	,0})
	AADD(ACAMPOS	,{"F2_NOME"		,"C"	,50	,0})
	AADD(ACAMPOS	,{"F2_VALMERC"	,"N"	,14	,2})
	AADD(ACAMPOS	,{"F2_EMISSAO"	,"D"	,08	,0})
	AADD(ACAMPOS	,{"F2_DTLANC"	,"D"	,08	,0})
	AADD(ACAMPOS	,{"RECNO"		,"N"	,06	,0})

	ACAMPOS2:={}
	AADD(ACAMPOS2	,{"F2_OK"		,	," "				})
	AADD(ACAMPOS2	,{"F2_DOC"		,	,"NF"				})
	AADD(ACAMPOS2	,{"F2_SERIE"	,	,"Serie"			})
	AADD(ACAMPOS2	,{"F2_CLIENTE"	,	,"CLIENTEdor"	})
	AADD(ACAMPOS2	,{"F2_LOJA"		,	,"Loja"			})
	AADD(ACAMPOS2	,{"F2_NOME"		,	,"Nome"			})
	AADD(ACAMPOS2	,{"F2_VALMERC"	,	,"Valor"			})
	AADD(ACAMPOS2	,{"F2_EMISSAO"	,	,"Dt. Digit."	})
	AADD(ACAMPOS2	,{"F2_DTLANC"	,	,"Dt. Lanc."	})
	AADD(ACAMPOS2	,{"RECNO"		,	,"Recno"	})

	oTemptable:SetFields( ACAMPOS )
//------------------
//Criação da tabela
//------------------
	oTempTable:Create()
	cQuer2 := oTempTable:GetRealName()
	DbSelectArea(cAliasBrw)


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
	CQUERY	+= "   " + RETSQLNAME("SF2") + " "
	CQUERY	+= "WHERE "
	CQUERY	+= "   F2_FILIAL = '" + XFILIAL("SF2") + "' "
	CQUERY	+= "   AND F2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
	CQUERY	+= "   AND F2_DOC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	CQUERY	+= "   AND F2_SERIE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	CQUERY	+= "   AND D_E_L_E_T_ <> '*' "

	CQUERY	:= CHANGEQUERY(CQUERY)

	DBUSEAREA(.T., "TOPCONN", TCGENQRY(,,CQUERY),"TF2",.F., .T.)

	DBSELECTAREA("TF2")
	DBGOTOP()
	WHILE !EOF()
		DBSELECTAREA(cAliasBrw)

		WHILE !RECLOCK(cAliasBrw,.T.); ENDDO
			REPLACE F2_OK		WITH CMARCA
			REPLACE F2_DOC		WITH TF2->F2_DOC
			REPLACE F2_SERIE	WITH TF2->F2_SERIE
			REPLACE F2_CLIENTE	WITH TF2->F2_CLIENTE
			REPLACE F2_LOJA		WITH TF2->F2_LOJA
			REPLACE F2_NOME		WITH POSICIONE("SA1",1,XFILIAL("SA1") + TF2->F2_CLIENTE + TF2->F2_LOJA,"A1_NOME")
			REPLACE F2_VALMERC	WITH TF2->F2_VALMERC
			REPLACE F2_EMISSAO	WITH STOD(TF2->F2_EMISSAO)
			REPLACE F2_DTLANC	WITH STOD(TF2->F2_DTLANC)
			REPLACE RECNO		WITH TF2->R_E_C_N_O_
			MSUNLOCK()
			DBSELECTAREA("TF2")
			DBSKIP()
		ENDDO

		DBSELECTAREA(cAliasBrw)
		DBGOTOP()

		DEFINE MSDIALOG ODLG TITLE "Seleção de Notas Fiscais de SAIDA  -  " + IIF(MV_PAR07 == 1,"Inibir Contabilização","Liberar Contabilização") FROM 00,00 TO 520,990 PIXEL
		OMARK := MSSELECT():NEW(cAliasBrw, "F2_OK", ,ACAMPOS2 ,.F. ,CMARCA ,{032 ,003 ,240 ,480 } , , , )
		OMARK:OBROWSE:REFRESH()
		OMARK:OBROWSE:LHASMARK    := .T.
		oMARK:oBROWSE:bALLMARK := {|| U_MALLBrwC(cMarca,lInverte,.T.)}
		ACTIVATE MSDIALOG ODLG CENTER ON INIT ENCHOICEBAR(ODLG,BOK,BCANCEL,,)

		IF NOPC == 1
			PROCESSA({|LEND|CTB002MIS(cAliasBrw)})
		ENDIF

		DBSELECTAREA(cAliasBrw)
		DBCLOSEAREA(cAliasBrw)
//---------------------------------
//Exclui a tabela
//---------------------------------
		oTempTable:Delete()

		DBSELECTAREA("TF2")
		DBCLOSEAREA("TF2")
		RETURN NIL

//==============================================
User Function MALLBrwC(cMarca,lInverte,lAll)
//==============================================

	Local aArea := GetArea()

	If lAll
		Dbselectarea(cAliasBrw)
		Dbgotop()
		While !eof()
			RECLOCK(cAliasBrw,.F.)
			F2_OK := IF(F2_OK == "  ",cMARCA,"  ")
			MSUNLOCK()
			Dbskip()
		End
	Endif

	RestArea(aArea)
Return .t.

 
STATIC FUNCTION CTB002MIS(cAliasBrw)
	DBSELECTAREA(cAliasBrw)
	(cAliasBrw)->(DBGOTOP())

	WHILE (cAliasBrw)->(!EOF())
		IF (cAliasBrw)->F2_OK != CMARCA
			(cAliasBrw)->(DBSKIP())
			LOOP
		ENDIF

		DBSELECTAREA("SF2")
		//SF2->(DBSETORDER(1))
		//IF SF2->(DBSEEK(XFILIAL("SF2") + cAliasBrw->F2_DOC + cAliasBrw->F2_SERIE + cAliasBrw->F2_CLIENTE + cAliasBrw->F2_LOJA))
		SF2->(DbGoTo((cAliasBrw)->RECNO))
		WHILE !RECLOCK("SF2",.F.);ENDDO
			IF MV_PAR07 == 1
				SF2->F2_DTLANC  := DDATABASE
			ENDIF

			IF MV_PAR07 == 2
				SF2->F2_DTLANC  := CTOd("  /  /    ")
			ENDIF


			SF2->(DBCOMMIT())
			SF2->(MSUNLOCK())

			(cAliasBrw)->(DBSKIP())
		ENDDO


		RETURN()






/*
LOCAL _CPERG 			:= "CTB001MIS"


PRIVATE CINDEXNAME	:= ''
PRIVATE CINDEXKEY  	:= ''
PRIVATE CFILTER    	:= ''
PRIVATE _EXEC    		:= .F.

DBSELECTAREA("SF2")

IF PERGUNTE(_CPERG,.T.)
CINDEXNAME	:= CRIATRAB(NIL,.F.)
CINDEXKEY  :=	"F2_FILIAL+F2_EMISSAO+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA"
CFILTER   	:=	"DTOS(F2_EMISSAO) >= '"	+ DTOS(MV_PAR01) + "' .AND. DTOS(F2_EMISSAO) <= '"	+ DTOS(MV_PAR02) + "' .AND. " + ;
"F2_DOC >= '" 		+ MV_PAR03 + "' .AND. F2_DOC <= '" 		+ MV_PAR04 + "' .AND. " + ;
"F2_SERIE >= '" 	+ MV_PAR05 + "' .AND. F2_SERIE <= '" 	+ MV_PAR06 + "' "


ALERT(CFILTER)
INDREGUA("SF2" ,CINDEXNAME ,CINDEXKEY , ,CFILTER ,"Aguarde, selecionando registros....")

DBSELECTAREA("SF2")

#IFNDEF TOP
DBSETINDEX(CINDEXNAME + ORDBAGEXT())
#ENDIF

DBGOTOP()

@ 001,001 TO 400,700 DIALOG ODLG TITLE "Selecao de Notas Fiscais de Entrada"
@ 001,001 TO 170,350 BROWSE "SF2" //!MARK "F2_OK"
@ 180,310 BMPBUTTON TYPE 01 ACTION (_EXEC := .T.,CLOSE(ODLG))
@ 180,280 BMPBUTTON TYPE 02 ACTION (_EXEC := .F.,CLOSE(ODLG))
//@ 180,220 CHECKBOX "Confirma Marcacoes" Var Exec
//@ 180,300 BUTTON "_Ok" SIZE 40,15 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

//dbGoTop()

//Do While !Eof()
//	If Marked("E1_OK")
//		AADD(aMarked,.T.)
//	Else
//		AADD(aMarked,.F.)
//	EndIf
//	dbSkip()
//EndDo

DBGOTOP()

IF _EXEC
PROCESSA({|LEND|CTB002MIS()})
ENDIF

DBSELECTAREA("SF2")
RETINDEX("SF2")
FERASE(CINDEXNAME+ORDBAGEXT())
ENDIF

*/

		RESTAREA(_CAREA)
		RETURN(.T.)

