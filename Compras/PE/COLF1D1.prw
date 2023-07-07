#Include 'Protheus.ch'
/*/{Protheus.doc} COLF1D1
Grava aliquota IPI importado do XML e ordena itens na SD1  de acordo com o XML.
@type function
@version  
@author wilks
@since 16/11/2022
@return variant, return_description
/*/

User Function COLF1D1()
Local aArea      := GetArea()
Local aCab := PARAMIXB[1]
Local aItens := PARAMIXB[2]
Local aRet := {}
Local nPos := 0 
Local _Fornece := ""
Local _Loja    := ""
Local _Doc     := ""
Local _SerDoc  := ""
Local _Tipo    := aCab[2,2]

If _Tipo == 'N' 

_Fornece := aCab[7,2]
_Loja    := aCab[8,2]
_Doc     := aCab[4,2]
_SerDoc  := aCab[5,2]

IF LEN(aItens)>=1
        aSort(aItens,,,{|X,Y| x[2,2] < y[2,2]})
        SDT->(dbGoTop())
        nPos := 1 
        DbSelectArea("SDT")
        DbSetOrder(8)
        DBSEEK(aItens[nPos,1,2]+_Fornece+_Loja+_Doc+_SerDoc)
        WHILE SDT->(!EOF()) .and. nPos <= LEN(aItens) .and. SDT->DT_FILIAL==aItens[nPos,1,2];
        .and. SDT->DT_FORNEC==_Fornece;
        .and. SDT->DT_LOJA==_Loja;
        .and. SDT->DT_DOC==_Doc;
        .and. SDT->DT_SERIE==_SerDoc
        
        if SDT->DT_ITEM==aItens[nPos,2,2] .AND. SDT->DT_COD==aItens[nPos,3,2] 
            // ADICIONAR aliquota do IPI importado no XML 
            IF SDT->DT_XALQIPI>0
              AADD(aItens[nPos],{"D1_IPI",SDT->DT_XALQIPI,NIL})  
            ENDIF           
            // ADICIONAR VALOR DO ICMS ST importado no XML 
            IF SDT->DT_XMLICST>0
              AADD(aItens[nPos],{"D1_ICMSRET",SDT->DT_XMLICST,NIL})  
            ENDIF      
        ENDIF

        nPos++
        SDT->(DbSkip())
        EndDo
    ENDIF

ENDIF

aRet := {aCab,aItens}
RestArea(aArea)
Return aRet
