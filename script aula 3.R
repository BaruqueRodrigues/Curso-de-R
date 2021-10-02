### Aula 3 - Data Wrangling pt 1 ###

#instalando pacotes externos

install.packages(c("poliscidata", "tidyverse"))

# Chamando Pacotes
library(poliscidata) # função usada para chamar pacotes externos ao R
library(tidyverse)

# Vendo as descrições do pacote
??tidyverse # usamos uma interrogação antes do pacote


nes<-poliscidata::nes

names(nes) # Função que retorna o nome das colunas do objeto;

count(nes) # Função que conta o número ocorrências do objeto

length(nes) # Função que retorna o tamanho do objeto

nes # Visualizo o meu objeto 

glimpse(nes) # Visualizo dataframes em formato tabular

### Apresentando as funções de manipulação de dados do pacote dplyr

## Vamos fazer uso do dataframe t, do exercício 1

# Para fazer filtros dentro das linhas uso a função dplyr::filter()

filter(# função que faz o filtro
      t, # dataframe que sofrerá o filtro
      maioria_feminina == "não" # seleciono a coluna e o tipo de filtro
)

# Para selecionar colunas de um data.frame utilizo a função dplyr::select()

select( #função que seleciona as colunas
  t, # dataframe que contem as colunas
  estado, classe_predominante, matches
)


## Fazendo a manipulação no dataframe nes utilizando o pipe

# pipe %>% , |>
# o atalho para o pipe é ctrl+shift+m
select(nes, ftgr_cons, dem_raceeth, voted2012,
       science_use, preknow3, obama_vote,
       income5, gender)

# selecionando as colunas para fazer a nossa análise
nes%>%select(ftgr_cons, dem_raceeth, voted2012,
                  science_use, preknow3, obama_vote,
                  income5, gender)

#filtrando para apenas os eleitores que votaram
nes %>% filter(voted2012=="Voted")

# Contatenar funções com pipe
nes<- nes %>% select(ftgr_cons, dem_raceeth, voted2012,
              science_use, preknow3, obama_vote,
              income5, gender) %>% 
              filter(voted2012=="Voted") 

# na função acima, passamos o nosso objeto, executamos a primeira função e
# utilizamos o pipe %>% para executar uma outra função no objeto

# Vendo o produto do nossa data wrangling

glimpse(nes)

# para recodificar variáveis uso a função dplyr::recode()

nes$obama_vote%>% # objeto que contem a recodificação
 recode(# função que recodifica variáveis
        `1` = "yes", # objeto 1 a ser recoficado para a string "yes"
        `0` = 'no' # objeto 0 a ser recodificado para a string 'no'
 )

# para fazer manipulações dentro das variáveis, utilizo a função dplyr::mutate

# Criando uma variável
nes%>% # objeto que contem a recodificação
  mutate( #
          obama_vote2 = recode( # função que recodifica variáveis
          obama_vote, # coluna que terá os valores recodificados
          `1` = "yes", # objeto 1 a ser recoficado para a string "yes"
          `0` = 'no' # objeto 0 a ser recodificado para a string 'no'
  ))

# criando o matches per capita nos estados do banco exercício da aula 1

t%>%mutate(matche_per_capita = matches/matches.brasil
    
)

# recodificando a raça do dataframe nes

nes%>%glimpse() #vendo o dataframe
table(nes$dem_raceeth) #vendo as ocorrências da variável com a função table()

#recodificando em eleitores brancos e não brancos de uma forma lenta
nes%>%mutate(dem_raceeth = recode(dem_raceeth,
                                  '1. White non-Hispanic' = "Whites",
                                  '2. Black non-Hispanic' = "Non-Whites",
                                  '3. Hispanic' = 'Non-Whites',
                                  '4. Other non-Hispanic' = 'Non-Whites'))

#recodificando em eleitores branco e não brancos de uma forma rápida
nes%>%mutate(dem_raceeth = recode(dem_raceeth,
                                  '1. White non-Hispanic' = "Whites",
                                  .default = "Non-Whites" #fazendo uso da função .default
                                                          #tudo o que restar será "Non-Whites"
                                  ))

#recodificando a variável fgtr_cons em  ideology
nes$ftgr_cons%>%table() #visualizando a distribuição da variável

# forma 1 fazer uso do mutate e do recode, recodificando 1 valor por 1
# PROBLEMÁTICO, SÃO 100 VALORES

#forma 2, fazer uso do case_when

#criando a variável ideology e agregando os valores em 3 dimensões
nes%>%mutate(ideology = case_when(
                                  ftgr_cons <= 33 ~ 'liberals',
                                  ftgr_cons > 34 & ftgr_cons <= 67 ~ 'center',
                                  ftgr_cons > 67 ~ 'conservatives'
))


### fazendo toda a manipulação conjunta

nes<-nes%>% 
  mutate(obama_vote = recode(obama_vote, 
                              `1` = "yes", 
                              `0` = 'no'),
         
         dem_raceeth = recode(dem_raceeth,
                         '1. White non-Hispanic' = "Whites",
                         .default = "Non-Whites"),
         ideology = case_when(
         ftgr_cons <= 33 ~ 'liberals',
         ftgr_cons > 34 & ftgr_cons <= 67 ~ 'center',
         ftgr_cons > 67 ~ 'conservatives')
         )
# fazendo sumarizações dentro dos dados utilizando a função dplyr::summarise e dplyr::group_by

# vendo entre os individuos que consomem midias científicas o nível de conservadorismo
nes$science_use%>%table()

#a média de conservadorismo por grupo de consumo de ciência
nes%>%group_by(science_use)%>% #uso o a função dplyr::group_by para agrupar os resultados por essa variável 
      summarise(#função que retorna uma sumarização dos valores
        'média de conversadorismo por grupo' = mean(ftgr_cons, na.rm = TRUE ))

#a soma de conservadorismo para o grupo
nes%>%group_by(science_use)%>% #uso o a função dplyr::group_by para agrupar os resultados por essa variável 
  summarise(#função que retorna uma sumarização dos valores
    sum(ftgr_cons, na.rm = TRUE ))
# o desvio padrão
nes%>%group_by(science_use)%>% #uso o a função dplyr::group_by para agrupar os resultados por essa variável 
  summarise(#função que retorna uma sumarização dos valores
    sd(ftgr_cons, na.rm = TRUE ))
#a variância

nes%>%group_by(science_use)%>% #uso o a função dplyr::group_by para agrupar os resultados por essa variável 
  summarise(#função que retorna uma sumarização dos valores
    var(ftgr_cons, na.rm = TRUE ))
#os valores minimos
nes%>%group_by(science_use)%>% #uso o a função dplyr::group_by para agrupar os resultados por essa variável 
  summarise(#função que retorna uma sumarização dos valores
    'minimo de conservadorismo por grupo ' = min(ftgr_cons, na.rm = TRUE ))
# os valores máximos
nes%>%group_by(science_use)%>% #uso o a função dplyr::group_by para agrupar os resultados por essa variável 
  summarise(#função que retorna uma sumarização dos valores
    'max de conservadorismo por grupo' = max(ftgr_cons, na.rm = TRUE ))

#Criando uma tabela descritiva dos valores

nes%>%group_by(dem_raceeth)%>%
      summarise(Minimos = min(ftgr_cons, na.rm = TRUE),
                'Média' = mean(ftgr_cons, na.rm = TRUE),
                'Desvio Padrão' = sd(ftgr_cons, na.rm = TRUE),
                'Variância' = var(ftgr_cons, na.rm = TRUE),
                'Máxima' = max(ftgr_cons, na.rm = TRUE))

nes%>%group_by(dem_raceeth, science_use)%>%
  summarise(Minimos = min(ftgr_cons, na.rm = TRUE),
            'Média' = mean(ftgr_cons, na.rm = TRUE),
            'Desvio Padrão' = sd(ftgr_cons, na.rm = TRUE),
            'Variância' = var(ftgr_cons, na.rm = TRUE),
            'Máxima' = max(ftgr_cons, na.rm = TRUE))

## arrange()

# Reordenando as colunas

nes %>% arrange(voted2012, science_use)
