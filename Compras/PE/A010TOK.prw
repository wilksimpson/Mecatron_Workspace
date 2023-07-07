//Bibliotecas
#Include "Protheus.ch"
#INCLUDE 'FWMVCDEF.CH'
 
/*------------------------------------------------------------------------------------------------------*
 | P.E.:  A010TOK                                                                                       |
 | Desc:  Confirma��o do cadastro de produtos                                                           |
 | Link:  http://tdn.totvs.com/pages/releaseview.action�pageId=6087477                                  |
 *------------------------------------------------------------------------------------------------------*/
 // NECESS�RIO AJUSTAR O PARAMETRO MV_CADPRO E INCLUIR O ALIAS SB0 PARA QUE SEJA POSICIONADO NA SB0 E VALIDAR A TROCA DE PRE�OS DO LOJA.

User Function A010TOK()
    Local aArea := GetArea()
    Local aAreaB1 := SB1->(GetArea())
    Local lRet := .T.
    Local oModelx := FWModelActive()

    
     
    //Se for inclus�o
    If INCLUI
        IF M->B0_PRV1 > 0

            //B1_PRV1 := M->B0_PRV1 // SETANDO VALOR DIGITADO NO LOJA PARA O CAMPO PRINCIPAL DO PRODUTO
            oModelx:SetValue('SB1MASTER','B1_PRV1'    ,M->B0_PRV1  )

            DbSelectArea("ZZ6")
			RECLOCK("ZZ6",.T.)
			ZZ6->ZZ6_FILIAL	 := XFILIAL("ZZ6")
			ZZ6->ZZ6_PRODUTO := M->B1_COD
			ZZ6->ZZ6_PRECO   := M->B0_PRV1
			ZZ6->ZZ6_DATA    := DDATABASE
			ZZ6->ZZ6_ORIGEM  := "Inclus�o de Produto"
			ZZ6->ZZ6_USUARI  := UsrRetName(RetCodUsr())
			ZZ6->(MSUNLOCK())
        ENDIF
    EndIf
     
    //Se for altera��o
    If ALTERA
            IF M->B0_PRV1 <> SB0->B0_PRV1

           // B1_PRV1 := M->B0_PRV1 // SETANDO VALOR DIGITADO NO LOJA PARA O CAMPO PRINCIPAL DO PRODUTO
           // B1_DTREFP1 := DDATABASE
            oModelx:SetValue('SB1MASTER','B1_PRV1'    ,M->B0_PRV1  )
            oModelx:SetValue('SB1MASTER','B1_DTREFP1'    ,DDATABASE )

            DbSelectArea("ZZ6")
			RECLOCK("ZZ6",.T.)
			ZZ6->ZZ6_FILIAL	 := XFILIAL("ZZ6")
			ZZ6->ZZ6_PRODUTO := M->B1_COD
			ZZ6->ZZ6_PRECO   := M->B0_PRV1
			ZZ6->ZZ6_DATA    := DDATABASE
			ZZ6->ZZ6_ORIGEM  := "Altera��o Manual do Produto"
			ZZ6->ZZ6_USUARI  := UsrRetName(RetCodUsr())
			ZZ6->(MSUNLOCK())
        ENDIF
    EndIf
     
    /*/Se for c�pia
    If lCopia
        MsgInfo("Estou em uma <b>c�pia</b>!", "Aten��o")
    EndIf 
    /*/
     
   // lRet := MsgYesNo("Deseja continuar�", "Aten��o")
     
    RestArea(aAreaB1)
    RestArea(aArea)
Return lRet
