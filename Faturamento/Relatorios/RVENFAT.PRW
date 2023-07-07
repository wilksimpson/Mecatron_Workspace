#include 'protheus.ch'
#include 'parmtype.ch'

user function RVENFAT()
	Local oReport
	Local aArea := GetArea()

	Pergunte("RVENFAT",.T.)

	//здддддддддддддддддддддд©
	//ЁInterface de impressaoЁ
	//юдддддддддддддддддддддды
	oReport := RVENFATDef()
	oReport:PrintDialog()

	RestArea( aArea )
Return

Static Function RVENFATDef()
	Local oReport										// Objeto do relatorio
	Local oSection1										// Objeto da secao 1
	Local oSection2
	// Objeto da secao 1
	Local cAlias1	:= GetNextAlias()					// Pega o proximo Alias Disponivel
	Local lTop      := .F.                        		// Verifica se esta usando o Top

	#IFDEF TOP
	lTop 	:= .T.
	#ENDIF

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁGera a tela com os dados para a confirmaГЦo da geracao do relatorioЁ
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	// Ranking de Produtos
	//"Este programa irА emitir um Ranking de Produtos por" "PreГo ou Quantidade em Moeda Corrente."
	oReport := TReport():New("RVENFAT","Faturamento Por Vendedor de "+DTOC(MV_PAR01)+" ate "+DTOC(MV_PAR02),"RVENFAT",{|oReport| RVENFATRpt(oReport,cAlias1)}, "Faturamento Por Vendedor de "+DTOC(MV_PAR01)+" ate "+DTOC(MV_PAR02) )
    oReport:nFontBody := 8
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁDefine a secao1 do relatorio, informando que o arquivo principal utlizado eh o SL2 e o complementar o SB1Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oSection1 := TRSection():New(oReport,"Faturamento Por Vendedor de "+DTOC(MV_PAR01)+" ate "+DTOC(MV_PAR02),{"SE2"} )		// Detalhes dos Produtos
	oSection1:SetTotalText("")									// Inibe o texto da secao
	oSection1:SetTotalInLine(.F.)								// Imprime total em linha ou coluna (default .T. - linha )

	//зддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁDefine as celulas que irao aparecer na secao1Ё
	//юддддддддддддддддддддддддддддддддддддддддддддды
    IF MV_PAR03 == 1

        TRCell():New(oSection1,"CODIGO"			    ,cAlias1,"Codigo","@!",10,,,"LEFT",,"LEFT")
        TRCell():New(oSection1,"NOME"		        ,cAlias1,"Nome","@!",10,,,"LEFT",,"LEFT")
        TRCell():New(oSection1,"N_VEND"			    ,cAlias1,"Qtd. Vendas","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
        TRCell():New(oSection1,"N_ITENS"			,cAlias1,"Qtd. Itens","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
        TRCell():New(oSection1,"DEVO"			    ,cAlias1,"DevoluГУes","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
        TRCell():New(oSection1,"BRUTO"			    ,cAlias1,"Vlr. Bruto","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
        TRCell():New(oSection1,"DESCONTO"			,cAlias1,"Descontos","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
        TRCell():New(oSection1,"VENDIDO"			,cAlias1,"Vlr. Liquido","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
        TRCell():New(oSection1,"FRETE"		    	,cAlias1,"Frete","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
        TRCell():New(oSection1,"BASE_COMISSAO"		,cAlias1,"Total","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
    ELSE
    	TRCell():New(oSection1,"EMPRESA"		        ,cAlias1,"Filial","@!",10,,,"LEFT",,"LEFT")
    	TRCell():New(oSection1,"PERIODO"		        ,cAlias1,"Emissao","@!",10,,,"LEFT",,"LEFT")
    	TRCell():New(oSection1,"TIPO"	    	        ,cAlias1,"Tipo","@!",10,,,"LEFT",,"LEFT")
    	TRCell():New(oSection1,"DOCUMENTO"		        ,cAlias1,"Nfe","@!",10,,,"LEFT",,"LEFT")
    	TRCell():New(oSection1,"CLIENTE"		        ,cAlias1,"Cliente","@!",40,,,"LEFT",,"LEFT")
        TRCell():New(oSection1,"BRUTO"			        ,cAlias1,"Vlr. Bruto","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
        TRCell():New(oSection1,"DESCONTO"			    ,cAlias1,"Descontos","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
        TRCell():New(oSection1,"VENDIDO"			    ,cAlias1,"Vlr. Liquido","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
        TRCell():New(oSection1,"FRETE"		    	    ,cAlias1,"Frete","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
        TRCell():New(oSection1,"BASE_COMISSAO"		    ,cAlias1,"Total","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")

    ENDIF

	oSection2 := TRSection():New(oReport,"Quebra por Filial",{"SE2"} )		// Detalhes dos Produtos
	oSection2:SetTotalText("")									// Inibe o texto da secao
	oSection2:SetTotalInLine(.T.)								// Imprime total em linha ou coluna (default .T. - linha )
    IF MV_PAR03 == 1
        oSection2:SetHeaderBreak(.F.)
        oSection2:SetHeaderSection(.F.)
    	TRCell():New(oSection2,"TEXTO" 		    ,cAlias1,"","@!",20)
	ELSE
        oSection2:SetHeaderBreak(.T.)
        oSection2:SetHeaderSection(.T.)
    	TRCell():New(oSection2,"TEXTO" 		    ,cAlias1,"Totais","@!",40)
    ENDIF

    TRCell():New(oSection2,"N_VEND"			    ,cAlias1,"Qtd. Vendas","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
	TRCell():New(oSection2,"N_ITENS"			,cAlias1,"Qtd. Itens","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
	TRCell():New(oSection2,"DEVO"			    ,cAlias1,"DevoluГУes","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
	TRCell():New(oSection2,"BRUTO"			    ,cAlias1,"Vlr. Bruto","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
	TRCell():New(oSection2,"DESCONTO"			,cAlias1,"Descontos","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
	TRCell():New(oSection2,"VENDIDO"			,cAlias1,"Vlr. Liquido","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
	TRCell():New(oSection2,"FRETE"		    	,cAlias1,"Frete","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")
	TRCell():New(oSection2,"BASE_COMISSAO"		,cAlias1,"Total","@E 999,999,999,999.99",15,,,"RIGHT",,"CENTER")

Return oReport

Static Function RVENFATRpt( oReport, cAlias1 )
	Local oSection1 := oReport:Section(1)				// Define a secao 1 do relatorio
	Local oSection2 := oReport:Section(2)				// Define a secao 1 do relatorio
	Local nQtdeRegs := 0								// Contador para delimitar o tamanho da regua de progressao

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁTransforma parametros do tipo Range em expressao SQL para ser utilizada na query Ё
	//ЁExemplo Word, nao intervalos pre definidos (mais utilizado pelo RH - Ferias)     Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	MakeSqlExpr("FINPAG")

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁDe acordo com o parametro, monta a ordem do relatorioЁ
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддды

	//здддддддддддддддддддд©
	//ЁInicializa a secao 1Ё
	//юдддддддддддддддддддды
	BEGIN REPORT QUERY oSection1

		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁQuery utilizada para filtrar todos os dados necessarios Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁQuery utilizada para filtrar todos os dados necessarios Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			IF MV_PAR03 == 1
                BeginSql alias cAlias1

                    SELECT         CODIGO, NOME,  SUM(DEVO) AS DEVO, SUM(N_vend) AS N_vend, SUM(N_itens) AS N_itens, SUM(Vendido + DESCONTO) AS Bruto, SUM(DESCONTO) AS DESCONTO, SUM(Vendido) AS Vendido, 
                                            SUM(Vendido - DEVO) AS BASE_COMISSAO, SUM(FRETE) AS FRETE
                    FROM            (SELECT        L1.L1_FILIAL AS EMPRESA, 'VENDA' AS TIPO, L1.L1_VEND AS CODIGO, VEN.A3_NREDUZ AS NOME, 0 AS DEVO, COUNT(*) AS N_vend, 0 AS N_itens, SUM(L1.L1_DESCONT) AS DESCONTO, 
                                                                        SUM(L1.L1_VLRLIQ) AS Vendido, SUM(L1.L1_FRETE) AS FRETE, L1.L1_EMISNF AS EMISSAO
                                            FROM            dbo.SL1010 AS L1 INNER JOIN
                                                                        dbo.SA3010 AS VEN ON L1.L1_VEND = VEN.A3_COD AND VEN.D_E_L_E_T_ <> '*' AND L1.D_E_L_E_T_ <> '*'
                                            WHERE         (L1.D_E_L_E_T_ <> '*') AND (L1.L1_TIPO <> '') AND (L1.L1_ORCRES = '') AND (L1.L1_EMISNF <> '') AND ((L1.L1_DOC <> '') OR (L1.L1_DOCPED <> ''))
                                            AND L1_EMISNF BETWEEN  %exp:DTOS(mv_par01)%	AND	%exp:DTOS(mv_par02)%
                                            GROUP BY L1.L1_FILIAL, L1.L1_VEND, VEN.A3_COD, VEN.A3_NREDUZ, L1.L1_EMISNF
                                            UNION ALL
                                            SELECT        L1.L1_FILIAL AS EMPRESA, 'VENDA' AS TIPO, L1.L1_VEND AS CODIGO, VEN.A3_NREDUZ AS NOME, 0 AS DEVO, 0 AS N_vend, COUNT(*) AS N_itens, SUM(IT.L2_VALDESC) AS DESCONTO, 
                                                                    0 AS Vendido, 0 AS FRETE, L1.L1_EMISNF AS EMISSAO
                                            FROM            dbo.SL1010 AS L1 INNER JOIN
                                                                    dbo.SA3010 AS VEN ON L1.L1_VEND = VEN.A3_COD AND VEN.D_E_L_E_T_ <> '*' AND L1.D_E_L_E_T_ <> '*' INNER JOIN
                                                                    dbo.SL2010 AS IT ON IT.L2_FILIAL = L1.L1_FILIAL AND IT.L2_NUM = L1.L1_NUM AND L1.D_E_L_E_T_ <> '*' AND IT.D_E_L_E_T_ <> '*'
                                            WHERE         (L1.D_E_L_E_T_ <> '*') AND (L1.L1_TIPO <> '') AND (L1.L1_ORCRES = '') AND (IT.D_E_L_E_T_ <> '*') AND (L1.L1_EMISNF <> '') AND ((L1.L1_DOC <> '') OR (L1.L1_DOCPED <> ''))
                                            AND L1_EMISNF BETWEEN  %exp:DTOS(mv_par01)%	AND	%exp:DTOS(mv_par02)%
                                            GROUP BY L1.L1_FILIAL, L1.L1_VEND, VEN.A3_COD, VEN.A3_NREDUZ, L1.L1_EMISNF
                                            UNION ALL
                                            SELECT        C5.C5_FILIAL AS EMPRESA, 'VENDA' AS TIPO, C5.C5_VEND1 AS CODIGO, VEN.A3_NREDUZ AS NOME, 
                                                          0 AS DEVO, 0 AS N_vend, COUNT(*) AS N_itens, SUM(IT.C6_VALDESC) AS DESCONTO, 
                                                                    SUM(C6_VALOR) AS Vendido, 0 AS FRETE, F2.F2_EMISSAO AS EMISSAO
                                            FROM    dbo.SC5010 AS C5 INNER JOIN
                                                    dbo.SA3010 AS VEN ON C5.C5_VEND1 = VEN.A3_COD AND VEN.D_E_L_E_T_ <> '*' AND C5.D_E_L_E_T_ <> '*' INNER JOIN
                                                    dbo.SC6010 AS IT ON IT.C6_FILIAL = C5.C5_FILIAL AND IT.C6_NUM = C5.C5_NUM AND C5.D_E_L_E_T_ <> '*' AND IT.D_E_L_E_T_ <> '*' INNER JOIN
                                                    dbo.SF2010 AS F2 ON F2.F2_FILIAL = C5.C5_FILIAL AND F2.F2_DOC = C5.C5_NOTA AND F2.F2_SERIE = C5.C5_SERIE AND F2.D_E_L_E_T_ <> '*' INNER JOIN 
                                                    dbo.SF4010 AS F4 ON F4_CODIGO = C6_TES AND F4_FILIAL = SUBSTRING(C6_FILIAL,1,2) AND F4.D_E_L_E_T_ <> '*' AND IT.D_E_L_E_T_ <> '*' 
                                            WHERE         (C5.D_E_L_E_T_ <> '*') AND (C5.C5_NOTA <> '') AND (IT.D_E_L_E_T_ <> '*') AND F4_DUPLIC = 'S' 
                                             AND F2.F2_EMISSAO BETWEEN  %exp:DTOS(mv_par01)%   AND %exp:DTOS(mv_par02)%                                           
                                            GROUP BY C5.C5_FILIAL, C5.C5_VEND1, VEN.A3_COD, VEN.A3_NREDUZ, F2.F2_EMISSAO
                          
                                            UNION ALL
                                            SELECT        dbo.SD1010.D1_FILIAL AS EMPRESA, 'DEVOLUCAO' AS TIPO, dbo.SF2010.F2_VEND1 AS CODIGO, VEN.A3_NREDUZ AS NOME, SUM(dbo.SD1010.D1_TOTAL - dbo.SD1010.D1_VALDESC) AS DEVO, 
                                                                    0 AS N_vend, 0 AS N_itens, 0 AS DESCONTO, 0 AS Vendido, 0 AS FRETE, dbo.SD1010.D1_EMISSAO AS EMISSAO
                                            FROM            dbo.SD1010 INNER JOIN
                                                                    dbo.SF2010 ON dbo.SD1010.D1_FILIAL = dbo.SF2010.F2_FILIAL AND dbo.SD1010.D1_NFORI = dbo.SF2010.F2_DOC AND dbo.SD1010.D1_SERIORI = dbo.SF2010.F2_SERIE AND 
                                                                    dbo.SF2010.D_E_L_E_T_ <> '*' AND dbo.SD1010.D_E_L_E_T_ <> '*' INNER JOIN
                                                                    dbo.SA3010 AS VEN ON dbo.SF2010.F2_VEND1 = VEN.A3_COD AND VEN.D_E_L_E_T_ <> '*'
                                            WHERE        (dbo.SF2010.D_E_L_E_T_ <> '*') AND (dbo.SD1010.D_E_L_E_T_ <> '*')
                                            AND D1_EMISSAO BETWEEN  %exp:DTOS(mv_par01)%	AND	%exp:DTOS(mv_par02)%
                                            GROUP BY dbo.SF2010.F2_VEND1, VEN.A3_NREDUZ, dbo.SD1010.D1_FILIAL, dbo.SD1010.D1_EMISSAO) AS TMP
                    GROUP BY  CODIGO, NOME
                    ORDER BY CODIGO

                EndSql
            ELSE
                BeginSql alias cAlias1
                    SELECT         CODIGO, NOME,TIPO,CONVERT(VARCHAR(10),cast(EMISSAO as date),103) AS PERIODO,EMPRESA,DOCUMENTO, CLIENTE, SUM(DEVO) AS DEVO, SUM(N_vend) AS N_vend, SUM(N_itens) AS N_itens, SUM(Vendido + DESCONTO) AS Bruto, SUM(DESCONTO) AS DESCONTO, SUM(Vendido) AS Vendido, 
                                            SUM(Vendido - DEVO) AS BASE_COMISSAO, SUM(FRETE) AS FRETE
                    FROM            (SELECT        L1.L1_FILIAL AS EMPRESA, 'VENDA' AS TIPO, L1.L1_VEND AS CODIGO, VEN.A3_NREDUZ AS NOME, 0 AS DEVO, COUNT(*) AS N_vend, 0 AS N_itens, SUM(L1.L1_DESCONT) AS DESCONTO, 
                                                                        SUM(L1.L1_VLRLIQ) AS Vendido, SUM(L1.L1_FRETE) AS FRETE, L1.L1_EMISNF AS EMISSAO,L1.L1_DOC AS DOCUMENTO, A1.A1_NOME AS CLIENTE
                                            FROM            dbo.SL1010 AS L1 INNER JOIN
                                                                        dbo.SA3010 AS VEN ON L1.L1_VEND = VEN.A3_COD AND VEN.D_E_L_E_T_ <> '*' AND L1.D_E_L_E_T_ <> '*' 
                                                                        INNER JOIN dbo.SA1010 as A1 ON SUBSTRING(L1.L1_FILIAL,1,2)=A1.A1_FILIAL AND L1.L1_CLIENTE=A1.A1_COD 
                                                                        AND L1.L1_LOJA=A1.A1_LOJA AND A1.D_E_L_E_T_<>'*'
                                            WHERE         (L1.D_E_L_E_T_ <> '*') AND (L1.L1_TIPO <> '') AND (L1.L1_ORCRES = '') AND (L1.L1_EMISNF <> '') AND ((L1.L1_DOC <> '') OR (L1.L1_DOCPED <> ''))
                                            AND L1_EMISNF BETWEEN  %exp:DTOS(mv_par01)%	AND	%exp:DTOS(mv_par02)% 
                                            AND L1.L1_VEND BETWEEN  %exp:mv_par04%	AND	%exp:mv_par05% 
                                            GROUP BY L1.L1_FILIAL, L1.L1_VEND, VEN.A3_COD, VEN.A3_NREDUZ, L1.L1_EMISNF, L1.L1_DOC, A1.A1_NOME
                                            UNION ALL
                                            SELECT        L1.L1_FILIAL AS EMPRESA, 'VENDA' AS TIPO, L1.L1_VEND AS CODIGO, VEN.A3_NREDUZ AS NOME, 0 AS DEVO, 0 AS N_vend, COUNT(*) AS N_itens, SUM(IT.L2_VALDESC) AS DESCONTO, 
                                                                    0 AS Vendido, 0 AS FRETE, L1.L1_EMISNF AS EMISSAO,L1.L1_DOC AS DOCUMENTO, A1.A1_NOME AS CLIENTE
                                            FROM            dbo.SL1010 AS L1 INNER JOIN
                                                                    dbo.SA3010 AS VEN ON L1.L1_VEND = VEN.A3_COD AND VEN.D_E_L_E_T_ <> '*' AND L1.D_E_L_E_T_ <> '*' INNER JOIN
                                                                    dbo.SL2010 AS IT ON IT.L2_FILIAL = L1.L1_FILIAL AND IT.L2_NUM = L1.L1_NUM AND L1.D_E_L_E_T_ <> '*' AND IT.D_E_L_E_T_ <> '*'
                                                                    INNER JOIN dbo.SA1010 as A1 ON SUBSTRING(L1.L1_FILIAL,1,2)=A1.A1_FILIAL AND L1.L1_CLIENTE=A1.A1_COD 
                                                                    AND L1.L1_LOJA=A1.A1_LOJA AND A1.D_E_L_E_T_<>'*'
                                            WHERE         (L1.D_E_L_E_T_ <> '*') AND (L1.L1_TIPO <> '') AND (L1.L1_ORCRES = '') AND (IT.D_E_L_E_T_ <> '*') AND (L1.L1_EMISNF <> '') AND ((L1.L1_DOC <> '') OR (L1.L1_DOCPED <> ''))
                                            AND L1_EMISNF BETWEEN  %exp:DTOS(mv_par01)%	AND	%exp:DTOS(mv_par02)%
                                            AND L1.L1_VEND BETWEEN  %exp:mv_par04%	AND	%exp:mv_par05% 
                                            GROUP BY L1.L1_FILIAL, L1.L1_VEND, VEN.A3_COD, VEN.A3_NREDUZ, L1.L1_EMISNF, L1.L1_DOC,A1.A1_NOME
                                            UNION ALL
                                            SELECT        C5.C5_FILIAL AS EMPRESA, 'VENDA' AS TIPO, C5.C5_VEND1 AS CODIGO, VEN.A3_NREDUZ AS NOME, 0 AS DEVO, 0 AS N_vend, COUNT(*) AS N_itens, SUM(IT.C6_VALDESC) AS DESCONTO, 
                                                                    SUM(C6_VALOR) AS Vendido, 0 AS FRETE, F2.F2_EMISSAO AS EMISSAO,C5_NOTA AS DOCUMENTO, A1.A1_NOME AS CLIENTE
                                            FROM            dbo.SC5010 AS C5 INNER JOIN
                                                                    dbo.SA3010 AS VEN ON C5.C5_VEND1 = VEN.A3_COD AND VEN.D_E_L_E_T_ <> '*' AND C5.D_E_L_E_T_ <> '*' INNER JOIN
                                                                    dbo.SC6010 AS IT ON IT.C6_FILIAL = C5.C5_FILIAL AND IT.C6_NUM = C5.C5_NUM AND C5.D_E_L_E_T_ <> '*' AND IT.D_E_L_E_T_ <> '*' INNER JOIN
                                                                    dbo.SF2010 AS F2 ON F2.F2_FILIAL = C5.C5_FILIAL AND F2.F2_DOC = C5.C5_NOTA AND F2.F2_SERIE = C5.C5_SERIE AND F2.D_E_L_E_T_ <> '*' INNER JOIN 
                                                                    dbo.SF4010 AS F4 ON F4_CODIGO = C6_TES AND F4_FILIAL = SUBSTRING(C6_FILIAL,1,2) AND F4.D_E_L_E_T_ <> '*' AND IT.D_E_L_E_T_ <> '*' 
                                                                    INNER JOIN dbo.SA1010 as A1 ON SUBSTRING(C5.C5_FILIAL,1,2)=A1.A1_FILIAL AND C5.C5_CLIENTE=A1.A1_COD 
                                                                    AND C5.C5_LOJACLI=A1.A1_LOJA AND A1.D_E_L_E_T_<>'*'
                                            WHERE         (C5.D_E_L_E_T_ <> '*') AND (C5.C5_NOTA <> '') AND (IT.D_E_L_E_T_ <> '*') AND F4_DUPLIC = 'S' 
                                            AND F2.F2_EMISSAO BETWEEN  %exp:DTOS(mv_par01)% AND %exp:DTOS(mv_par02)%
                                            AND C5.C5_VEND1 BETWEEN  %exp:mv_par04%	AND	%exp:mv_par05% 
                                            GROUP BY C5.C5_FILIAL, C5.C5_VEND1, VEN.A3_COD, VEN.A3_NREDUZ, F2.F2_EMISSAO,C5.C5_NOTA, A1.A1_NOME
                                            UNION ALL
                                            SELECT        dbo.SD1010.D1_FILIAL AS EMPRESA, 'DEVOLUCAO' AS TIPO, dbo.SF2010.F2_VEND1 AS CODIGO, VEN.A3_NREDUZ AS NOME, SUM(dbo.SD1010.D1_TOTAL - dbo.SD1010.D1_VALDESC) AS DEVO, 
                                                                    0 AS N_vend, 0 AS N_itens, 0 AS DESCONTO, 0 AS Vendido, 0 AS FRETE, dbo.SD1010.D1_EMISSAO AS EMISSAO, dbo.SD1010.D1_DOC AS DOCUMENTO, A1.A1_NOME AS CLIENTE
                                            FROM            dbo.SD1010 INNER JOIN
                                                                    dbo.SF2010 ON dbo.SD1010.D1_FILIAL = dbo.SF2010.F2_FILIAL AND dbo.SD1010.D1_NFORI = dbo.SF2010.F2_DOC AND dbo.SD1010.D1_SERIORI = dbo.SF2010.F2_SERIE AND 
                                                                    dbo.SF2010.D_E_L_E_T_ <> '*' AND dbo.SD1010.D_E_L_E_T_ <> '*' INNER JOIN
                                                                    dbo.SA3010 AS VEN ON dbo.SF2010.F2_VEND1 = VEN.A3_COD AND VEN.D_E_L_E_T_ <> '*' 
                                                                    INNER JOIN dbo.SA1010 as A1 ON SUBSTRING(dbo.SD1010.D1_FILIAL,1,2)=A1.A1_FILIAL AND dbo.SD1010.D1_FORNECE=A1.A1_COD 
                                                                    AND dbo.SD1010.D1_LOJA=A1.A1_LOJA AND A1.D_E_L_E_T_<>'*'
                                            WHERE        (dbo.SF2010.D_E_L_E_T_ <> '*') AND (dbo.SD1010.D_E_L_E_T_ <> '*')
                                            AND D1_EMISSAO BETWEEN  %exp:DTOS(mv_par01)%	AND	%exp:DTOS(mv_par02)%
                                            AND dbo.SF2010.F2_VEND1 BETWEEN  %exp:mv_par04%	AND	%exp:mv_par05% 
                                            GROUP BY dbo.SF2010.F2_VEND1, VEN.A3_NREDUZ, dbo.SD1010.D1_FILIAL, dbo.SD1010.D1_EMISSAO, dbo.SD1010.D1_DOC,A1.A1_NOME ) AS TMP
                    GROUP BY  CODIGO, NOME,TIPO,EMISSAO,EMPRESA,DOCUMENTO, CLIENTE
                    ORDER BY CODIGO

                EndSql

            ENDIF
	END REPORT QUERY oSection1

	//Conta aproximadamente a quantidade de registros para definir o tamanho da regua de processamento.
	//Foi feito desta forma para melhorar o desempenho do processamento, fazendo a contagem dos registros de forma mais rapida.
	While (cAlias1)->( !EoF() )
		nQtdeRegs++
		(cAlias1)->(DbSkip(100))
	End
	nQtdeRegs := nQtdeRegs * 100
	(cAlias1)->(DbGoTop())

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁSe o parametro estiver 0, imprime todo o ranking.         Ё
	//ЁSe estiver com uma quantidade limitada deve ser controladoЁ
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea(cAlias1)
	oReport:SetMeter(nQtdeRegs)
	oSection1:Init()
	nItens:=1
    _ntQtdVen := 0
    _ntQtdIt := 0
    _ntDev := 0
    _ntBrut := 0
    _ntDesc := 0
    _ntLiq := 0
    _ntFret := 0
	_ntTotal := 0

    _nQtdVen := 0
    _nQtdIt := 0
    _nDev := 0
    _nBrut := 0
    _nDesc := 0
    _nLiq := 0
    _nFret := 0
	_nTotal := 0


    cChave := ""
	While (cAlias1)->( !EOF() )
		oReport:IncMeter()

		If oReport:Cancel()
			Exit
		EndIf
        IF EMPTY(cChave)
            cChave := (cAlias1)->CODIGO+" "+(cAlias1)->NOME
        ENDIF 



        IF cChave != (cAlias1)->CODIGO+" "+(cAlias1)->NOME .AND. MV_PAR03 != 1
            oSection2:Init()
            oSection2:Cell("TEXTO"):SetValue(cChave )
            oSection2:Cell("TEXTO"):SetClrBack(192192192)
            oSection2:Cell("TEXTO"):Show()

            oSection2:Cell("N_VEND"):SetValue( _nQtdVen )
            oSection2:Cell("N_VEND"):SetClrBack(192192192)
            oSection2:Cell("N_VEND"):Show()

            oSection2:Cell("N_ITENS"):SetValue( _nQtdIt )
            oSection2:Cell("N_ITENS"):SetClrBack(192192192)
            oSection2:Cell("N_ITENS"):Show()

            oSection2:Cell("DEVO"):SetValue( _nDev )
            oSection2:Cell("DEVO"):SetClrBack(192192192)
            oSection2:Cell("DEVO"):Show()

            oSection2:Cell("BRUTO"):SetValue( _nBrut )
            oSection2:Cell("BRUTO"):SetClrBack(192192192)
            oSection2:Cell("BRUTO"):Show()

            oSection2:Cell("DESCONTO"):SetValue( _nDesc )
            oSection2:Cell("DESCONTO"):SetClrBack(192192192)
            oSection2:Cell("DESCONTO"):Show()

            oSection2:Cell("VENDIDO"):SetValue( _nLiq )
            oSection2:Cell("VENDIDO"):SetClrBack(192192192)
            oSection2:Cell("VENDIDO"):Show()

            oSection2:Cell("FRETE"):SetValue( _nFret )
            oSection2:Cell("FRETE"):SetClrBack(192192192)
            oSection2:Cell("FRETE"):Show()

            oSection2:Cell("BASE_COMISSAO"):SetValue( _nTotal )
            oSection2:Cell("BASE_COMISSAO"):SetClrBack(192192192)
            oSection2:Cell("BASE_COMISSAO"):Show()

            oSection2:PrintLine()
            oSection2:Finish()


            _nQtdVen := 0
            _nQtdIt := 0
            _nDev := 0
            _nBrut := 0
            _nDesc := 0
            _nLiq := 0
            _nFret := 0
            _nTotal := 0
            cChave := (cAlias1)->CODIGO+" "+(cAlias1)->NOME

        ENDIF

        _nQtdVen += (cAlias1)->N_VEND
        _nQtdIt += (cAlias1)->N_ITENS
        _nDev += (cAlias1)->DEVO
        _nBrut += (cAlias1)->BRUTO
        _nDesc += (cAlias1)->DESCONTO
        _nLiq += (cAlias1)->VENDIDO
        _nFret += (cAlias1)->FRETE
        _nTotal += (cAlias1)->BASE_COMISSAO


        _ntQtdVen += (cAlias1)->N_VEND
        _ntQtdIt += (cAlias1)->N_ITENS
        _ntDev += (cAlias1)->DEVO
        _ntBrut += (cAlias1)->BRUTO
        _ntDesc += (cAlias1)->DESCONTO
        _ntLiq += (cAlias1)->VENDIDO
        _ntFret += (cAlias1)->FRETE
        _ntTotal += (cAlias1)->BASE_COMISSAO


		nItens++
		oSection1:PrintLine()
		(cAlias1)->( DbSkip() )
	End

    //TOTAIS DO ULTIMO VENDEDOR DO RELATORIO
    IF MV_PAR03 != 1
        oSection2:Init()
        oSection2:Cell("TEXTO"):SetValue(cChave )
        oSection2:Cell("TEXTO"):SetClrBack(192192192)
        oSection2:Cell("TEXTO"):Show()

        oSection2:Cell("N_VEND"):SetValue( _nQtdVen )
        oSection2:Cell("N_VEND"):SetClrBack(192192192)
        oSection2:Cell("N_VEND"):Show()

        oSection2:Cell("N_ITENS"):SetValue( _nQtdIt )
        oSection2:Cell("N_ITENS"):SetClrBack(192192192)
        oSection2:Cell("N_ITENS"):Show()

        oSection2:Cell("DEVO"):SetValue( _nDev )
        oSection2:Cell("DEVO"):SetClrBack(192192192)
        oSection2:Cell("DEVO"):Show()

        oSection2:Cell("BRUTO"):SetValue( _nBrut )
        oSection2:Cell("BRUTO"):SetClrBack(192192192)
        oSection2:Cell("BRUTO"):Show()

        oSection2:Cell("DESCONTO"):SetValue( _nDesc )
        oSection2:Cell("DESCONTO"):SetClrBack(192192192)
        oSection2:Cell("DESCONTO"):Show()

        oSection2:Cell("VENDIDO"):SetValue( _nLiq )
        oSection2:Cell("VENDIDO"):SetClrBack(192192192)
        oSection2:Cell("VENDIDO"):Show()

        oSection2:Cell("FRETE"):SetValue( _nFret )
        oSection2:Cell("FRETE"):SetClrBack(192192192)
        oSection2:Cell("FRETE"):Show()

        oSection2:Cell("BASE_COMISSAO"):SetValue( _nTotal )
        oSection2:Cell("BASE_COMISSAO"):SetClrBack(192192192)
        oSection2:Cell("BASE_COMISSAO"):Show()

        oSection2:PrintLine()
        oSection2:Finish()
    ENDIF


    //TOTAL GERAL

	oReport:SkipLine()

	oSection2:Init()
    oSection2:Cell("TEXTO"):SetValue( "GERAL " )
    oSection2:Cell("TEXTO"):SetClrBack(192192192)
    oSection2:Cell("TEXTO"):Show()

    oSection2:Cell("N_VEND"):SetValue( _ntQtdVen )
    oSection2:Cell("N_VEND"):SetClrBack(192192192)
    oSection2:Cell("N_VEND"):Show()

    oSection2:Cell("N_ITENS"):SetValue( _ntQtdIt )
    oSection2:Cell("N_ITENS"):SetClrBack(192192192)
    oSection2:Cell("N_ITENS"):Show()

    oSection2:Cell("DEVO"):SetValue( _ntDev )
    oSection2:Cell("DEVO"):SetClrBack(192192192)
    oSection2:Cell("DEVO"):Show()

    oSection2:Cell("BRUTO"):SetValue( _ntBrut )
    oSection2:Cell("BRUTO"):SetClrBack(192192192)
    oSection2:Cell("BRUTO"):Show()

    oSection2:Cell("DESCONTO"):SetValue( _ntDesc )
    oSection2:Cell("DESCONTO"):SetClrBack(192192192)
    oSection2:Cell("DESCONTO"):Show()

    oSection2:Cell("VENDIDO"):SetValue( _ntLiq )
    oSection2:Cell("VENDIDO"):SetClrBack(192192192)
    oSection2:Cell("VENDIDO"):Show()

    oSection2:Cell("FRETE"):SetValue( _ntFret )
    oSection2:Cell("FRETE"):SetClrBack(192192192)
    oSection2:Cell("FRETE"):Show()

    oSection2:Cell("BASE_COMISSAO"):SetValue( _ntTotal )
    oSection2:Cell("BASE_COMISSAO"):SetClrBack(192192192)
    oSection2:Cell("BASE_COMISSAO"):Show()

	oSection2:PrintLine()
	oSection2:Finish()

	oSection1:Finish()

return
