#INCLUDE 'Protheus.ch'
#INCLUDE 'TbIconn.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} UFUNZIP
Funcao que descompacta os arquivos .GZ
@author  Rodrigo
@since   19/09/19
@version 1.0
/*/
//-------------------------------------------------------------------
User Function UFUNZIP()    
    Local cDirSrv   
    Local aArquivos
    Local nI
    Local cArqOri := ""
    Local cArqDest := ""
    If Empty(FunName())
        PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'
    EndIf

    //Diretorio onde ficam os arquivos GZ
    cDirSrv   :=  "\importadorxml\baixados\" // local onde os XMLs zipados são baixados
    cDirdes   := "\importadorxml\cfg\"//SuperGetMV('MV_NGINN  ', .F., '') // local onde o importador xml vai buscar os XMLs para importação.
    cDirSrv   := Alltrim(cDirSrv) 
    //cDirdes   := Alltrim(cDirdes)+"\"
 

    
    //Monta um array com todos os arquivos GZ
    aArquivos := Directory(cDirSrv + "*.gz") // carregando todos os arquivos para extrair do zip
        
   //Percorre todos os arquivos descompactando
   For nI := 1 To len(aArquivos)

        //Pega o nome do arquivo com e sem extensao
        cArquivo    := aArquivos[nI][1]
        cArqSemExt  := StrTran(Lower(cArquivo),'-nfeproc.gz','')
        cArquivo1    := StrTran(Lower(cArquivo),'.gz','')
          
        //Tenta descompactar o arquivo
        If GzDecomp( cDirSrv + cArquivo, cDirSrv )
            cArqOri := Alltrim(cDirSrv) + alltrim(cArquivo1)
            cArqDest := Alltrim(cDirdes) + alltrim(cArqSemExt)+".xml"
    
    		//if __CopyFile( cDirSrv +  cArquivo1, cDirdes + cArqSemExt + ".xml",,,.F.)
    		if __CopyFile(cArqOri, cArqDest,,,.T.)
                FErase( cDirSrv +  cArquivo1 )
                FErase( cDirSrv +  cArquivo )
            EndIf
        EndIf

    Next


Return
