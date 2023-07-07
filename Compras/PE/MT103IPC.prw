User Function MT103IPC()
    Local _xx
//   Local _xy
// Autor: Wilk Lima em 23/06/2020

//Preenche a descrição do produto na importação do pedido de compras em campo de usuário.
    _xx := Len(aCols)
    aCols[_xx,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="D1_DESCRI" })]:=SC7->C7_DESCRI
    //aCols[_xx,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="D1_CARTAO" })]:=SC7->C7_CARTAO

/*/Preenche a TES do produto X fornecedor na importação do pedido de compras no documento de entrada.
    IF FunName()=="MATA103"
        _xy := Len(aCols)
        aCols[_xy,aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="D1_TES" })]:= POSICIONE("SA5",2,XFILIAL("SA5")+SC7->C7_PRODUTO+SC7->C7_FORNECE+SC7->C7_LOJA,"A5_TE")
    endif
/*/
Return


