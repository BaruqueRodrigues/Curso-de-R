### Baixando Dados Direto do Banco Mundial ###

#instalar o pacote do banco mundial
install.packages("WDI")
library(WDI) # baixar indicadores do banco mundial
library(tidyverse)

#Uso a função WDIsearch para fazer a pesquisa

WDIsearch('expenditure on education') %>% View()

#Uso a função WDI para capturar os dados do indicador

#Control of Corruption: Estimate via WDI
corruption<-WDI(indicator='CC.EST', start=2010, end=2016) #dados de corrupção banco mundial

#Government expenditure on education, PPP$ (millions)
ee<-WDI(indicator = 'UIS.X.US.FSGOV', start=2010, end=2016) #dados de gastos com educação banco mundial

#GDP per capita (constant 2000 US$)
ppc<-WDI(indicator='NY.GDP.PCAP.KD', start=2010, end=2016)

#Gini inequality index reduction (%) - All Social Protection and Labor
gin<-WDI(indicator = "per_allsp_gini_tot", start=2010, end=2016)

#Uso a Função Merge para juntar os datasets

a<-merge(corruption,ee, by = c("iso2c", "country", "year") )

a<-merge(a,ppc, by = c("iso2c", "country", "year") )

a<-merge(a, gin[2:4], by = c("country", "year"), all.x = T)
