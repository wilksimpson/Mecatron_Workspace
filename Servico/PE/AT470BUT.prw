/*/
    Adiciona botão de impressão de OS customizada na requisição de materia ao armazém.
/*/
User Function AT470BUT()
Local aBotao := {}

AAdd( aBotao, { "PRODUTO", { || U_REQUIOS() }, "Imp. Requisicao." } )
AAdd( aBotao, { "PRODUTO", { || U_VALOROS() }, "Imp. Valores Requis." } )

Return( aBotao ) 
