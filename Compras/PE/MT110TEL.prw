#Include "Protheus.ch"

/*
Autor: Wilk Lima
Objetivo: Criar campos no cabeçalho para ótimizar lançamento na solicitação de compras.
Obs.: Criar Gatilhos do campo produto para os campos:
         C1_LOCAL, Passando como regra: _cArmzem, na condição incluir a verificação: TYPE("_cArmzem")<>"U"            
         C1_CC, Passando como regra: _CCUSTO, na condição incluir a verificação: TYPE("_CCUSTO")<>"U"                    
         C1_DATPRF, Passando como regra: _DNECESS, na condição incluir a verificação: TYPE("_DNECESS")<>"U"            
*/
User Function MT110TEL()

    Local oGet01
    Local oGet02
    Local oGet03
    Local aScreenRes := getScreenRes()
//Local oGet05

    Local oNewDialog := PARAMIXB[1]
    Local aPosGet := PARAMIXB[2]
    Local nOpcX := PARAMIXB[3]
//Local nReg := PARAMIXB[4]

    Public _cArmzem := "  "     // Retorna o e-mail do solicitante.
    Public _cCusto  := "         "    // Retorna o e-mail do comprador.
    Public _dNecess := DATE()   // Retorna o e-mail 1º e-mail alternativo.
//Public cEmail04     := SC1->C1_XEMAIL3     // Retorna o e-mail 2º e-mail alternativo.
//Public cObserv     := SC1->C1_XOBS     // Campo observação.

    IF nOpcx == 3 // Inclusão

        aadd(aPosGet[1],0)
        aadd(aPosGet[1],0)

//Monta os campos.
        if aScreenRes[1]>=1920 

        @ 34,153 Say 'C. Custo' Pixel Size 40,11 Of oNewDialog
        @ 34,188 MSGET oGet02 Var _cCusto Size 052, 011 Picture '@A' Pixel F3 "CTT" VALID Vazio(M->C1_CC) .Or. (Ctb105CC() .And. MTPVLSOLEC()) Of oNewDialog When .T. Pixel

        @ 49,153 Say 'Local Estoque' Pixel Size 40,9 Of oNewDialog
        @ 49,188 MSGET oGet01 Var _cArmzem Size 032, 011 Picture '@A' Pixel F3 "NNR" VALID ExistCpo("NNR") Of oNewDialog When .T. Pixel

        @ 34,0530 Say 'Necessidade' Pixel Size 40,9 Of oNewDialog
        @ 34,0575 MSGET oGet03 Var _dNecess Size 052, 011 Picture '@A' Of oNewDialog When .T. Pixel

        else

        @ 34,123 Say 'C. Custo' Pixel Size 40,11 Of oNewDialog
        @ 34,158 MSGET oGet02 Var _cCusto Size 052, 011 Picture '@A' Pixel F3 "CTT" VALID Vazio(M->C1_CC) .Or. (Ctb105CC() .And. MTPVLSOLEC()) Of oNewDialog When .T. Pixel
        
        @ 49,120 Say 'Local Estoque' Pixel Size 40,9 Of oNewDialog
        @ 49,158 MSGET oGet01 Var _cArmzem Size 032, 011 Picture '@A' Pixel F3 "NNR" VALID ExistCpo("NNR") Of oNewDialog When .T. Pixel

        @ 49,340 Say 'Necessidade' Pixel Size 40,9 Of oNewDialog
        @ 49,375 MSGET oGet03 Var _dNecess Size 052, 011 Picture '@A' Of oNewDialog When .T. Pixel
        
        endif
    ELSE

        _cArmzem := SC1->C1_LOCAL
        _cCusto := SC1->C1_CC
        _dNecess := SC1->C1_DATPRF

        aadd(aPosGet[1],0)
        aadd(aPosGet[1],0)

//Monta os campos.

        if aScreenRes[1]>=1920 

        @ 34,153 Say 'C. Custo' Pixel Size 40,11 Of oNewDialog
        @ 34,188 MSGET oGet02 Var _cCusto Size 052, 011 Picture '@A' Pixel F3 "CTT" VALID Vazio(M->C1_CC) .Or. (Ctb105CC() .And. MTPVLSOLEC()) Of oNewDialog When .F. Pixel

        @ 49,153 Say 'Local Estoque' Pixel Size 40,9 Of oNewDialog
        @ 49,188 MSGET oGet01 Var _cArmzem Size 032, 011 Picture '@A' Pixel F3 "NNR" VALID ExistCpo("NNR") Of oNewDialog When .F. Pixel

        @ 34,0530 Say 'Necessidade' Pixel Size 40,9 Of oNewDialog
        @ 34,0575 MSGET oGet03 Var _dNecess Size 052, 011 Picture '@A' Of oNewDialog When .F. Pixel

        else

        @ 34,123 Say 'C. Custo' Pixel Size 40,11 Of oNewDialog
        @ 34,158 MSGET oGet02 Var _cCusto Size 052, 011 Picture '@A' Pixel F3 "CTT" VALID Vazio(M->C1_CC) .Or. (Ctb105CC() .And. MTPVLSOLEC()) Of oNewDialog When .F. Pixel
        
        @ 49,120 Say 'Local Estoque' Pixel Size 40,9 Of oNewDialog
        @ 49,158 MSGET oGet01 Var _cArmzem Size 032, 011 Picture '@A' Pixel F3 "NNR" VALID ExistCpo("NNR") Of oNewDialog When .F. Pixel

        @ 49,340 Say 'Necessidade' Pixel Size 40,9 Of oNewDialog
        @ 49,375 MSGET oGet03 Var _dNecess Size 052, 011 Picture '@A' Of oNewDialog When .F. Pixel
        
        endif
    ENDIF

//Fim do programa

Return
