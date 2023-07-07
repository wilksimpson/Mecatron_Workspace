#INCLUDE "RWMAKE.CH"
/*/{Protheus.doc} CTB003MIS
Libera ou inibe documentos de Movimentos Financeiros Para Contabilização.
@type function
@version  
@author wilks
@since 30/05/2022
@return variant, return_description
/*/
USER FUNCTION CTB003MIS()
LOCAL _CAREA	:= GETAREA()
//LOCAL CPERG  	:= "CTB002MIS"
LOCAL CPERG  	:= "CTB003MIS"
LOCAL NOPC, OMARK, ODLG
LOCAL BOK     	:= {|| NOPC:=1,ODLG:END() }
LOCAL BCANCEL 	:= {|| NOPC:=0,ODLG:END() }
LOCAL APERGS  	:= {}
Local oTempTable
Local cAliasBrw := "FINTEMP"
Local cQuery
Local cQuer2

PRIVATE CMARCA			:= GETMARK()
PRIVATE LINVERTE		:= .F.
PRIVATE LEXEC      	    := .F.
PRIVATE CINDEXNAME	    := ''
PRIVATE CINDEXKEY  	    := ''
PRIVATE CFILTER    	    := ''
PRIVATE NLASTKEY 		:= 0

PERGUNTE (CPERG,.T.)

	mv_par08 :=4


//-------------------
//Criação do objeto
//-------------------
oTempTable := FWTemporaryTable():New( cAliasBrw )
//--------------------------
//Monta os campos da tabela
//--------------------------

if mv_par08==1
	
	ACAMPOS:={}
	AADD(ACAMPOS	,{"E5_LA"		,"C"	,02	,0})
	AADD(ACAMPOS	,{"E2_HIST"	,"C"	,50	,0})
	AADD(ACAMPOS	,{"E2_VALOR"	,"N"	,14	,2})
	AADD(ACAMPOS	,{"E2_EMIS1"	    ,"D"	,08	,0})
	AADD(ACAMPOS	,{"E2_NUM"  ,"C"	,9	,0})
	AADD(ACAMPOS	,{"E2_PREFIXO"      ,"C"	,3	,0})
	AADD(ACAMPOS	,{"E2_TIPO"      ,"C"	,3	,0})
	AADD(ACAMPOS	,{"E2_PARCELA"      ,"C"	,3	,0})
	AADD(ACAMPOS	,{"E2_REC"      ,"N"	,14	,0})
	
	ACAMPOS2:={}
	AADD(ACAMPOS2	,{"E5_LA"		,	," "				})
	AADD(ACAMPOS2	,{"E2_HIST"	,	,"Historico"			})
	AADD(ACAMPOS2	,{"E2_VALOR"	,	,"Valor"			})
	AADD(ACAMPOS2	,{"E2_EMIS1"		,	,"Data"	})
	AADD(ACAMPOS2	,{"E2_NUM"      ,	,"Titulo" })
	AADD(ACAMPOS2	,{"E2_PREFIXO"  ,	,"Serie" })
	AADD(ACAMPOS2	,{"E2_TIPO"      ,	,"Tipo" })
	AADD(ACAMPOS2	,{"E2_PARCELA"      ,	,"Parcela" })
	AADD(ACAMPOS2	,{"E2_REC"      ,	,"Registro" })
	
	
	
elseif mv_par08==2
	
	ACAMPOS:={}
	AADD(ACAMPOS	,{"E5_LA"		,"C"	,02	,0})
	AADD(ACAMPOS	,{"E1_HIST"	,"C"	,50	,0})
	AADD(ACAMPOS	,{"E1_VALOR"	,"N"	,14	,2})
	AADD(ACAMPOS	,{"E1_EMISSAO"	    ,"D"	,08	,0})
	AADD(ACAMPOS	,{"E1_NUM"  ,"C"	,9	,0})
	AADD(ACAMPOS	,{"E1_PREFIXO"      ,"C"	,3	,0})
	AADD(ACAMPOS	,{"E1_TIPO"      ,"C"	,3	,0})
	AADD(ACAMPOS	,{"E1_PARCELA"      ,"C"	,3	,0})
	AADD(ACAMPOS	,{"E1_REC"      ,"N"	,14	,0})
	
	ACAMPOS2:={}
	AADD(ACAMPOS2	,{"E5_LA"		,	," "				})
	AADD(ACAMPOS2	,{"E1_HIST"	,	,"Historico"			})
	AADD(ACAMPOS2	,{"E1_VALOR"	,	,"Valor"			})
	AADD(ACAMPOS2	,{"E1_EMISSAO"		,	,"Data"	})
	AADD(ACAMPOS2	,{"E1_NUM"      ,	,"Titulo" })
	AADD(ACAMPOS2	,{"E1_PREFIXO"  ,	,"Serie" })
	AADD(ACAMPOS2	,{"E1_TIPO"      ,	,"Tipo" })
	AADD(ACAMPOS2	,{"E1_PARCELA"      ,	,"Parcela" })
	AADD(ACAMPOS2	,{"E1_REC"      ,	,"Registro" })
	
	
	elseIF MV_PAR08==3
	
	ACAMPOS:={}
	AADD(ACAMPOS	,{"E5_LA"		,"C"	,02	,0})
	AADD(ACAMPOS	,{"EF_BANCO"	,"C"	,03	,0})
	AADD(ACAMPOS	,{"EF_AGENCIA"	,"C"	,05	,0})
	AADD(ACAMPOS	,{"EF_CONTA"	,"C"	,10	,0})
	AADD(ACAMPOS	,{"EF_HISTOR"	,"C"	,50	,0})
	AADD(ACAMPOS	,{"EF_VALOR"	,"N"	,14	,2})
	AADD(ACAMPOS	,{"EF_DATA"	    ,"D"	,08	,0})
	AADD(ACAMPOS	,{"EF_NUM"  ,"C"	,25	,0})
	AADD(ACAMPOS	,{"EF_PREFIXO"      ,"C"	,3	,0})
	AADD(ACAMPOS	,{"EF_TITULO"      ,"C"	,9	,0})
	AADD(ACAMPOS	,{"EF_PARCELA"      ,"C"	,3	,0})
	AADD(ACAMPOS	,{"EF_REC"      ,"N"	,14	,0})

	ACAMPOS2:={}
	AADD(ACAMPOS2	,{"E5_LA"		,	," "				})
	AADD(ACAMPOS2	,{"EF_BANCO"	,	,"Banco"				})
	AADD(ACAMPOS2	,{"EF_AGENCIA"	,	,"Agencia"			})
	AADD(ACAMPOS2	,{"EF_CONTA"	,	,"Conta"	})
	AADD(ACAMPOS2	,{"EF_HISTOR"	,	,"Historico"			})
	AADD(ACAMPOS2	,{"EF_VALOR"	,	,"Valor"			})
	AADD(ACAMPOS2	,{"EF_DATA"		,	,"Data"	})
	AADD(ACAMPOS2	,{"EF_NUM"	,	,"Documento"	})
	AADD(ACAMPOS2	,{"EF_PREFIXO"  ,	,"Serie" })
	AADD(ACAMPOS2	,{"EF_TITULO"      ,	,"Titulo" })
	AADD(ACAMPOS2	,{"EF_PARCELA"      ,	,"Parcela" })
	AADD(ACAMPOS2	,{"EF_REC"      ,	,"Registro" })



ELSE
	
	
	ACAMPOS:={}
	AADD(ACAMPOS	,{"E5_LA"		,"C"	,02	,0})
	AADD(ACAMPOS	,{"E5_BANCO"	,"C"	,03	,0})
	AADD(ACAMPOS	,{"E5_AGENCIA"	,"C"	,05	,0})
	AADD(ACAMPOS	,{"E5_CONTA"	,"C"	,10	,0})
	AADD(ACAMPOS	,{"E5_HISTOR"	,"C"	,50	,0})
	AADD(ACAMPOS	,{"E5_VALOR"	,"N"	,14	,2})
	AADD(ACAMPOS	,{"E5_DATA"	    ,"D"	,08	,0})
	AADD(ACAMPOS	,{"E5_DOCUMEN"  ,"C"	,25	,0})
	AADD(ACAMPOS	,{"E5_REC"      ,"N"	,14	,0})
	AADD(ACAMPOS	,{"E5_PREFIXO"      ,"C"	,3	,0})
	AADD(ACAMPOS	,{"E5_NUMERO"      ,"C"	,9	,0})
	AADD(ACAMPOS	,{"E5_PARCELA"      ,"C"	,3	,0})
	
	ACAMPOS2:={}
	AADD(ACAMPOS2	,{"E5_LA"		,	," "				})
	AADD(ACAMPOS2	,{"E5_BANCO"	,	,"Banco"				})
	AADD(ACAMPOS2	,{"E5_AGENCIA"	,	,"Agencia"			})
	AADD(ACAMPOS2	,{"E5_CONTA"	,	,"Conta"	})
	AADD(ACAMPOS2	,{"E5_HISTOR"	,	,"Historico"			})
	AADD(ACAMPOS2	,{"E5_VALOR"	,	,"Valor"			})
	AADD(ACAMPOS2	,{"E5_DATA"		,	,"Data"	})
	AADD(ACAMPOS2	,{"E5_DOCUMEN"	,	,"Documento"	})
	AADD(ACAMPOS2	,{"E5_REC"      ,	,"Registro" })
	AADD(ACAMPOS2	,{"E5_PREFIXO"  ,	,"Serie" })
	AADD(ACAMPOS2	,{"E5_NUMERO"      ,	,"Titulo" })
	AADD(ACAMPOS2	,{"E5_PARCELA"      ,	,"Parcela" })
endif
oTemptable:SetFields( ACAMPOS )
//------------------
//Criação da tabela
//------------------
oTempTable:Create()
cQuer2 := oTempTable:GetRealName()
DbSelectArea(cAliasBrw)

IF NLASTKEY == 27
	SET FILTER TO
	DBSELECTAREA(cAliasBrw)
	DBCLOSEAREA(cAliasBrw)
	RETURN
ENDIF


	
IF MV_PAR08 == 4
	
	CQUERY	:= "SELECT R_E_C_N_O_ REC, "
	CQUERY	+= "   * "
	CQUERY	+= "FROM "
	CQUERY	+= "   " + RETSQLNAME("SE5") 
	CQUERY	+= " WHERE "
	CQUERY	+= "   E5_FILIAL = '" + XFILIAL("SE5") + "' "
	CQUERY	+= "   AND E5_DATA   BETWEEN '" + DTOS(MV_PAR01)    + "' AND '" + DTOS(MV_PAR02)    + "' "
	CQUERY	+= "   AND E5_NUMERO BETWEEN '" + AllTrim(MV_PAR03) + "' AND '" + AllTrim(MV_PAR04) + "' "
	CQUERY	+= "   AND E5_SERREC BETWEEN '" + AllTrim(MV_PAR05) + "' AND '" + AllTrim(MV_PAR06) + "' "
	CQUERY	+= "   AND E5_RECONC = 'x' "
	CQUERY	+= "   AND E5_NUMCHEQ BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
	CQUERY	+= "   AND LEFT(E5_DOCUMEN,6) BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' "
	CQUERY	+= "   AND E5_LA = 'S' "
	CQUERY	+= "   AND D_E_L_E_T_ <> '*' "
	CQUERY	+= "   UNION ALL "
	CQUERY	+= "SELECT R_E_C_N_O_ REC, "
	CQUERY	+= "   * "
	CQUERY	+= "FROM "
	CQUERY	+= "   " + RETSQLNAME("SE5") 
	CQUERY	+= " WHERE "
	CQUERY	+= "   E5_FILIAL = '" + XFILIAL("SE5") + "' "
	CQUERY	+= "   AND E5_DATA   BETWEEN '" + DTOS(MV_PAR01)    + "' AND '" + DTOS(MV_PAR02)    + "' "
	CQUERY	+= "   AND E5_NUMERO BETWEEN '" + AllTrim(MV_PAR03) + "' AND '" + AllTrim(MV_PAR04) + "' "
	CQUERY	+= "   AND E5_SERREC BETWEEN '" + AllTrim(MV_PAR05) + "' AND '" + AllTrim(MV_PAR06) + "' "
	CQUERY	+= "   AND E5_LOTE <>'' "
	CQUERY	+= "   AND E5_RECPAG='R' "
	CQUERY	+= "   AND E5_NUMCHEQ BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
	CQUERY	+= "   AND LEFT(E5_DOCUMEN,6) BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' "
	CQUERY	+= "   AND E5_LA = 'S' "
	CQUERY	+= "   AND D_E_L_E_T_ <> '*' " 
	CQUERY	+= "   UNION ALL "
	CQUERY	+= "SELECT R_E_C_N_O_ REC, "
	CQUERY	+= "   * "
	CQUERY	+= "FROM "
	CQUERY	+= "   " + RETSQLNAME("SE5") 
	CQUERY	+= " WHERE "
	CQUERY	+= "   E5_FILIAL = '" + XFILIAL("SE5") + "' "
	CQUERY	+= "   AND E5_DATA   BETWEEN '" + DTOS(MV_PAR01)    + "' AND '" + DTOS(MV_PAR02)    + "' "
	CQUERY	+= "   AND E5_NUMERO BETWEEN '" + AllTrim(MV_PAR03) + "' AND '" + AllTrim(MV_PAR04) + "' "
	CQUERY	+= "   AND E5_SERREC BETWEEN '" + AllTrim(MV_PAR05) + "' AND '" + AllTrim(MV_PAR06) + "' "
	CQUERY	+= "   AND E5_MOTBX='CEC' "
	CQUERY	+= "   AND E5_NUMCHEQ BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
	CQUERY	+= "   AND LEFT(E5_DOCUMEN,6) BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' "
	CQUERY	+= "   AND E5_LA = 'S' "
	CQUERY	+= "   AND D_E_L_E_T_ <> '*' "



ENDIF

CQUERY	:= CHANGEQUERY(CQUERY)

DBUSEAREA(.T., "TOPCONN", TCGENQRY(,,CQUERY),"TE5",.F., .T.)

DBSELECTAREA("TE5")
DBGOTOP()
WHILE !EOF()
	DBSELECTAREA(cAliasBrw)
	
	WHILE !RECLOCK(cAliasBrw,.T.); ENDDO
	IF MV_PAR08==1
		REPLACE E2_HIST	WITH TE5->E2_HIST
		REPLACE E2_VALOR	WITH TE5->E2_VALOR
		REPLACE E2_EMIS1	WITH STOD(TE5->E2_EMIS1)
		REPLACE E2_TIPO 	WITH TE5->E2_TIPO
		REPLACE E2_PREFIXO 	WITH TE5->E2_PREFIXO
		REPLACE E2_NUM 		WITH TE5->E2_NUM
		REPLACE E2_PARCELA 	WITH TE5->E2_PARCELA
		REPLACE E2_REC 		WITH TE5->REC
		
	ELSEIF MV_PAR08==2
		REPLACE E1_HIST		WITH TE5->E1_HIST
		REPLACE E1_VALOR	WITH TE5->E1_VALOR
		REPLACE E1_EMISSAO	WITH STOD(TE5->E1_EMISSAO)
		REPLACE E1_TIPO 	WITH TE5->E1_TIPO
		REPLACE E1_PREFIXO 	WITH TE5->E1_PREFIXO
		REPLACE E1_NUM 		WITH TE5->E1_NUM
		REPLACE E1_PARCELA 	WITH TE5->E1_PARCELA
		REPLACE E1_REC 		WITH TE5->REC
	
	ELSEIF MV_PAR08==3
		REPLACE EF_BANCO	WITH TE5->EF_BANCO
		REPLACE EF_AGENCIA	WITH TE5->EF_AGENCIA
		REPLACE EF_CONTA    WITH TE5->EF_CONTA
		REPLACE EF_HISTOR	WITH TE5->EF_HIST
		REPLACE EF_VALOR	WITH TE5->EF_VALOR
		REPLACE EF_DATA		WITH STOD(TE5->EF_DATA)
		REPLACE EF_NUM		WITH TE5->EF_NUM
		REPLACE EF_PREFIXO 	WITH TE5->EF_PREFIXO
		REPLACE EF_TITULO 	WITH TE5->EF_TITULO
		REPLACE EF_PARCELA 	WITH TE5->EF_PARCELA
		REPLACE EF_REC	 	WITH TE5->REC

	ELSE
		REPLACE E5_BANCO	WITH TE5->E5_BANCO
		REPLACE E5_AGENCIA	WITH TE5->E5_AGENCIA
		REPLACE E5_CONTA    WITH TE5->E5_CONTA
		REPLACE E5_HISTOR	WITH TE5->E5_HISTOR
		REPLACE E5_VALOR	WITH TE5->E5_VALOR
		REPLACE E5_DATA		WITH STOD(TE5->E5_DATA)
		REPLACE E5_DOCUMEN	WITH TE5->E5_DOCUMEN
		REPLACE E5_REC	 	WITH TE5->REC
		REPLACE E5_PREFIXO 	WITH TE5->E5_PREFIXO
		REPLACE E5_NUMERO 	WITH TE5->E5_NUMERO
		REPLACE E5_PARCELA 	WITH TE5->E5_PARCELA
	ENDIF
	MSUNLOCK()
	DBSELECTAREA("TE5")
	DBSKIP()
ENDDO

DBSELECTAREA(cAliasBrw)
DBGOTOP()

DEFINE MSDIALOG ODLG TITLE "Seleção de Titulos no Financeiro  -  " + IIF(MV_PAR07 == 1,"Inibir Contabilização","Liberar Contabilização") FROM 00,00 TO 520,990 PIXEL
OMARK := MSSELECT():NEW(cAliasBrw, "E5_LA", ,ACAMPOS2 ,.F. ,CMARCA ,{032 ,003 ,240 ,480 } , , , )
OMARK:OBROWSE:REFRESH()
OMARK:OBROWSE:LHASMARK    := .T.
OMARK:OBROWSE:LCANALLMARK := .F.
oMARK:oBROWSE:bALLMARK := {|| U_MALLBrw(cMarca,lInverte,.T.)}

ACTIVATE MSDIALOG ODLG CENTER ON INIT ENCHOICEBAR(ODLG,BOK,BCANCEL,,)

IF NOPC == 1
	PROCESSA({|LEND|CTB004MIS()})
ENDIF

DBSELECTAREA(cAliasBrw)
DBCLOSEAREA(cAliasBrw)
//---------------------------------
//Exclui a tabela
//---------------------------------
oTempTable:Delete() 

DBSELECTAREA("TE5")
DBCLOSEAREA("TE5")

RETURN NIL


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³IvMcBrw³ Autor ³Denis Hyroshi de Souza ³ Data ³ 25/07/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Inverte a marcacao do browse                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

//==============================================
User Function MALLBrw(cMarca,lInverte,lAll)
//==============================================

Local aArea := GetArea()

If lAll
	Dbselectarea("FINTEMP")
	Dbgotop()
	While !eof()
		RECLOCK("FINTEMP",.F.)
		E5_LA := IF(E5_LA == "  ",cMARCA,"  ")
		MSUNLOCK()
		Dbskip()
	End
Endif

RestArea(aArea)
Return .t.



STATIC FUNCTION CTB004MIS()
LOCAL AAREA := GETAREA()
DBSELECTAREA("FINTEMP")
FINTEMP->(DBGOTOP())

WHILE FINTEMP->(!EOF())
	IF FINTEMP->E5_LA != CMARCA
		FINTEMP->(DBSKIP())
		LOOP
	ENDIF
	_cSql :=""
				// LIMPA FLAG CONTAS A PAGAR
				_cSql := " UPDATE "+RETSQLNAME("SE2")+" SET E2_LA='' "
				_cSql += " WHERE D_E_L_E_T_='' AND E2_LA='S' "
				_cSql += " AND E2_EMIS1 BETWEEN '" + DTOS(MV_PAR01)    + "' AND '" + DTOS(MV_PAR02)    + "' "
				TCSQLEXEC(_cSql)             
	_cSql :=""			
				// LIMPA FLAG MOVIMENTOS BANCARIOS
				_cSql := " UPDATE "+RETSQLNAME("SE5")+" SET E5_LA='' "
				_cSql += " WHERE D_E_L_E_T_='' AND E5_LA='S' "
				_cSql += " AND E5_DATA BETWEEN '" + DTOS(MV_PAR01)    + "' AND '" + DTOS(MV_PAR02)    + "' "
				TCSQLEXEC(_cSql) 
	_cSql :=""
				// LIMPA FLAG CHEQUES
				_cSql := " UPDATE "+RETSQLNAME("SEF")+" SET EF_LA='' "
				_cSql += " WHERE D_E_L_E_T_='' AND EF_LA='S' "
				_cSql += " AND EF_DATA BETWEEN '" + DTOS(MV_PAR01)    + "' AND '" + DTOS(MV_PAR02)    + "' "
				TCSQLEXEC(_cSql) 	
	_cSql :=""
				// LIMPA FLAG CONTAS A RECEBER
				_cSql := " UPDATE "+RETSQLNAME("SE1")+" SET E1_LA='' "
				_cSql += " WHERE D_E_L_E_T_='' AND E1_LA='S' "
				_cSql += " AND E1_EMIS1 BETWEEN '" + DTOS(MV_PAR01)    + "' AND '" + DTOS(MV_PAR02)    + "' "
				TCSQLEXEC(_cSql) 		
	_cSql :=""
				// LIMPA FLAG MOVIMENTOS CAIXINHAS
				_cSql := " UPDATE "+RETSQLNAME("SEU")+" SET EU_LA='' "
				_cSql += " WHERE D_E_L_E_T_='' AND EU_LA='S' "
				_cSql += " AND EU_BAIXA BETWEEN '" + DTOS(MV_PAR01)    + "' AND '" + DTOS(MV_PAR02)    + "' "
				TCSQLEXEC(_cSql) 		 


		//  	ENDIF
	FINTEMP->(DBSKIP())
ENDDO

RESTAREA(AAREA)
RETURN(.T.)
