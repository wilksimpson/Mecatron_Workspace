#INCLUDE "TOTVS.CH"
#include "PROTHEUS.CH"
#include "RWMAKE.CH"
#INCLUDE "TopConn.ch"


 /*/{Protheus.doc} CORRSE1
(Seleciona e envia contrato para ajustar numero de títulos)
@type  Function
@author Wilk Lima
@since 21/10/2021
@version 1.0
    /*/
User Function CORRSE1()
	Local cpergunte := "CORRSE1"
	Local xCtr      := GetnextAlias()
	LOCAL _coduser := RetCodUsr()
	Local cDtIni := " "
	Local cDtFim := " "
	Local cLogLotes := ""

	if !(_coduser $ '000000,000007') 
		Alert("Atenção, somente o adminstrador pode executar essa rotina.")
		Return
	endif

	IF !Pergunte(cpergunte)
		Return .T.
	endif

	cDtIni := DTOS(MV_PAR01)
	cDtFim := DTOS(MV_PAR02)

	// CRIAR LISTA lotes a ajustar
	BeginSql Alias xCtr
            SELECT E5_FILIAL,E5_LOTE
            FROM %table:SE5% SE5
            WHERE SE5.%notdel% 
            AND SE5.E5_DATA BETWEEN %Exp:cDtIni% and %Exp:cDtFim% 
            AND E5_ORIGEM IN ('FINA910','FINA918')
            AND E5_LOTE>' ' AND (E5_TIPO='CD' OR E5_TIPO='CC') 
			AND E5_ORIGEM IN ('FINA910','FINA918')
            GROUP BY E5_LOTE,E5_FILIAL
//            HAVING SUM(E5_VLJUROS) >0  // PROCESSA SOMENTE REGISTROS COM JUROS.
	EndSql

	if  EMPTY((XCTR)->E5_LOTE)
		MSGINFO("Não há LOTES a processar para os paramtros informados","Observação")
		return .T.
	endif

	while !(xCtr)->(EOF())
		//Instancia a classe
		oAjustSE1 :=  xProc2SE1():New()

		// chama o método para processar o contrato em questão.
		oAjustSE1:Proc2SE1((xCtr)->E5_FILIAL,(xCtr)->E5_LOTE)
		 
		 cLogLotes += "Processado Lote:  "+(xCtr)->E5_FILIAL+" "+(xCtr)->E5_LOTE+ chr(13) + chr(10)

		(xCtr)->(DbSkip())
	endDo

	If !empty(cLogLotes)
		LogOnFile(cLogLotes)
		MsgInfo(cLogLotes, "Lotes Processados")
	endif
Return

// grava log do processamento.
Static function LogOnFile(cLogLotes)
local nHandle
Local cToFile := "\Correcao_Juros_Sitef_"
Local cData	  := dtos(dDataBase)
Local cHora	  := Time()
	  
	  cHora := STRTRAN(cHora,":","")
	  cToFile += cData+"_"+cHora+".txt"

	nHandle := FCREATE(cToFile)

    if nHandle = -1
        conout("Erro ao criar arquivo - ferror " + Str(Ferror()))
    else
        FWrite(nHandle, cLogLotes)
        FClose(nHandle)
		WaitRun(cToFile,1)
    endif
return
