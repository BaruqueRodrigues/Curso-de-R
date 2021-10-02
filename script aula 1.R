### O R como calculadora

# Você pode executar somas
25+11

# Assim como subtrações.

385-298

# Multiplicações.

223*9384

# Divisões.

389/11


# Exponenciações.

2^10

# Expressões Númericas
# [] {} não são usados

2+(1+(4/2)-(2*1)+10)

### Operadores Lógicos

flextable::flextable(operadores, cwidth = 2)

### Apresentando os Tipos de Objetos

# Objetos númericos (numeric).
a<- c(8,4,4,1)
a;class(a)

# Objetos de sequência de caracteres (character).

b<- c("flamengo", "fluminese","vasco", "botafogo")
b;class(b)

# Objetos do tipo factor (factor).

c<- factor(c("atual campeão", "em disputa série", "fora da competição", "fora da competição"))
c;class(c)

# Objetos do Tipo Dataframe.

df<-data.frame(b,a,c)
df

# Alterando o nome das colunas de um dataframe.

names(df)<-c("time", "número de brasileiros", "status no brasileirão")
df
View(df)

### Acessando elementos dentro de um objeto.

head(iris)# função que printa no console o inicio de um objeto
tail(iris)# função que printa no console o final de um objeto

# Selecionando os itens da primeira coluna.
## Uso o colchetes para selecionar um elemento n dentro do objeto.

iris[1]

# Selecionando Elementos na primeira linha.

iris[1,] 

# Selecionando elementos da 5° a 10° linha e das colunas 2 a 5.

iris[5:10,2:5]

# Selecionando elementos das linhas 3, 5 e 6 e das colunas 1, 3 e 5.

iris[c(3,5,6), c(1,3,5)]

### Revisão

# Dados Simulados

t<-data.frame(
     stringsAsFactors = FALSE,
                             estado = c("alagoas","pernambuco","sergipe",
                                        "bahia","rio grande do norte","piaui",
                                        "ceará","paraiba","maranhão"),
                            matches = c(23320L,42392L,35292L,63850L,
                                        42823L,33301L,16711L,59766L,69495L),
                     matches.brasil = c(848298L,848298L,848298L,848298L,
                                        848298L,848298L,848298L,848298L,
                                        848298L),
                   maioria_feminina = c("sim","não","sim","não","sim",
                                        "sim","sim","não","não"),
                classe_predominante = c("alta","alta","media","baixa",
                                        "baixa","alta","media","media","baixa"),
                 idade_predominante = c("<20 e >30","<31 e > 35",
                                        "<18 e > 23","<18 e > 23","<18 e > 23",
                                        "<20 e >30","<31 e > 45","<31 e > 45","<45")
              )
# Observando os casos onde há maioria feminina.

t[t$maioria_feminina=="sim",]

# Observando Casos onde a classe predominante é alta.

t[t$classe_predominante == "alta", ]

# Observando Casos onde a classe predominante é alta e a maioria é feminina.

t[t$classe_predominante == "alta" & t$maioria_feminina=="sim", ]

# Observando Casos onde o número de matches é menor que 30 mil ou a classe predominante não é baixa

t[t$matches < 30000 | t$classe_predominante!="baixa", ]

#Observando Casos onde a idade predominante é entre 18 e 30 anos

t[t$idade_predominante %in% c("<18 e > 23", "<20 e >30"), ]

#Calculando o percentual equivalente de matches no brasil do estado

t$matches/t$matches.brasil*100
