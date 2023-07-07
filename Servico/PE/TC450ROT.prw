/*/
    Adiciona botão de impressão de Projeto customizada na rotina de projetos do Gestão de serviços.
/*/
User Function TC450ROT()
Local aRotAdic:= {}

aAdd(aRotAdic, { 'Encerra OS Manual','U_EncerOS', 0 , 2} )

Return aRotAdic


User Function EncerOS()

    RecLock("AB6", .F.)
    AB6->AB6_STATUS := "E"    
    MsUnlock()

Return
