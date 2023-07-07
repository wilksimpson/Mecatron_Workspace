#Include "PROTHEUS.CH"

/*/
    Ponto de Entrada para Alterar nome Reduzido para Razão Social do Cliente.
/*/

USER FUNCTION F040FCR()

Reclock("SE1",.F.)	
E1_NOMCLI := SUBSTR(POSICIONE("SA1",1,XFILIAL("SA1")+E1_CLIENTE+E1_LOJA,'A1_NOME'),1,20) 

MsUnlock()

RETURN
