### Manipulação de Dados - Saindo do 0 ###

# instalando pacotes externos

install.packages(tibble) # formato tabular
install.packages(dplyr) # manipulação de dados
install.packages(lubridate) # manipulação de datas
install.packages(forcats) # manipulação de factors

# Lendo a documentação dos pacotes

??tibble
??dplyr
??lubridate
??forcats

# Apresentando o maravilhoso tibble
# Uma versão melhorada do data.frame

library(tibble) #carregando o pacote

## Observando as diferenças

data.frame(iris)
tibble::tibble(iris)

dados_data.frame <- data.frame(pessoa = c("Lucas", "Gabriel", "pedro"),
           comida_favorita = list(list("bolo", "uva", "brigadeiro"), "churrasco", "pizza"),
           cor_favorita = list("azul", list("vermelho", "preto"), "laranja" ),
           time = c("flamengo", "flamengo", "flamengo"))

dados_tibble <- tibble::tibble(pessoa = c("Lucas", "Gabriel", "pedro"),
               comida_favorita = list(list("bolo", "uva", "brigadeiro"), "churrasco", "pizza"),
               cor_favorita = list("azul", list("vermelho", "preto"), "laranja" ),
               time = c("flamengo", "flamengo", "flamengo"))

dados_data.frame
dados_tibble


## O formato tibble permite que todos os tipos de vetores do R seja inseridos.

# Iniciando os contatos imediatos com o dplyr

## Antes de tudo, leiam a documentação

??dplyr

library(dplyr) #carrega o pacote

## dplyr o pacote que facilita a vida de quem está tratando dados

# faremos uso do dataset starwars carregado pelo dplyr

starwars

# O dplyr oferece a função glimpse que resume um dataframe em formato tabular

dplyr::glimpse(starwars)



## O básico do dplyr pode ser definido como Funções que lidam com Linhas e com Colunas

# Funções que lidam com linhas

## Seleciona linhas dado valor
dplyr::filter(.data = starwars,
              species == "Droid")

## Seleciona uma linha baseado em um valor
dplyr::slice(.data = starwars,
             1:5)

## Altera a ordem das linhas
dplyr::arrange(.data = starwars,
               height)

# E funções que lidam com colunas

## A função pull puxa os valores de uma coluna

dplyr::pull(starwars, name = name)


## a função select seleciona as columas de um dataframe.
dplyr::select(.data = starwars,
              name, height, species)

# já a função rename renomeia as columas de um dataframe

dplyr::rename(starwars,
              nome = name,
              altura = height, 
              peso = mass,
              cabelo = hair_color,
              cor_da_pele = skin_color)

## a função mutate permite criar e alterar valores das colunas

## criando um tibble mais resumido
starwars_resumido <- starwars %>% 
  select(name, height, species)

## aplicando o mutate
starwars_resumido <- starwars_resumido %>% 
  mutate(altura_agregada = ifelse(height >180, "alto", "baixo"),
         alienigena = ifelse(!species %in% c("Human", "Droid"), "Alienigena", "Terraqueo"))

starwars_resumido

## E se eu quiser recodificar uma variável devo usar sempre o ifelse?
## Jamais, use a função recode.

starwars %>% 
  select(name, eye_color) %>% 
  mutate(eye_color = recode(eye_color,
                                  "black" = "preto",
                                  "blue" = "azul",
                                  "yellow" = "amarelo",
                                  "blue-gray" = "azul acinzentado",
                                  "red" = "vermelho",
                                  "brown" = "marrom"))

## Mas se você quiser recodificar um valor numerico?
## Use o case_when

starwars %>% 
  select(name, height, mass) %>% 
  mutate(altura_recodificado = case_when(
    height <= 120 ~ "pequenino",
    height >= 121 & height  <= 165 ~ "pequeno",
    height >=  165 & height <= 180 ~ "mediano",
    height >=  180 & height <= 200 ~ "alto",
    height >200 ~ "gigantesco"
  ) )

# O case_when funciona como um ifelse vetorizado. Muito útil e um coringa na 
#manipulação de dados

# já a função relocate permite reordenar a posição das colunas

starwars_resumido %>% 
  relocate(altura_agregada, .after = height)

# Já a função summarise nos permite fazer análises de grupo em uma única linha

## vamos ver a altura média entre humanos e androids

starwars_resumido %>% 
  filter(species %in% c("Human", "Droid")) %>% # filtro as especies em humanos e droids
  group_by(species) %>% # agrupo pela coluna especies
  summarise("altura média" = mean(height,
                                  na.rm = T # o argumento na.rm remove os valores de NA
                                  )) #sumariso a média dos grupos 

## criando a tabela descritiva clássica


starwars_resumido %>% 
  filter(species %in% c("Human", "Droid")) %>% # filtro as especies em humanos e droids
  group_by(species) %>%
  summarise(Minimos = min(height, na.rm = TRUE),
            'Média' = mean(height, na.rm = TRUE),
            'Desvio Padrão' = sd(height, na.rm = TRUE),
            'Variância' = var(height, na.rm = TRUE),
            'Máxima' = max(height, na.rm = TRUE))

### É hora da revisão

# Encontre os Droids que tem entre 120 e 180 de altura

starwars %>% 
  filter(species == "Droid",
         height >= 90 & height <= 180)

# Encontre os moradores de Tatooine e Naboo
starwars %>% 
  filter(homeworld %in% c("Tatooine", "Naboo"))

# Mostre quem é o morador mais alto de Tatooine

starwars %>% 
  filter(homeworld == "Tatooine") %>% 
  arrange(desc(height))
# Produza um tibble com as name, sex, gender, homeworld e mass

starwars %>% 
  select(name, sex, gender, homeworld, mass)

# Traduza os valores das variaveis sex, gender e homeworld do dataset gerado acima.

# Crie uma variável que recodifique a variável mass em 5 grupos. 

### Pacote lubridate

# Pacote que serve para lidar com datas em R

library(lubridate)

formatos_data <- tibble(dmy = 28092022,
                        ymd = 20220928,
                        dmy_sep_traco = "28-SET-2022",
                        dmy_sep_barra = "28/09/2022")

formatos_data
# gerando dados formato dia mes ano
formatos_data %>%
  mutate(dmy_sep_traco = dmy(dmy_sep_traco))
#gerando dados formato ano mes dia
formatos_data %>%
  mutate(ymd = ymd(ymd))

# Usamos funções pra extrair elementos de data
formatos_data %>%
  mutate(ymd = ymd(ymd),
         ano = year(ymd), #extrai o ano
         mes = month(ymd), #extrai o mes
         dia = day(ymd), #extrai o dia
         segundos = second(ymd) #extrai os segundos
         ) 


#Operações matematicas com datas.

tibble_datas <- tibble(data_inicial = dmy(c("01-01-2012",
                        "05-03-2009",
                        "10-01-2013",
                        "22-12-2005",
                        "23-11-2019")),
       data_final = dmy(c("09-07-2022",
                      "04-09-2022",
                      "08-04-2022",
                      "18-11-2022",
                      "16-10-2022")))

# para fazer as operações utilizamos a função timelenght
tibble_datas %>% 
  mutate(dif_em_dias = time_length(data_final - data_inicial, "days"),
         dif_em_meses = time_length(data_final - data_inicial, "months"),
         dif_em_anos = time_length(data_final - data_inicial, "years"))

### Forcats


### Exercícios

# utilize o dataset nes do pacote poliscidata para fazer as analises

# Crie um dataset resumido com as variáveis ftgr_cons, dem_raceeth, voted2012,
#science_use, preknow3, obama_vote, income5, gender, filtrando para apenas os eleitores que votaram em 2012


# recodifique a variável obama_vote para uma dummy com sim ou não.

# recodifique a variável dem_raceeth entre brancos e não brancos

# recodifique a variável ideology em 3 grupos esquerda, centro e direita

# Calcule a média de conservadorismo (fgtr_cons) por grupo de consumo de ciência

# Calcule o n° de individuos que são conservadores por grupo de consumo de ciência

# Calcule o desvio padrão de individuos que são conservadores por grupo de consumo de ciência

# Calcule o variancia de individuos que são conservadores por grupo de consumo de ciência

### PT2

## usaremos o dataset nycflghts

nycflights13::flights

# crie um dataset com os voos de 1 de janeiro

# crie um dataset com os voos de novembro ou dezembro

# Crie um dataset com atrasos (arr_delay e dep_delay) de mais de 120 minutos

# Sabendo a variável  distance mede a distancia percorrida e a variávle air_time o tempo no car
# crie um dataset que contenha essas 2 variáveis e uma outra variável que calcule a velocidade em minutos


# Crie uma variável que calcule a média de velocidade por ano

# Crie um dataset que selecione os 5 voos (flight) mais rápidos