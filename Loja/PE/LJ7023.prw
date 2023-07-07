#INCLUDE "rwmake.ch"

//O ponto de entrada abaixo desabilita os botões Cheque e Cartão de Crédito://---------------------------------------

User Function LJ7023
Local lRet := .F.
Local cFormaPg := PARAMIXB[1]

If cFormaPg == "BOLETO BANCARIO" .OR. cFormaPg == "DEPOSITO A PRAZO"

lRet := .T.
Endif

Return lRet

// chamada pelo venda direta.
user function FTVD7023() //LJ7023

RETURN U_LJ7023()
