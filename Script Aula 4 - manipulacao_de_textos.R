# Script Aula 4 - Manipulação de textos

string1 <- "Aqui eu tenho um string"

string2 <- 'Se eu quiser incluir uma citação eu tenho que usar "aspas duplas", dentro de aspas simples'

# Pra incluir aspas literais eu posso 
aspas_duplas <- "\""

aspas_simples <- '"'
  
# E para usar uma barra?

x <- c("\"", "\\")

writeLines(x)

# Para fazer uso de caracteres especiais eu sempre uso o \

#Limpando a staging area
rm(list = ls())
# Análises fundamentais -------------------------------------------------------------------------

# Vamos usar o pacote stringr para fazer uso das funções de manipulação de textos
library(stringr)

# No stringr as funções serão identificadas pelo prefixo str_

# Como contamos vetores de texto?

tri_liberta <- c("mil novecentos e oitenta e nove",
                 "dois mil e desenove",
                 "dois mil e vinte dois")

# Usamos a função base::length() ? O que ela retorna?
length(tri_liberta)

str_length(tri_liberta)

# E como faço para combinar os strings abaixo

paises_tri <- c("no Chile",
                "no Peru",
                "no Equador")

#devo usar a função c()

c("fomos campeões", paises_tri)

# Usando a função str_c

str_c("fomos campeões", paises_tri,
      sep = " ")

# de uma forma mais complexa
txt_campeoes <-str_c("fomos campeões",
      paises_tri,
      "em",
      tri_liberta,
      sep = " ")

# Como pegamos um subconjunto de uma string?
#usando a função str_sub

maior_campeao_liberta <- "Flamengo"

#Se eu quiser somente os 3 primeiras letras de uma string?
str_sub(maior_campeao_liberta,
        start = 1, # pegar a partir de primeira letra
        end = 3 # para na terceira letra
        )
#Se eu quiser somente as 5 últimas letras ?
str_sub(maior_campeao_liberta,
        start = -5, # pegar a partir da quinta ultima letra
        end = -1 # para a última letra
)

# E para contar quantas vezes um termo aparece no texto?
# 
str_count(string = txt_campeoes,
          pattern =  "campeões")

# E para transformar todas as letras em maisculas?

str_to_upper(maior_campeao_liberta)

# E para transformar todas as letras em minusculas?

str_to_lower(maior_campeao_liberta)

# E se eu quiser que apenas a primeira de cada palavra fique maiscula?
realidade <- str_to_title(c("flamengo é o maior time do brasil.",
             "o vasco é minusculo.", 
             "o botafogo é um bairro.",
             "o fluminense é virgem das américas."))

# E se eu quiser que apenas a 1° letra da expressão fique maiscula?
str_to_sentence(c("O FLAMENGO É GIGANTE",
                "O VASCO É MINUSCULO"))

### Identificando padrões com expressões regulares

# Identificando uma palavra que Contenha p
str_view(string = paises_tri,
         pattern = ".P")

# Identificando a palavra que contenha o termo flu
str_view(string = realidade,
         pattern = "Flu")

apelidos <- c("flamengo", 
            "fla", 
            "mengao",
            "mengo",
            "mengao do meu coracao",
            "vasco",
            "vascao",
            "menor do rio",
            "faisca",
            "foguinho",
            "flores",
            "fluminenCCCCCCe")
# Identificando dentro da string Apelidos aqueles que remetem ao fla
str_view(string = apelidos,
         pattern = "fla")

str_view(string = apelidos,
         pattern = "mengo")

# O . serve para indicar um string qualquer 
str_view(string = apelidos,
         pattern = "meng.")

# Mas como faço para indicar ou fla ou mengo?
# Usando o operador ou
str_view(string = apelidos,
         pattern = "fla|meng.")

# Aprendendo a lidar com ancoras
# Usamos 2 ancoras
# ^ para o inicio da string
# $ para o fim ad string

# Vocês sabem o que esses números representam?
numeros <- c(21979235221,
             21983678872,
             21996490787,
             21999743389)

# Exemplo identificando os ddds
str_view(string = numeros,
         pattern = "^..")
str_view(string = numeros,
         pattern = "^[0-9]{2}")

#Exemplo identificando os 3 últimos digitos

str_view(string = numeros,
         pattern = "...$")

str_view(string = numeros,
         pattern = "[0-9]{3}$")

str_view(string = numeros,
         pattern = "\\d{3}$")
# dicas
#\\d encontra qualquer digito
#\\s encontra qualquer tipo de spaço
#[abc] encontra a, b e c
#[^abc] encontra qualquer coisa menos a b e c
x <- "1888 é o ano mais longo em algarismo romanos: MDCCCLXXXVIII"
# ? retorna a 0 a 1 termos
str_view(x, "CC?")
# + retorna a mais de 1 termo
str_view(x, "CC+")
# * retorna a 0 ou mais termos
str_view(x, "CC*")
# {n} retorna a n numeros

# {n,} retorna a n numeros ou mais
# {,m} retorna a no maximo m,

# {n,m} retorna entre n a m 
str_view(x, 'C{2,3}?')

## Detectando padrões
# Se eu quero fazer um teste lógico de que um palavra está contida em outra
#uso o str_detect

#Vamos ver se o termo fla ou meng. aparece dentro dos apelidos
apelidos

str_detect(string = apelidos,
          pattern = "fla|meng.")

# Se eu perguntar, quantas strings de apelidos remetem a termos do flamengo?
# Responda em R

str_detect(string = apelidos,
          pattern = "fla|meng.") %>% 
  sum()

# Se eu quiser em média quantos dos apelidos que identificamos para os clubes do RJ
#remetem ao flamengo?

str_detect(string = apelidos,
           pattern = "fla|meng.") %>% 
  mean()

# Enquanto o str_detect promove um texte lógico de true or false 
# str_match retorna em um formato matricial onde os termos forma encontrados

str_match(string = apelidos,
           pattern = "fla|meng.")

apelidos %>% 
  tibble(apelidos= .) %>% 
  mutate(retorna_ao_fla = str_match(string = apelidos,
                                    pattern = "fla|meng."))

# Já o str_extract mostra onde os termos foram encontrados
# para trabalhar em datasets a função str_extract é mais indicada
str_extract(string = apelidos,
          pattern = "fla|meng.")

apelidos %>% 
  tibble(apelidos= .) %>% 
  mutate(retorna_ao_fla = str_extract(string = apelidos,
                                    pattern = "fla|meng."))

# str_replace substituir um termo por outro

#Por exemplo ou flamengo ou nada.
str_replace(string = apelidos,
            pattern = "[^(flamengo|fla|meng.)]",
            replacement =  NA_character_)
## Por fim, utilizamos o str_split() para quebrar um vetor em multiplos textos

hino_mengao<-"Uma vez Flamengo
Sempre Flamengo
Flamengo sempre eu hei de ser

É meu maior prazer vê-lo brilhar
Seja na terra, seja no mar
Vencer, vencer, vencer

Uma vez Flamengo
Flamengo até morrer

Na regata, ele me mata
Me maltrata, me arrebata
Que emoção no coração
Consagrado no gramado
Sempre amado, o mais cotado
No Fla-Flu é o: Ai, Jesus!

Eu teria um desgosto profundo
Se faltasse o Flamengo no mundo

Uma vez Flamengo
Sempre Flamengo
Flamengo sempre eu hei de ser

É meu maior prazer vê-lo brilhar
Seja na terra, seja no mar
Vencer, vencer, vencer

Uma vez Flamengo
Flamengo até morrer

Na regata, ele me mata
Me maltrata, me arrebata
Que emoção no coração
Consagrado no gramado
Sempre amado, o mais cotado
No Fla-Flu é o: Ai, Jesus!

Eu teria um desgosto profundo
Se faltasse o Flamengo no mundo
Ele vibra, ele é fibra
Muita libra já pesou
Flamengo até morrer eu sou"

#transformando o hino do flamengo em um dataset
str_split(hino_mengao, 
          pattern = "\n") %>% 
  pluck(1) %>% 
  tibble(verso = .) %>% 
  filter(verso != "") %>% 
  mutate(linha = 1:35)
### Exercicios
# Carregue o pacote tidyverse
#Olhe o objeto stringr::words
stringr::words

# transforme ele em um dataset formato tibble

df <- tibble::tibble(
  word = words, 
  i = seq_along(word)
)
#crie uma coluna que conta a quantidade de vogais
df %>% 
  mutate(n_vogais = str_count(word, "[aeiou]"))
#Crie uma coluna que conta o nmr de consoantes
df %>% 
  mutate(n_consoantes = str_count(word, "[^aeiou]"))



