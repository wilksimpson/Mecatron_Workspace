/*/
    Adiciona bot�o de impress�o de OS customizada na ordem de servi�os do gest�o de servi�os.
/*/
User Function AT700BUT()
Local aBotao := {}

AAdd( aBotao, { "RELATORIO", { || U_IMPPROJ() }, "Imp. Projeto" } )

Return( aBotao ) 


