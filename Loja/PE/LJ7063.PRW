#Include "Protheus.ch"

User Function LJ7063()

	//MsgAlert("Passando pelo PE LJ7063", "PE")

    IF PARAMIXB[1] == 2 .AND. PARAMIXB[3] == 4 .AND. PARAMIXB[4] == .F.
	LJ7VldCond( M->LQ_CONDPG , @cDescCondPg, @oDescCondPg, @oPgtos, "" )
	Lj7lAtuCond( .T. )
	Lj7CondPg( 2, M->LQ_CONDPG,, ( ! nNCCUsada > 0 ))
	//Lj7AjustaTroco()

	If lVisuSint
		oPgtosSint:Refresh()
	EndIf

	oPgtos:Refresh()
    ENDIF

RETURN .T.


User Function FTDV7063()

RETURN U_LJ7063()
