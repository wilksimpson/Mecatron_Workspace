#Include "protheus.ch"
#include "rwmake.ch"


 /*/{Protheus.doc} LJORCAM
    (Chama o tipo de impress�o de acordo com a op��o escolhida pelo usu�rio)
    @type  Function
    @author Wilk Lima
    @since 07/12/2021
    @version 1.0
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
user Function LJORCAM()

		_nOpc:= Aviso("Impress�o Orcamento","Imprime Orcamento?",{"Nao Fiscal","A4","Cancela"}) 
		If _nOpc = 1
			U_RImpOrc()
		ELSEIF _nOpc = 2
			U_Orcam_MC()
		Endif

Return 
