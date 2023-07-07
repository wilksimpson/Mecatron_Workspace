#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.ch"
#INCLUDE "RPTDEF.CH"
#include "TOPCONN.CH"

/*/ 
    USER FUNCTION ROrcNCC
    DescriÁ„o: Impress„o Gr·fica de NCC Loja, Compras.
    Autor: Wilk Lima
    Data 11/04/2022
/*/

User Function ROrcNCC(aDocDev,aRecSD2,aDadosNCC,aRecSD1)
 
Local lAdjustToLegacy := .F.
Local lDisableSetup  := .T.
Local oPrinter
Local cLocal          := "\spool"
Local i := 0
Local nLin := 0
Local nLin2 := 0

oFont  := TFont():New("Courier New",,6,,.T. /*NEGRITO*/,,,,.T.,)	//85 caracteres por linha
oFont1 := TFont():New("Courier New",,10,,.T. /*NEGRITO*/,,,,.T.,)	//99 caracteres por linha
oFont2 := TFont():New("Courier New",,6,,.T. /*NEGRITO*/,,,,,)
oFont3 := TFont():New("Courier New",,8,,.T. /*NEGRITO*/,,,,.T.,)
oFont4 := TFont():New("Courier New",,18,,.T. /*NEGRITO*/,,,,.T.,)	//85 caracteres por linha
oFont5 := TFont():New("Courier New",,15,,.T. /*NEGRITO*/,,,,.T.,)


cImp := "IMP_SEP"+alltrim(XFILIAL("SL1"))

//oPrinter := FWMSPrinter():New("exemplo.rel", IMP_SPOOL, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
oPrinter := FWMSPrinter():New("garantia.rel", IMP_SPOOL, lAdjustToLegacy,cLocal, lDisableSetup, , ,cImp , , , .F., )
oPrinter:Setup()


IF oPrinter:nModalResult == PD_OK
    oPrinter:setresolution(82)
   // oPrinter:StartPage()
    oPrinter:setpapersize(8)
    oPrinter:SetMargin(0,0,0,0) // nEsquerda, nSuperior, nDireita, nInferior


    SE1->( DbSetOrder( 2 ) )
    If SE1->( DbSeek( xFilial("SE1") + aDocDev[3] + aDocDev[4] + aDocDev[1] + aDocDev[2]  ) )
/*
        While SE1->(!Eof()) .AND. xFilial("SE1")		== SE1->E1_FILIAL 	.AND. ;
                                    SE1->E1_CLIENTE		== aDocDev[3] 		.AND. ;
                                    SE1->E1_LOJA		== aDocDev[4]		.AND. ;
                                    SE1->E1_PREFIXO		== aDocDev[1]		.AND. ;
                                    SE1->E1_NUM			== aDocDev[2] 
 */                                       
            If !( SE1->E1_SITUACA $ "27" .OR. SE1->E1_SALDO == 0 )
            
                If ( SE1->E1_TIPO $ MV_CRNEG )

                    oPrinter:StartPage()
                    cLogo := "\imagens\mecatron.jpg"

                    oPrinter:SayBitmap(020,060,cLogo,100,060)
                    NLIN:=50
                    NLIN+=50
                    oPrinter:Say(nLin,40,"NOTA DE CREDITO DE CLIENTE ",oFont3)
                    NLIN+=30
                    oPrinter:Say(nLin,10,"NOTA FISCAL DEVOLUCAO "+aDocDev[2]+" Serie "+aDocDev[1],oFont3)
                    NLIN+=30
                    oPrinter:LINE(nLin,0,nLin,1000)

                    SA1->(DbSetOrder(1))
                    If SA1->(DbSeek(xFilial("SA1")+aDocDev[3]+aDocDev[4] ))
                        NLIN+=20
                        oPrinter:Say(nLin,10,"Declaramos que o cliente ",oFont1)
                        NLIN+=20
                        nLin2 := mlcount(SA1->A1_NOME,40)                          
                        For i := 1 to nLin2
                            oPrinter:Say(nLin,10,memoline(Alltrim(SA1->A1_NOME),40,i) ,oFont3)
                            NLIN+=20
                        Next

                        oPrinter:Say(nLin,10,"Possui um credito no valor de ",oFont1)
                        NLIN+=30
                        oPrinter:Say(nLin,10,"R$ "+ALLTRIM(Transform(SE1->E1_SALDO,PesqPict("SE1","E1_SALDO"))),oFont1)
                        NLIN+=30
                        _cValExt := "("+Extenso(SE1->E1_SALDO)+")"

                       nLin2 := mlcount(_cValExt,40)                          
                        For i := 1 to nLin2
                            oPrinter:Say(nLin,10,memoline(Alltrim(_cValExt),40,i) ,oFont3)
                            NLIN+=20
                        Next

 //                       NLIN+=30
                        oPrinter:Say(nLin,10,"Referente a devolucao de venda ",oFont1)
                        NLIN+=100
                        oPrinter:Say(nLin,10,"_______________________________",oFont5)
                        NLIN+=40
                        oPrinter:Say(nLin,40,"MECATRON em "+DTOC(dDataBase),oFont3)
                                        
                    Endif	
                    

                Endif	
            Endif
   //         SE1->(DbSkip())
   //     End

    Endif	

    oPrinter:EndPage()   // Finaliza a p√°gina	
    oPrinter:Print()

   endif
Return
