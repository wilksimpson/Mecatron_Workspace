#INCLUDE "LOJR860.ch"
#INCLUDE "Protheus.ch"

#DEFINE CTRL Chr(10)           	//Pula linha

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³ Fun‡…o   ³ LOJR860     ³ Autor ³ Vendas Clientes    ³ Data ³ 29/04/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Relatorio de Nota de Credito                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExR1 - Nil                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Uso      ³ Sigaloja                                                   ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/              
User Function LOJR860()

Local aArea    	:= GetArea()		// Backup da Area
Local aDocDev	:= Paramixb[1]   	// Documento de Devolução
Local aRecSD2	:= Paramixb[2]    	// Recnos de D2
Local aDadosNCC := Paramixb[3]		// Dados de NCC
Local aRecSD1   := Iif( Len(Paramixb) >= 4 ,Paramixb[4], {} )      // Recnos de D1
Local lContinua	:= .T.

If Len(aDocDev) == 0 
	lContinua := .F.
EndIf

If lContinua
/*

	SetPrvt('oPrint')
	oPrint:= TMSPrinter():New(STR0004)   //"Nota de Crédito"
	oPrint:SetPortrait()
	
	oFontCN08  := TFont():New("Arial", 09, 09, .F., .F., , , , .F., .F.)
	oFontCN08N := TFont():New("Arial", 09, 09, .F., .T., , , , .F., .F.)
	oFontCN11N := TFont():New("Arial", 11, 11, .F., .T., , , , .F., .F.)
	oFontCN12  := TFont():New("Arial", 12, 12, .F., .F., , , , .F., .F.)
	oFontCN12N := TFont():New("Arial", 12, 12, .F., .T., , , , .F., .F.)
	
	oFont26N := TFont():New("Tahoma", 26, 26, .F., .T., , , , .F., .F.)
	
	MsgRun(STR0005,"",{|| CursorWait(), Lj850Print(oPrint,aDocDev,aRecSD2,aDadosNCC,aRecSD1),CursorArrow()}) //"Gerando Visualização, Aguarde..."
	
	oPrint:Preview()  // Visualiza antes de imprimir
*/	
	U_ROrcNCC(aDocDev,aRecSD2,aDadosNCC,aRecSD1)
	//U_ROrcNCC(aDocDev,aRecSD2,aDadosNCC,aRecSD1)

	RestArea(aArea)
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Funcao    ³Lj850Print³ Autor ³TOTVS                   ³ Data ³ 08/03/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Imprime e gera a visualizacao do relatorio                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³SIGALOJA                                                       ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Lj850Print(oPrint,aDocDev,aRecSD2,aDadosNCC,aRecSD1)

//Local nX	  := 0 		// Contador
Local nLin	  := 0		// Numero da Linha
Local cPrefixo:= ""		//Prefixo do titulo

Default oPrint   := Nil
Default aDocDev  := {}
Default aRecSD2  := {}
Default aDadosNCC:= {}
Default aRecSD1  := {} //Registros da Nota de devolução, quando selecionado sem documento de origem

If Len(aDadosNCC) > 0
	cPrefixo := aDadosNCC[1]
Else
	cPrefixo := aDocDev[1]
EndIf

SE1->( DbSetOrder( 2 ) )
If SE1->( DbSeek( xFilial("SE1") + aDocDev[3] + aDocDev[4] + cPrefixo + aDocDev[2]  ) )

	While SE1->(!Eof()) .AND. xFilial("SE1")		== SE1->E1_FILIAL 	.AND. ;
								SE1->E1_CLIENTE		== aDocDev[3] 		.AND. ;
								SE1->E1_LOJA		== aDocDev[4]		.AND. ;
								SE1->E1_PREFIXO		== cPrefixo		.AND. ;
								SE1->E1_NUM			== aDocDev[2] 
									
	   	If !( SE1->E1_SITUACA $ "27" .OR. SE1->E1_SALDO == 0 )
		
     		If ( SE1->E1_TIPO $ MV_CRNEG )

				oPrint:StartPage() // Inicia uma nova página
                NLIN:=20
			    oPrint:Say(nLin,180,"MECATRON ",oFontCN12)
                NLIN+=70
			    oPrint:Say(nLin,140,"NOTA DE CREDITO DE CLIENTE ",oFontCN08)
                NLIN+=70
			    oPrint:Say(nLin,20,"NOTA FISCAL DEVOLUCAO "+aDocDev[2]+" Serie "+cPrefixo,oFontCN08)
                NLIN+=50
                oPrint:LINE(nLin,0,nLin,1000)

				SA1->(DbSetOrder(1))
				If SA1->(DbSeek(xFilial("SA1")+aDocDev[3]+aDocDev[4] ))
                    NLIN+=40
                    oPrint:Say(nLin,20,"Declaramos que o cliente ",oFontCN08)
                    NLIN+=40
                    oPrint:Say(nLin,20,Alltrim(SA1->A1_NOME),oFontCN08)
                    NLIN+=40
                    oPrint:Say(nLin,20,"Possui um credito no valor de ",oFontCN08)
                    NLIN+=40
                    oPrint:Say(nLin,20,"R$ "+ALLTRIM(Transform(SE1->E1_SALDO,PesqPict("SE1","E1_SALDO"))),oFontCN08)
                    NLIN+=40
                    oPrint:Say(nLin,20,"("+Extenso(SE1->E1_SALDO)+")",oFontCN08)
                    NLIN+=40
                    oPrint:Say(nLin,20,"Referente a devolucao de venda ",oFontCN08)
                    NLIN+=150
                    oPrint:Say(nLin,20,"_______________________________",oFontCN12N)
                    NLIN+=60
                    oPrint:Say(nLin,120,"MECATRON em "+DTOC(dDataBase),oFontCN08)
                                    
				Endif	
				
				oPrint:EndPage()   // Finaliza a página	
     		Endif	
		Endif
		SE1->(DbSkip())
	End

Endif	

Return
