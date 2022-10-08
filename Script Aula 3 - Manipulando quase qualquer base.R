### Script Aula 4 - Manipulando quase qualquer base;

# Entendendo o conceito de datasets Wide e Long

# Vamos carregar o tidyverse
library(tidyverse)

# E fazer uso de alguns datasets do pacote tidyr

# Um dataset pode apresentar os dados de multiplas maneiras. No exemplo abaixo
# vemos alguns exemplos

# Dataset com todas as informações
tidyr::table1

# Dataset em um formato Wide
tidyr::table4a #cases

tidyr::table4b # population

# Um dataset está organizado quando 1. cada variável tem sua própria coluna
# 2. Cada observação tem sua própria linha
# 3. Cada valor está em sua própria célula

# No dataset table 1 temos um exemplo de tidy dataset. o R funciona melhor com tidy data

# E como transformar um dataset para um formato tidy

# Uma da possibilidades é usando pivoting

table4a

# Como transformar o dataset table4a em um formato tidy? o que Devemos mudar?

table4a %>% #dataset que receberá a função
  pivot_longer( # Usamos a função pivot_longer
    c(`1999`, `2000`), #Indicamos as colunas que sofrerão a transformação
    names_to = "year", #Indicamos a coluna que receberá valor de classificação
    values_to = "cases"#Indicamos a coluna que receberá os valores
    )

# Sempre que quisermos organizar um dataset em um formato long, 
#usaremos a função tidyr:: pivot_longer

table4b %>% #dataset que receberá a função
  pivot_longer( # Usamos a função pivot_longer
    c(`1999`, `2000`), #Indicamos as colunas que sofrerão a transformação
    names_to = "year", #Indicamos a coluna que receberá valor de classificação
    values_to = "population"#Indicamos a coluna que receberá os valores
  )

# Um outro exemplo de datasets que não estão em formato tidy é o dataset table2

table2

# Observem que a coluna type tem multiplas variáveis dentro da mesma coluna.
# Onde cada observação é um pais em um determinado ano, mas cada observação
#está espalhada em duas linhas, já que temos 2 variáveis em type.

# Para transformamos esse dataset em um formato tidy usando a função tidyr::pivot_wider()

table2 %>%
  pivot_wider(names_from = type, # coluna que contém as variáveis
              values_from = count # coluna que contém os valores das variáveis
              )


### Revisão

# importe o dataset dados_b3_2010_2022.csv
# remova a 1° coluna
# Transforme o dataset para o formato tidy

dados_b3_2010_2022.csv <- readr::read_csv("https://raw.githubusercontent.com/BaruqueRodrigues/Curso-de-R/master/dados/dados_b3_2010_2022.csv")

dados_b3_2010_2022.csv %>% 
  select(-1) %>% 
  pivot_wider(names_from = ticker,
              values_from = ret_adjusted_prices)


# Transforme o dataset abaixo para o formato tidy()

people <- tribble(
  ~name,             ~names,  ~values,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)

### Separando e juntando dados

# Alguns datasets tem particularidades,onde os valores das colunas ficam aninhandos
#dentro de celulas como no dataset table3

tidyr::table3

# Quando nos deparamos com esses tipo de problema temos uma solução muito simples
#a função tidyr::separate

table3

# Aqui vamos separar a coluna rate, que junta os valores de cases e population

table3 %>% # dataset que receberá a função
  separate( # função que irá separar a coluna
    rate, # coluna que será separada
    sep = "/", # argumento que deve ser separado
    into = c("cases", "population") # nome das colunas que serão separadas
  )

# Podemos usar a função separate de diversar formas, de maneira quase ilimtada

table3 %>% # dataset que receberá a função
  separate(# função que irá separar a coluna
    year, # coluna que será separada
    into = c("century", "year"), # nome das colunas que serão separadas
    sep = 2 # argumento que deve ser separado
    )

# Caso tenhamos que juntar valores que estão separados em colunas diferentes
#podemos usar a função unite

table5

# Nesse caso juntaremos as colunas century e year

table5 %>% # dataset que receberá a função
  unite( # função que juntará as colunas
    ano_completo, # nova coluna
    century, year, #colunas que serão juntas
    sep = "" #separador 
    )

### Revisão

# Importe o dataset pedidos
# remova a primeira linha e transforme ele em um formato tidy
# 1. onde a descrição por pedido seja separado em multiplos itens
# 2. o dataset tenha um formato long

pedidos <- readr::read_csv(
  "https://raw.githubusercontent.com/BaruqueRodrigues/Curso-de-R/master/dados/pedidos.csv")

pedidos %>% 
  select(-1) %>% 
  separate(descricao_por_pedido,
           into = c("item_1",
                    "item_2",
                    "item_3",
                    "item_4",
                    "item_5"),
           sep = ",") %>% 
  pivot_longer(c(item_1:item_5),
               names_to = "item_pedido",
               values_to = "desc_pedido") 

### lidando com Missing Data

# Existem 3 funções poderosas que podemos usar para lidar com dados ausentes
#são elas drop_na(), fill(), replace_na()

#usaremos o dataset pedidos, que usamos na revisão para exemplificar
pedidos_final <- pedidos %>% 
  select(-1) %>% 
  separate(descricao_por_pedido,
           into = c("item_1",
                    "item_2",
                    "item_3",
                    "item_4",
                    "item_5"),
           sep = ",") %>% 
  pivot_longer(c(item_1:item_5),
               names_to = "item_pedido",
               values_to = "desc_pedido") 

pedidos_final

# drop_na() lida com dados ausentes removendo eles do dataset

pedidos_final %>% 
  drop_na()

# fill() vai preencher os valores ausentes com um valor da coluna usando o 
#valor mais próximo do dado ausente
# A função fill é utilizada apenas para variáveis numéricas


# replace_na vai substituir os dados ausentes por valores especificados

pedidos_final %>% 
  replace_na(# função que vai substituir NA pelo valor desejado
    list( # usamos a função list pois podemos inserir várias colunas
      desc_pedido = "item_ausente" #indicando o substituto por coluna
      )
    )

### Transformando vetores de texto em datasets

# Muitas vezes recebemos dados em formato de lista, ou formato textual 
#e precisamos transforma-los para um formato de dataset

# Uma das funções mais poderosas pra esse objetivo a a função tibble::enframe()

dados_lista <- list(times = c("flamengo", "fluminense", "vasco", "botafogo"),
     titulos_liberta = c(2, "virgem das americas", 1, "bairro"),
     copas_br = c(3, 1, 1, "bairro"),
     brasileiros = c(8,4,4,1)) 

# Utilizando o enframe para transformar uma lista em um dataset

dados_lista %>% 
  enframe()

# Observe que diferente de um dataset comum, as colunas estão como formato list
dados_lista %>% 
  enframe()

# Olhando mais de perto

dados_lista %>% 
  enframe() %>% 
  View()

#  Para transformar em um formato usual devemos transformar esse dataset em formato tidy
dados_lista %>% 
  enframe() %>% 
  pivot_wider(names_from = name,
              values_from = value) 

# Para transformar em um formato usual podemos usar as funções unnest_wider e unnest_longer
#unnest_wider espalha os valores colunas, unnest_longer em linhas

dados_lista %>% 
  enframe() %>% 
  pivot_wider(names_from = name,
              values_from = value) %>% 
  unnest_longer(c(times:brasileiros))


### Aplicando funções para multiplas colunas

# Quando queremos operacionalizar uma função entre multipla colunas podemos usar
#as funções com a terminação all

iris %>% # dataset que irá receber a função
  tibble() %>% # transformando em tibble
  mutate_all( as.character())

iris %>% # dataset que irá receber a função
  tibble() %>% # transformando em tibble
  summarise_all(mean)

# Mas quando queremos declarar as colunas usamos odplyr::across

# Por exemplo transformar o formato de multiplas colunas para character
iris %>% # dataset que irá receber a função
  tibble() %>% # transformando em tibble
  mutate(across( # aplica uma função há uma série de colunas
    c(Sepal.Length, Sepal.Width),  #colunas que irão receber a função
                as.character #função desejada
    ))

# Ou por exemplo arredondar multiplas colunas

iris %>% # dataset que irá receber a função
  tibble() %>% # transformando em tibble
  mutate(across( # aplica uma função há uma série de colunas
    c(Sepal.Length, Sepal.Width), #colunas que irão receber a função
    round #função desejada
    ))

iris %>% # dataset que irá receber a função
  tibble() %>% # transformando em tibble
  group_by(Species) %>% 
  summarise(across(# aplica uma função há uma série de colunas
    c(Sepal.Length:Petal.Width), #colunas que irão receber a função
                   list(min, mean, sd, max), # lista de funções
                   na.rm = TRUE #argumento extra
    
  ))
  
### Eninhando dados

# A função nest nos permite juntar elementos dentro de uma coluna de um dataset

mpg %>% 
  nest(-model)

# A partir disso podemos fazer multiplas análises

# Como por exemplo performas multiplas regressões 
mpg %>% 
  nest(-model) %>% 
  mutate(lm_model = map(data, ~lm(hwy~cty+cyl, data =.)),
         lm_model = map(lm_model, broom::tidy)
         ) %>% 
  unnest(lm_model)
  
# Ou por exemplo performar multiplos testes T
t_test_1 %>%  # dataset com as variaveis para o teste t
  select(-grupo) %>% 
  gather(name, value, -grupo_rec) %>% 
  nest(-name) %>% 
  mutate(teste_t = map(data, ~t.test(value~grupo_rec, data = .)))

# Inserir um gráfico de dispersão
mpg %>% 
  nest(-model) %>%
  mutate(grafico = map(data, ~ggplot(data = .,
                                     aes(x = hwy, y = cty))+
                         geom_point()))


  

