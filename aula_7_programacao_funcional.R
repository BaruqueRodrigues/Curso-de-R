### Programação funcional

library(tidyverse)

# O que é programação funcional -------------------------------------------------------------------------

# O fato de que funções são objetos de primeira classe no R,
#ou seja, objetos que têm propriedades iguais às de qualquer outro,
#possibilita a programação no estilo funcional.

# A programação funcional inclui as formas de interação entre vetores e funções a partir de uma função


tibble(" " = c("vetor", "função"),
       "Vetor" = c("função regular", "Funcional"),
       "Função" = c("Fábrica de Funções", "Operador de Função")) %>% 
  gt::gt()

# loops? ------------------------------------------------------------------
# nesse curso não veremos loops por 2 motivos.
# 1. a caracteristica funcional do R faz com que a grande maioria dos loops sejam desnecessários.
# O código fica mais limpo e expressivo é mais fácil de fazer manutenção, 
#e é mais fácil de ser compreendido, ou seja você corrige um erro mais rápido

#2. Velocidade, fugir do loop deixa seu código mais rápido. Às vezes MUITO mais rápido.
# Isso ocorre por motivos além do escopo do curso (alocação de memória, 
#código interpretado x código compilado em C++ etc.)

com_loop <- function(n){
  x <- integer()
  for (i in 1:n){
    x <- c(x, i^2)
  }
  x
}

sem_loop <- function(n){
  x <- 1:n %>% 
    map_dbl(function(x){x^2})
  x
}

resultados_perf <- bench::mark(
  sem_loop(1e4),
  com_loop(1e4),
  (1:1e4)^2
)  
resultados_perf %>% 
  select(expression, min, median, `itr/sec` )



# purrr::map o mais elementar ---------------------------------------------

#A função mais fundamental é :
purrr::map()

#Ela recebe uma função e um vetor (ou lista) de n elementos em .x
map(.x # Vetor que receberá a iteração
    )

#A função (.f) é chamada para cada elemento do vetor (ou lista), n vezes.
map(.x, # Vetor que receberá a iteração
    .f # função que será aplicada.
    )


## Exemplo ---------------------------------------------------------------

# Os resultados da aplicação destas n execuções são devolvidos em uma lista de n elementos
# Uma função é um objeto como outro qualquer e pode ser colocado em uma variável


funcao <- function(x) x^2 # função que eleva ao quadrado.

# map devolve uma lista com o resultado da execução de map em cada elemento

map(.x = 1:10, # iteração de 1 até 10
    .f = funcao # função que será aplicada no vetor
    )

# A família map_ ----------------------------------------------------------
# Agora que compreendemos como a função map funciona vamos conhecer a família map_
# Como o map retorna o produto da função como uma lista, 
#na maioria das vezes esse não é o resultado que esperamos.

map(.x = 1:10,# iteração
    .f = funcao #função a ser aplicada
    ) %>% 
  unlist()

# O map tem um produto para cada tipo de output desejado, seja formato double
map_dbl(.x = 1:10, # iteração
        .f = funcao #função a ser aplicada
        )

# Character
map_chr(.x = 1:10, # iteração
        .f = funcao #função a ser aplicada
        )

# Ou dataframe
map_df(.x = 1:10, # iteração
       .f = funcao #função a ser aplicada
       )

# PS: existem outros outputs como:
purrr::map_dfr() # que empilha as linhas do dataframe
purrr::map_dfc() # que adiciona novas colunas ao dataframe

# Geralmente utilizamos sempre o map_dfr.

# Potencializando o uso do map --------------------------------------------
#Funções podem ser declaradas inline.

map(.x = 1:5, #número de iterações
    #função que será aplicada as iterações
    .f = function(x){rnorm(n = 4,
                           mean = x,
                           sd = .01)} )
# Ou podem ser usadas através do shortcut ~

map(.x = 1:5, #número de iterações
    #função que será aplicada as iterações
    .f = ~ rnorm(n = 4,
                 mean = .x, # orientando onde o a iteração deve ocorrer
                 sd = .01) 
    )

# Tá na hora da revisão ---------------------------------------------------

# Use o map para calcular a média, das colunas 1 a 4 do dataset iris
map_dbl(iris[1:4],
    ~mean(.x)
    )
    
# use o map_df para calcular a média o desvio padrão, os valores minimos e maximos
map_df(iris[1:4],
    ~list(media =mean(.x),
          dp =sd(.x),
          min = min(.x),
          max = max(.x)
          )
    )

# no dataset mpg use a função split na coluna cyl e em seguida faça 
# uma regressão linear entre mpg~wt

mtcars %>%
  split(.$cyl) %>% 
  map(~lm(mpg~wt, data =.))

# DESAFIO
# use o map para plotar o histograma das colunas 1:4 do dataset iris

map(iris[1:4],
    ~ggplot(iris, 
            aes(x = .x))+
      geom_histogram()
    )

# Multiplas iterações --------------------------------------------------------------------
# Como a função map executa iterações com apenas um 1 iterador a função
#map2 permite que usemos 2 iteradores
dois_args <-tibble(media = c(0,0,2,2),
       dp = c(2,4,2,2))

map2(.x = dois_args$media, #primeiro iterador
     .y = dois_args$dp, #segundo iterador
     #função que receberá a iteração
     .f = ~rnorm(n = 4, mean = .x, sd = .y) )

# Já para mulitplas iterações usamos o purrr::pmap

tres_args <-tibble(mean = c(0,0,2,2),
                   sd = c(2,4,2,2),
                   n = c(5,2,9,3))
# PS: o imap tem algumas limitações:
# os nomes dos vetores deve bater com o nome dos parâmetros da função
pmap(.l = tres_args,
     .f = rnorm)


# Revisão 2 ---------------------------------------------------------------

#Baixe o excel abaixo
"https://www.dropbox.com/s/6nt00hmdzfdigp3/city_ses.xlsx?dl=1"
#Sabendo que o excel tem 3 sheets, Houston, Atlanta e Charlotte
#use o map para ler as 3 sheets
sheets <- readxl::excel_sheets("dados/city_ses.xlsx")


walk(sheets, 
    ~readxl::read_excel("dados/city_ses.xlsx",
                        sheet = .x
      
    ))

# Função walk
# Algumas vezes precisamos executar uma série de loops e salvar os resultados em objetos
# a função walk nos permite fazer isso

walk(readxl::excel_sheets("dados/city_ses.xlsx"),
     function(x) {
       nome_objeto = tolower(x)
       
       assign(nome_objeto, 
              readxl::read_excel("dados/city_ses.xlsx", sheet = x),
              envir = .GlobalEnv)
     })


# Fugindo de erros --------------------------------------------------------

# Algumas vezes as funções que utilizamos geram erros em uma das iterações

vetor <- c(1, 2, 3,
           "4", 
           5, 6)
# Nesse caso o erro acontece por que é impossivel somar um elemento a um vetor de texto.
map(vetor, ~sum(.x, 1)
    )

# Entretanto as vezes queremos que o map continue mesmo apresentando o erro.

## Podemos usar as funções quietly que faz um print completo

map(vetor,
    quietly(~sum(.x, 1)
            )
    )
# a função safely que faz um print do resultado com a mensagem de erro
map(vetor,
    safely(~sum(.x, 1)
    )
)

# e a função possibly onde indicamos qual deve ser o comportamento para o erro.
map(vetor,
    possibly(~sum(.x, 1),
             otherwise = "Valor a ser printado para identificar o erro"
    )
)

# Levando o purrr além, furrr ---------------------------------------------
library(furrr)

plan(multisession, workers = 4)
