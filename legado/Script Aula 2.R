### Don't Repeat Yourself - Estruturas de Repetição no R ###

# Repetições
# fazendouso da função rep

rep( # para repetir um valor usamos a função rep
  1:2, # em seguida passamos o valor a ser repetido
  times = 10, # o número de vezes
  each = 3 # quantas vezes cada elemento vai se repetir
  )

# outro exemplo

rep(LETTERS[1:5], 10, each = 3)

# Sequência
# para trabalhar eu uso a função seq()

seq( # para sequências usamos a função seq
  from = 1, # inicio da sequência
  to = 100, # fim da sequência
  by = 3 # valor da progressão
)

# Replicate
# a função utilizada para repetir funções, é a função replicate()

replicate( # para repetir uma função usamos a função replicate
          10, # passamos o número de vezes da repetição desejada
          sample(1:100,size = 5) # e a função desejada
          )

# A família apply()

# Usando o Apply para pedir a média das colunas matches e matches.brasil na base simulada da aula 1.

apply(# executamos a função de repetição;
  t[,2:3]# orientamos ao R onde queremos a repetição, nesse caso nas colunas 2 e 3;
  , 2 # orientamos que nossa função deve ser executada nas colunas;
  , mean #orientamos a função desejada;
  ) # fechamos a função e executamos.

# Repetindo a função mean para retornar a média das colunas desejadas
mean(t$matches);mean(t$matches.brasil)

# Nesse caso a função apply foi menos eficiente que pedir a função mean 2x 
# DF simulado 

app<-data.frame(
  stringsAsFactors = FALSE,
  check.names = FALSE,
  UF = c("AL","PE","CE","SE","PB",
         "MA","PI","PB","BA","AL","PE","CE","SE","PB","MA",
         "PI","PB","BA","AL","PE","CE","SE","PB","MA",
         "PI","PB","BA"),
  Ano = c(2016L,2016L,2016L,2016L,
          2016L,2016L,2016L,2016L,2016L,2017L,2017L,2017L,
          2017L,2017L,2017L,2017L,2017L,2017L,2018L,2018L,2018L,
          2018L,2018L,2018L,2018L,2018L,2018L),
  uber = c(119L,32L,188L,89L,155L,90L,
           199L,97L,199L,75L,110L,55L,76L,119L,93L,88L,
           124L,98L,149L,91L,186L,198L,176L,28L,104L,157L,
           47L),
  `99.taxi` = c(38L,43L,34L,70L,61L,85L,
                33L,30L,54L,35L,35L,29L,20L,83L,39L,78L,89L,45L,
                26L,32L,33L,83L,50L,44L,30L,76L,45L),
  waze = c(21L,18L,12L,26L,30L,8L,
           22L,13L,24L,5L,23L,9L,4L,22L,17L,27L,17L,8L,16L,
           35L,23L,33L,28L,6L,35L,13L,16L),
  ifood = c(126L,33L,87L,61L,209L,100L,
            84L,120L,77L,118L,145L,196L,125L,93L,210L,234L,
            248L,168L,180L,108L,50L,37L,203L,217L,245L,
            118L,130L),
  uber.eats = c(226L,176L,70L,243L,73L,
                197L,239L,149L,39L,115L,198L,174L,38L,227L,162L,
                194L,246L,216L,65L,127L,45L,113L,138L,136L,137L,
                173L,247L),
  rappi = c(56L,34L,50L,74L,49L,42L,
            31L,81L,59L,81L,35L,67L,64L,50L,44L,67L,30L,
            100L,55L,30L,94L,38L,95L,88L,41L,89L,91L),
  cabify = c(11L,26L,19L,32L,38L,8L,
             28L,15L,5L,7L,2L,39L,20L,8L,16L,23L,5L,33L,38L,
             7L,24L,10L,32L,16L,10L,4L,19L),
  blablacar = c(2L,10L,10L,2L,32L,10L,16L,
                2L,2L,33L,23L,33L,23L,19L,8L,15L,33L,19L,33L,
                29L,32L,3L,18L,9L,26L,26L,2L)
)

# E se tivermos um dataframe como o do app, qual função é mais rápida?
# Onde o dataframe tem 10 colunas, das quais queremos analisar 8.

names(app)

# Fazendo uso de uma estrutura de repetição

apply(app[,3:10], 2, mean)

# Fazendo uso da função mean sem repetição

mean(app$uber);mean(app$`99.taxi`);mean(app$waze);mean(app$ifood);mean(app$uber.eats);mean(app$rappi);mean(app$cabify)

# Fazendo uso do lapply

lapply(# passamos a função lapply
  app[,3:10], # orientamos a posição, dentro do objeto app, na colunas 3 até a 10
  mean # orientamos a função desejada 
  )



# lapply tem a mesma função que a apply, porém com uma sintaxe mais limpa

# Fazendo uso do sapply
sapply(app[3:10], mean)

par(mfrow=c(2,4)) # função que altera o plots, plotando 2 linhas e 4 colunas

sapply(# passamos a função sapplyy
  app[,3:10], # orientamos a posição, dentro do objeto app, na colunas 3 até a 10
  hist # orientamos a função desejada 
  )

# sapply tem a mesma sintaxe de lapply, porém simplifica os resultados tal como apply

# Tanto o sapply como o lapply também te permite passar 1 argumento da função alvo

sapply(names(app[3:10]), 
       function(k) hist(app[3:10][[k]], main=k))

# Fazendo uso do mapply

mapply(hist, # função que desejamos usar;
       app[,3:10], # posição objeto dentro do df;
       MoreArgs = #função more args permite usar os argumentos da função desejada;
         list( # usamos o list para passar uma série de funções;
           main='Histograma', xlab = 'Valores', ylab = 'Frequência')) 

# mapply permite usar os argumentos da função desejada



# Fazendo uso de repetições com o for

for (i in 3:10 # crie uma interação de 3 até dez
              ) {
  x <- app[, i] # onde as interações são nas colunas do dataframe app
  
  # Em seguida faça um histograma
  hist(x,
       main = names(app)[i], # para o título use os nomes das colunas de app seguindo a interação
       xlab = "valores", # rotulo do eixo x
       ylab = "Frequência", #rotulo do eixo y
       xlim = c(min(app[, i]),
                max(app[, i])) # limites do eixo x
       )
  
}


# Fazendo repetições com mais velocidade
library(purrr) # importamos o pacote purrr

purrr::map() # fazemos uso da função map

map(app[3:10], mean)

