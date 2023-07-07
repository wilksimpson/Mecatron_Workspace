#include "rwmake.ch"
#include "Topconn.ch"
#include "protheus.ch"

User Function SPDPIS07()

	Local   _cFilial     :=  PARAMIXB[1] //FT_FILIAL
	Local   _cTpMov      :=  PARAMIXB[2] //FT_TIPOMOV
	Local   _cSerie      :=  PARAMIXB[3] //FT_SERIE
	Local   _cDoc        :=  PARAMIXB[4] //FT_NFISCAL
	Local   _cClieFor    :=  PARAMIXB[5] //FT_CLIEFOR
	Local   _cLoja       :=  PARAMIXB[6] //FT_LOJA
	Local   _cItem       :=  PARAMIXB[7] //FT_ITEM
	Local   _cProd       :=  PARAMIXB[8] //FT_PRODUTO
	Local   _cConta      :=  PARAMIXB[9] //FT_CONTA

	IF Empty(_cConta)
        
		IF _cTpMov =='E'
       		//MsgAlert("Conta vazia", "entrada")
			DbSelectArea("SD1")
			//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
			DbSetOrder(1)
			DBSEEK(_cFilial+_cDoc+_cSerie+_cClieFor+_cLoja+_cProd+_cItem)
			_cConta := POSICIONE("SF4",1,XFILIAL("SF4")+SD1->D1_TES,"F4_CONTA")
			//MsgAlert(_cConta, "Localizou conta")
		Endif

		IF _cTpMov =='S'
      		// MsgAlert("Conta vazia", "saída")
			DbSelectArea("SD2")
			//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
			DbSetOrder(3)
			DBSEEK(_cFilial+_cDoc+_cSerie+_cClieFor+_cLoja+_cProd+_cItem)
			_cConta := POSICIONE("SF4",1,XFILIAL("SF4")+SD2->D2_TES,"F4_CONTA")
			//MsgAlert(_cConta, "Localizou conta")
		Endif
	ENDIF
      //  MsgAlert(_cConta, "Localizou conta")
Return _cConta
