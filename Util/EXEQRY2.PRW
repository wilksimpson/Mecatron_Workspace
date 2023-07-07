#Include "Protheus.ch"
#include "TopConn.ch"

// EXECUTA QUERIE DE ACORDO COM A NECESSIDADE.

USER FUNCTION EXECQRY2()
	LOCAL _coduser := RetCodUsr()
	Local QRY_UPD := ''

	QRY_UPD := " UPDATE SB1010 SET B1_CLASFIS = F4_SITTRIB "
	QRY_UPD += " FROM SF4010 F4 "
	QRY_UPD += " WHERE F4.D_E_L_E_T_<>'*' AND SB1010.D_E_L_E_T_<>'*' "
	QRY_UPD += " AND B1_FILIAL=F4_FILIAL AND B1_TS=F4_CODIGO "

	if _coduser == '000000'

		TCSqlExec(QRY_UPD)

	else
		alert("Somente o Administrador pode executar esta ação")
	ENDIF


RETURN
