#INCLUDE "rwmake.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LJ7032    º Autor ³Jose Carlos A Dias Fº Data ³  15/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Conforme a Indentificacao do Usuario Verifica se o mesmo e º±±
±±º          ³ Vendedor caso COntratio traz o Vendedor Padrao             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function LJ7032()
//Para Funcionar Automatico
//Campo: LQ_VEND
//X3_RELACAO = POSICIONE("SA3",7,xFilial("SA3")+__CUSERID,"A3_COD")
//X3_RELACAO = Iif(CMODULO='LOJ',CVENDPAD,Space(TAMSX3("LQ_VEND")[1]))
//X3_WHEN = iif(CMODULO='LOJ',lAltVend,.T.)
Local _lRet := .T.
Local _aArea := GetArea()
Local _NOPC := PARAMIXB[1]
//Local _cUsrVnd := GetMv("AB_USRPED")
PUBLIC cVendPad := SL1->L1_VEND
PUBLIC lAltVend := .F.



IF _NOPC= 3
	DbSelectArea("SA3")
	SA3->(DbSetOrder(7)) //A3_FILIAL, A3_CODUSR
	SA3->(DbGotop())
	If DbSeek(xFilial("SA3")+__CUSERID)
		cVendPad := SA3->A3_COD
		If UPPER(SA3->A3_TIPSUP) = 'SIM'
			lAltVend := .T.
		Endif
		//Else
		//cVendPad  := SuperGetMV( "MV_VENDPAD" )
	Endif
Endif


RestArea(_aArea)
Return(_lRet)

User Function FTVD7032() 
Return U_LJ7032()


User Function VendUsu() //inserir no iniclializador do campo
//Para Funcionar Automatico
Local _lRet := .T.
Local _aArea := GetArea()
//Local _NOPC := PARAMIXB[1]
//Local _cUsrVnd := GetMv("AB_USRPED")
PUBLIC cVendPad := SuperGetMV( "MV_VENDPAD" )
PUBLIC lAltVend := .F.
//IF _NOPC= 3
	DbSelectArea("SA3")
	SA3->(DbSetOrder(7)) //A3_FILIAL, A3_CODUSR
	SA3->(DbGotop())
	If DbSeek(xFilial("SA3")+__CUSERID)
		cVendPad := SA3->A3_COD
//		If UPPER(SA3->A3_TIPSUP) = 'SIM'
			lAltVend := .T.
//		Endif
		//Else
		//cVendPad  := SuperGetMV( "MV_VENDPAD" )
	Endif
//Endif

//	LQ_VEND := cVendPad


RestArea(_aArea)
Return(cVendPad)


