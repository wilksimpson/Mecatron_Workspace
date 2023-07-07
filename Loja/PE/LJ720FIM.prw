#INCLUDE "rwmake.ch"

/*/{Protheus.doc} LJ720FIM
Ajusta valor da NCC para notas com diferimento que descontam ICMS de forma indevida.
@type function
@version  
@author wilks
@since 12/11/2022
@return variant, return_description
/*/

User Function LJ720FIM
	Local aDocDev 	 := PARAMIXB[1] //{cSerie,cNewDoc,cCliente, cLoja, nTpProc} nTpProc = Tipo de Pperacao 1=Troca, 2 = Devolucao
	Local _nValTotal := 0

	if type('OVLRTOTAL_1')<>'U'
		_nValTotal := OVLRTOTAL_1:CTEXT
	ENDIF
//Posicona no Contas a Receber Conforme a Geracao da NCC
	If Len(aDocDev) > 0 .AND. _nValTotal>0

		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+aDocDev[3]+aDocDev[4])
		IF SA1->A1_ICMSDIF == 'S'

			If aDocDev[5] == 2  //Devolucao

				DbSelectArea("SE1")
				DbSetOrder(2) //E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO
				If DbSeek(xFilial("SE1")+aDocDev[3]+aDocDev[4]+aDocDev[1]+aDocDev[2])
					If SE1->E1_TIPO = 'NCC' .AND. _nValTotal<>SE1->E1_VALOR
							RecLock("SE1", .F.)
								SE1->E1_VALOR := _nValTotal
								SE1->E1_SALDO := _nValTotal
								SE1->E1_VLCRUZ := _nValTotal
							MsUnlock()
					Endif
				Endif
			Endif
		Endif
	Endif

Return

