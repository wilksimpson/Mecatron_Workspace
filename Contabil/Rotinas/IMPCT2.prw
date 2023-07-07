//Bibliotecas
#Include "TOTVS.ch"
#Include "TopConn.ch"



/*/{Protheus.doc} IMPCT2
Função para importar lançamentos contabeis atraves de csv
@author Wilk Lima
@since 19/11/2022
@version 1.0
@type function
/*/

User Function IMPCT2()
	Local aArea     := GetArea()
	Local cPerg		:= "IMPCT2"
	Private cArqOri := ""
	//Posições do Array
	Private nPosCodigo := 1 //Coluna A no Excel
	Private nPosValor  := 2 //Coluna B no Excel
	Private nTipoCod   := 1 // define se código reduzido ou código completo
	Private aItens     := {}
	Private aCab       := {}
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	Private CTF_LOCK    := 0
	Private lSubLote    := .T.

	If Pergunte(cPerg,.T.)
		nPosCodigo := MV_PAR01
		nPosValor  := MV_PAR02
		nTipoCod   := MV_PAR03 // 1 = Reduzido; 2 = Código completo.
		dDataLact  := MV_PAR04 // Data do Lançamento
		cLoteLact  := MV_PAR05 // Lote do lançamento
		cHistLact  := MV_PAR06 // Historico do lançamento
	else
		Return
	EndIf

	if nPosCodigo==0 .or. nPosValor==0
		MsgInfo("Obrigatório informar a posição do código da conta além do valor.", "Atenção")
		Return
	EndIf
	//Mostra o Prompt para selecionar arquivos
	cArqOri := tFileDialog( "CSV files (*.csv) ", 'Seleção de Arquivos', , , .F., )

	//Se tiver o arquivo de origem
	If ! Empty(cArqOri)

		//Somente se existir o arquivo e for com a extensão CSV
		If File(cArqOri) .And. Upper(SubStr(cArqOri, RAt('.', cArqOri) + 1, 3)) == 'CSV'
			Processa({|| fImporta() }, "Importando...")
		Else
			MsgStop("Arquivo e/ou extensão inválida!", "Atenção")
		EndIf
	EndIf

	RestArea(aArea)
Return

/*-------------------------------------------------------------------------------*
 | Func:  fImporta                                                               |
 | Desc:  Função que importa os dados                                            |
 *-------------------------------------------------------------------------------*/
 
Static Function fImporta()
    Local aArea      := GetArea()
    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local oArquivo
    Local aLinhas
    Local cCtaDeb  := ""
    Local cCtaCred := ""
    Local _cOrigem := 'IMPCT2 - '+UsrRetName(RetCodUsr())+" - "+DToC(ddatabase)
    Private aLinha     := {} 
    Private _lok        := .F. 

    //Definindo o arquivo a ser lido
    oArquivo := FWFileReader():New(cArqOri)
     
    //Se o arquivo pode ser aberto
    If (oArquivo:Open())
 
        //Se não for fim do arquivo
        If ! (oArquivo:EoF())
 
            //Definindo o tamanho da régua
            aLinhas := oArquivo:GetAllLines()
            nTotLinhas := Len(aLinhas)
            ProcRegua(nTotLinhas)
             
            //Método GoTop não funciona (dependendo da versão da LIB), deve fechar e abrir novamente o arquivo
            oArquivo:Close()
            oArquivo := FWFileReader():New(cArqOri)
            oArquivo:Open()
 
            //Enquanto tiver linhas
            While (oArquivo:HasLine())
                _lok        := .T. 
                cCtaDeb  := ""
                cCtaCred := ""
                //Incrementa na tela a mensagem
                nLinhaAtu++
                IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")
                 
                //Pegando a linha atual e transformando em array
                cLinAtu := oArquivo:GetLine()
                aLinha  := STRTOKARR2(cLinAtu, ";",.t.)
                 
                    if len(aLinha)<nPosValor .or. len(aLinha)<nPosCodigo
                         _lok        := .F.  
                         LOOP 
                    EndIf

                    //CARREGA DADOS DA LINHA
                    cCodCta      := ALLTRIM(aLinha[nPosCodigo]) // obrigatório
                    cValor       := aLinha[nPosValor]  // obrigatório

                    IF !EMPTY(cCodCta) .AND. !EMPTY(cValor) // se esses campos não estiverem vázios, processa.  

                        cTipDC := RIGHT( cValor, 1 )
                        if RIGHT( cValor, 1 ) == 'D'
                            cTipDC:='1' // DEBITO
                        elseif RIGHT( cValor, 1 ) == 'C'
                            cTipDC:='2' // CREDITO
                        ELSE
                          _lok        := .F.  
                          LOOP 
                        ENDIF    

                        cValor := STRTRAN(cValor,"D","") 
                        cValor := STRTRAN(cValor,"C","") 
                        cValor := STRTRAN(cValor,".","") 
                        cValor := STRTRAN(cValor,",",".") 
                        nValor := val(cValor)

                        //verifica qual tipo de código será utilizado.
                        if MV_PAR03==1
                            DbSelectArea("CT1")
                            DbSetOrder(2) // REDUZIDO
                            IF !DBSEEK(XFILIAL("CT1")+PADR(cCodCta,TamSx3("CT1_RES")[1]))
                                _lok        := .F.  
                                LOOP 
                            ENDIF
                         else
                            DbSelectArea("CT1")
                            DbSetOrder(1) // COD NORMAL
                            IF !DBSEEK(XFILIAL("CT1")+PADR(cCodCta,TamSx3("CT1_CONTA")[1]))
                                _lok        := .F.  
                                LOOP 
                            ENDIF
                        EndIf

                        IF CT1->CT1_CLASSE=='2' .AND. _lok .and. nValor>0
                        // MONTA ARRAY COM OS LANÇAMENTOS
                        aAdd(aItens,  {;
                            {'CT2_FILIAL' , xFilial('CT2')                  , NIL},;
                            {'CT2_LINHA'  , StrZero(nLinhaAtu,3)            , NIL},;
                            {'CT2_MOEDLC' ,'01'                             , NIL},;
                            {'CT2_DC'     ,cTipDC                           , NIL},;
                            {'CT2_DEBITO' ,if(cTipDC=='1',CT1->CT1_CONTA,""), NIL},;
                            {'CT2_CREDIT' ,if(cTipDC=='2',CT1->CT1_CONTA,""), NIL},;
                            {'CT2_VALOR'  , nValor                          , NIL},;
                            {'CT2_ORIGEM' ,_cOrigem                         , NIL},;
                            {'CT2_HP'     ,''                               , NIL},;
                            {'CT2_CONVER' ,'15555'                          , NIL},;
                            {'CT2_HIST'   , ALLTRIM(cHistLact)              , NIL} })
                        ENDIF
                    ENDIF
            EndDo

        Else
            MsgStop("Arquivo não tem conteúdo!", "Atenção")
        EndIf
 
        //Fecha o arquivo
        oArquivo:Close()
    Else
        MsgStop("Arquivo não pode ser aberto!", "Atenção")
    EndIf
    
    IF LEN(aItens)>=1
    
    aAdd(aCab, {'DDATALANC' ,dDataLact ,NIL} )
    aAdd(aCab, {'CLOTE' ,cLoteLact     ,NIL} )
    aAdd(aCab, {'CSUBLOTE' ,'001'      ,NIL} )
    aAdd(aCab, {'CPADRAO' ,''          ,NIL} )
    aAdd(aCab, {'NTOTINF' ,0           ,NIL} )
    aAdd(aCab, {'NTOTINFLOT',0         ,NIL} )

    MSExecAuto({|x, y,z| CTBA102(x,y,z)}, aCab ,aItens, 3)
    If lMsErroAuto
    lMsErroAuto := .F.
    MostraErro()
    else
        MsgInfo("Os valores podem ser analisados através da rotina lançamentos automáticos, buscando pelo numero do lote "+cLoteLact,"Importação realizada")
    EndIf

    ENDIF

    RestArea(aArea)
Return

