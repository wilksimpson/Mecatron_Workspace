#INCLUDE "PROTHEUS.CH" 
#INCLUDE "RWMAKE.CH" 

/*/{Protheus.doc} F040CPO
    (permite alterar campos nos títulos a receber.)
    @type  Function
    @author Wilk Lima
    @since 13/08/2021
    @version 1.0
    @return aCpos, ARRAY, CAMPOS A SEREM PERMITIDOS NA ALTERAÇÃO.
    @example
    (examples)
    @see (links_or_references)
    /*/

User Function F040CPO() 

Local aCpos := PARAMIXB 

If   Alltrim(SE1->E1_TIPO)$"CC/CD"   
     AADD(aCpos,"E1_DOCTEF") 
     AADD(aCpos,"E1_NSUTEF")
  
Endif 

return (aCpos)
