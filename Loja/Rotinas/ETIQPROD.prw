#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
#Include 'TopConn.ch'
User Function ETIQPROD()
 
    If ValidPerg()
        MsAguarde({|| ImpEtiq() },"Impressaoo de etiqueta","Aguarde...")
    EndIf

Return

Static Function ImpEtiq(nTipo)
    Local cQuery    := ""
    Local cImpress  := "Etiqueta" //pego o nome da impressora
    Local oFont    := TFont():New('Arial',18,18,,.F.,,,,.T.,.F.,.F.)
    Local lAdjustToLegacy     := .F.
    Local lDisableSetup      := .T.
    Local nLin        := 0
    Local nCol        := 0
    Local nLinC        := 0
    Local nColC        := 0
    Local nWidth    := 0
    Local nHeigth   := 0
    Local lBanner    := .T.        //Se imprime a linha com o cÃ³digo embaixo da barra. Default .T.
    Local nPFWidth    := 0
    Local nPFHeigth    := 0
    Local lCmtr2Pix    := .T.        //Utiliza o mÃ©todo Cmtr2Pix() do objeto Printer.Default .T.
    Local nLin2 := 0
    Local nX := 0    
    MsProcTxt("Identificando a impressora...")
    Private oPrinter := FWMSPrinter():New("produto"+Alltrim(__cUserID)+".etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cImpress) /*parametro que recebe a impressora*/)

    oPrinter:Setup()

   	IF oPrinter:nModalResult == PD_OK        
       cQuery := "SELECT B1_COD AS CODIGO,B1_REFER,B1_DESC AS DESCRI,B1_CODBAR AS CODBAR FROM "+RetSqlName("SB1")+" WHERE B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
                
        TcQuery cQuery New Alias "QRYTMP"
        QRYTMP->(DbGoTop())
        oPrinter:SetMargin(001,001,001,001)
        While QRYTMP->(!Eof())
                nLin := 10
                nCol := 22
                nCol2 := 170
                MsProcTxt("Imprimindo "+alltrim(QRYTMP->CODIGO) + " - " + alltrim(QRYTMP->DESCRI)+"...")
                oPrinter:StartPage()
                nLin+= 05
                nLin2 := mlcount(ALLTRIM(QRYTMP->DESCRI),40)
                For nX := 1 to nLin2
                    oPrinter:Say(nLin,nCol,memoline(Alltrim(QRYTMP->DESCRI),40,nX) ,oFont)
                    nLin+= 15
                Next
                
                oPrinter:Say(nLin,nCol,"Codigo: "+alltrim(QRYTMP->CODIGO),oFont)
//                oPrinter:Say(nLin,nCol2,"Produto "+alltrim(QRYTMP->CODIGO),oFont)

                nLinC        := 4.95+nLin2        //Linha que serÃ¡ impresso o CÃ³digo de Barra
                nColC        := 2        //Coluna que serÃ¡ impresso o CÃ³digo de Barra
                nWidth         := 0.048    //Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta Ã© 0.0164
                nHeigth       := 0.6        //Numero da Altura da barra. Default 1.5 --- limite de altura Ã© 0.3
                lBanner        := .T.        //Se imprime a linha com o cÃ³digo embaixo da barra. Default .T.
                nPFWidth    := 0.5        //NÃºmero do Ã­ndice de ajuste da largura da fonte. Default 1
                nPFHeigth    := 0.9        //NÃºmero do Ã­ndice de ajuste da altura da fonte. Default 1
                lCmtr2Pix    := .T.        //Utiliza o mÃ©todo Cmtr2Pix() do objeto Printer.Default .T.
                oPrinter:FWMSBAR("CODE128" , nLinC , nColC, alltrim(QRYTMP->CODIGO), oPrinter,/*lCheck*/,/*Color*/,/*lHorz*/, nWidth, nHeigth,.F.,/*cFont*/,/*cMode*/,.F./*lPrint*/,nPFWidth,nPFHeigth,lCmtr2Pix)
//                oPrinter:FWMSBAR("CODE128" , nLinC , nColC+14, alltrim(QRYTMP->CODIGO), oPrinter,/*lCheck*/,/*Color*/,/*lHorz*/, nWidth, nHeigth,.F.,/*cFont*/,/*cMode*/,.F./*lPrint*/,nPFWidth,nPFHeigth,lCmtr2Pix)

                nLin+= 15
                oPrinter:Say(nLin,nCol,"Referencia: "+alltrim(QRYTMP->B1_REFER),oFont)
//                oPrinter:Say(nLin,nCol2,"Referencia:"+alltrim(QRYTMP->B1_REFER),oFont)

                nLin+= 15
                oPrinter:Say(nLin,nCol,"Emissao: " + DTOC(dDataBase)+" "+time(),oFont)
//                oPrinter:Say(nLin,nCol2,"Emissao:" + DTOC(dDataBase)+" "+time(),oFont)
            
                oPrinter:EndPage()
            QRYTMP->(DbSkip())
        EndDo
        oPrinter:Print()
    ENDIF
    QRYTMP->(DbCloseArea())
Return

Static Function ValidPerg()
    Local aParamBox    := {}
    Local lRet         := .F.

        aAdd(aParamBox,{01,"Produto de"                  ,SPACE(15)     ,""                    ,"","SB1"    ,"", 60,.F.})    // MV_PAR01
        aAdd(aParamBox,{01,"Produto ate"               ,SPACE(15)    ,""                    ,"","SB1"    ,"", 60,.T.})    // MV_PAR02    
    If ParamBox(aParamBox,"Etiqueta Produto",/*aRet*/,/*bOk*/,/*aButtons*/,.T.,,,,FUNNAME(),.T.,.T.)
        lRet := .T.
    EndIf
Return lRet
