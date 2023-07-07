/*/
    Adiciona botão de impressão de OS customizada na ordem de serviços do gestão de serviços.
/*/
User Function AT700BUT()
Local aBotao := {}

AAdd( aBotao, { "RELATORIO", { || U_IMPPROJ() }, "Imp. Projeto" } )

Return( aBotao ) 


