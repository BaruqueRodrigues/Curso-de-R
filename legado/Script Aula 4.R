###  Aula 4 - Data Wrangling pt 2 ###
#Para instalar os pacotes
install.packages(c("tidyverse", "nycflights13"))

library(tidyverse) # Chamando o pacote a ser utilizado na aula

library(nycflights13) # Dataset para manipulação

## Revisão:

# Selecionar observações por seu valores
dplyr::filter()

# Reordenar linhas
dplyr::arrange()

# Selecionar colunas por seus nomes
dplyr::select()

# Criar e Alterar Novas Variáveis com funções em variáveis existentes
dplyr::mutate()

# Sumarisar valores
dplyr::summarise()

# Opera funções agrupando por variáveis
dplyr::group_by()

## Filter
flights

# Filtro simlples
filter(flights, month == 1)

# Filtrando mais de uma variável ao mesmo tempo

filter(flights, month == 1, day == 1)

# Filtrando dois valores dentro da mesma variável

filter(flights, month == 11 | month == 12)


filter(flights, month %in% c(11, 12))

# Utilizando operadores para filtros complexos

# filtrando atrasos
filter(flights, !(arr_delay > 120 | dep_delay > 120))

filter(flights, arr_delay <= 120, dep_delay <= 120)

# PS: Qual a diferença entres os filtros acima?

## arrange()

# Reordenando as colunas
flights
arrange(flights, year, month, day)

# Reordenando pela ordem decrescente de uma variável

arrange(flights, desc(dep_delay))

## select()

# selecionando 3 colunas

flights
select(flights, year, month, day)

# Utilizando operadores para selecionar colunas

flights
select(flights, year:day)

# Utilizando o select para remover colunas

flights
select(flights, -(year:day))

# Usando o everything()
select(flights, time_hour, air_time, everything())

# Funções para complementar o dplyr::select()

# Seleciona valores iniciados com
dplyr::starts_with()


# Seleciona valores terminado com
dplyr::ends_with()

# Seleciona valores que contem
dplyr::contains()

# Seleciona valores que contem uma expressão regular
dplyr::matches()

# Seleciona valores dentro de um vetor numerico
dplyr::num_range()

## mutate

# Criando um dataset
a<-select(flights, 
       year:day, 
       ends_with("delay"), 
       distance, 
       air_time)

# Fazendo uso do mutate para criar novas variáveis
mutate(a,
       ganho = dep_delay - arr_delay,
       velocidade = distance / air_time * 60)

# Posso manipular colunas recem criadas

mutate(a,
       ganho = dep_delay - arr_delay,
       horas = air_time / 60,
       ganho_hr = ganho / horas)

# Para manter apenas novas variáveis usamos o transmute

transmute(a,
       ganho = dep_delay - arr_delay,
       horas = air_time / 60,
       ganho_hr = ganho / horas)

# Podemos usar algunas funções para tornar o mutate mais poderoso

#somas cumulativas
cumsum()

# produtos cumulativos
cumprod()

# minimos cumulativos
cummin()

# maximos cumulativos
cummax()

# médias cumulativas
cummean()

# Soma dos valores das linhas
rowsum()

# Média do valor das linhas
rowMeans()

# Número da linha
row_number()

# ranqueia os valores
min_rank()

# ranqueia em densidade
dense_rank()

# ranqueia em percentuais
percent_rank()

#
cume_dist()

#
ntile()

# Datasets utilizados:

table1
table2
table3
table4a
table4b
table5

## Gather, Spread e Pivot 

# Apresentando o conceito de Long Data

# Long Data
atv1<-data.frame(ativo = c("PETR4", "MULT3",
                           "MGLU3", "OIBR4"),
                 valor = c( 28.74,10.53,
                            21.14,1.86))

# Wide Data
atv2<-data.frame('PETR4'=28.74,
           'MULT3'=10.53,
           'MGLU3'=21.14,
           'OIBR4'=1.86)
# Vendo Ambos
atv1;atv2

# gather() Juntando Variáveis

atv2

#Usando o gather
gather(atv2, #banco de dados a ser juntado
       key = ativo, # variável que contem o nome das colunas
       value = valor # variavel com valor a ser preenchido
       )
#usando o pipe
atv2%>%gather(ativo, # variável q contem o nome das colunas
              valor # variavel com valor a ser preenchido)
)
# E se o banco tiver variável que devem ser juntas e variáveis que não devem ser juntas

gather(table4a,
       ano,
       pop,
       -country)

table4a

table4a%>%gather(ano, pop, -country)

table4b%>%gather(ano, cases, -country)

#Usando o tidyr::pivot_longer
table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "casos")

table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "pop")
# usamos o - antes do nome da coluna para identificar que essa variável não estará no procesos.

## spread() - Espalhando as variáveis pelo dataset

atv1
spread(atv1, key = ativo, value = valor)

#usando o pipe
atv1%>%spread(key = ativo, value = valor)


table2%>%spread(key = type, value =count)

#Usando o Pivot wider
table2 %>%
  pivot_wider(names_from = type, values_from = count)


## Usando o tidyr::separate

table3

table3%>%separate(rate, into = c("cases", "population"))

# Fazendo uso do argumento sep
table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/")

# Fazendo uso do argumento convert
table3 %>% 
  separate(rate, into = c("cases", "population"), convert = TRUE)

# Outras formas de usar o tidyr::separate
table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)

## usando o tidyr::unite

table5

table5 %>% 
  unite(new, century, year)

# Fazendo uso do argumento sep
table5 %>% 
  unite(new, century, year, sep = "")

