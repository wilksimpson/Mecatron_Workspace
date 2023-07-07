#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
//±±ºPrograma  IMPPRDIM   º Autor João Felipe Costa Braga Data ³ 05.02.2021 º±±
//±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
//±±ºDescricao ³ REPONSAVEL Controlar a opcao de Outras Ações               º±±
//±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function LJ7053()
Local aArray :={{"Imprime"      , "U_RImpOrc()"     , 0, 1, NIL, .F.}}

aAdd(aArray ,    { "Conferir Orcamento" ,"U_ConfOrc()"   , 0 , 5 , , .T. }) 
aAdd(aArray ,    { "Imprime DANFE"  ,"U_impNfe()"        , 0 , 5 , , .T. }) 
aAdd(aArray ,    { "Monitor Nfe"  ,"SpedNFe1Mnt()"       , 0 , 5 , , .T. }) 
aAdd(aArray ,    { "Retransmitir Nfe"  ,"U_LJNFESN()"    , 0 , 5 , , .T. }) 

Return(aArray)

User Function LJNFESN()
	Private aFilBrw
	Private bFiltraBrw
	SpedNFeRemessa()
Return

User Function impNfe()
    Private aFilBrw     := {}
    SpedDanfe()
Return

User Function ConfOrc()

IF SL1->L1_LIBERAD != "3"
	U_BIPPRODS(SL1->L1_NUM,SL1->L1_FILIAL)
ELSEIF SL1->L1_LIBERAD == "3"
	ALERT("Orcamento ja conferido")
ENDIF

Return


User Function FTVD7053()

Return U_LJ7053()
