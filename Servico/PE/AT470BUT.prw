/*/
    Adiciona bot�o de impress�o de OS customizada na requisi��o de materia ao armaz�m.
/*/
User Function AT470BUT()
Local aBotao := {}

AAdd( aBotao, { "PRODUTO", { || U_REQUIOS() }, "Imp. Requisicao." } )
AAdd( aBotao, { "PRODUTO", { || U_VALOROS() }, "Imp. Valores Requis." } )

Return( aBotao ) 
