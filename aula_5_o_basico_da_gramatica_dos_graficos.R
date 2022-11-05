### Data Visualization - Parte 1 ###

# Pacotes Utilizados

library(ggplot2) # Pacote gráfico
library(nycflights13) # Dados Utilizados
library(dplyr) # Manipula??o dos Dados

# O que é a DataVis e por que ela é importante?

flights

# Existem Multiplas formas de visualizar dados

flights

glimpse(flights)

View(flights)

flights$arr_time

flights$arr_delay

table(flights$arr_time)

table(flights$arr_delay)

arr_time

arr_delay

# Apresentando a gr?matica dos gráficos
# grammar of graphs

#Um grafico estatistico é um mapeamento de variáveis de dados para atributos
# estéticos de objetos geométricos.

ggplot(data = a, # dataset que contem as variáveis de interesse
       mapping = aes(x = arr_time) # atributos estéticos posição de X e Y, cor, forma e tamanho.
)+ # operador que adiciona camadas aos gráficos
  geom_histogram() # geom_ o objeto geométrico em questão


## The Big Five
# Os 5 tipos de gráfico que todo analista deve conhecer
# Gráficos univariados
# histograms - histogramas;
# boxplots - gráficos de caixa;
# barplots - gráficos de barra;

#Gráficos Bivariados
# scatterplots - gráficos de dispersão;
# linegraphs - gráficos de linha;

## Histogramas

# Fazendo um Histograma
ggplot(data = weather,
       aes(x = temp)) +
  geom_histogram()

# Alterando a cor de um geom
ggplot(data = weather,
       aes(x = temp)) +
  geom_histogram(color = "white")

# O que alterou desse histograma para o primeiro?

# Para alterar a parte interna de um geom utilizamos o argumento fill
ggplot(data = weather,
       aes(x = temp)) +
  geom_histogram(color = "white", fill = "steelblue")

# Utilizamos o argumento bins para alterar o número de colunas do histograma
ggplot(data = weather,aes(x = temp)) +
  geom_histogram(bins = 40, color = "white", fill = "steelblue")

# Utilizamos a função binwidth para alterar o tamanho da coluna
ggplot(data = weather,aes(x = temp)) +
  geom_histogram(binwidth = 10, color = "white", fill = "steelblue")


# Utilizamos o layer facets para criar paineis
ggplot(data = weather,
       aes(x = temp)) +
  geom_histogram(binwidth = 5, color = "white", fill = "red") +
  facet_wrap(~ month)

# Podemos alterar o tamanho do painel a ser plotado
ggplot(data = weather,
       aes(x = temp)) +
  geom_histogram(binwidth = 5, color = "white", fill = "red") +
  facet_wrap(~ month, nrow = 4)

ggplot(data = weather,
       aes(x = temp)) +
  geom_histogram(binwidth = 5, color = "white", fill = "red") +
  facet_wrap(~ month, nrow = 2, ncol = 6 )

## Boxplots

# Vendo a distribuição de uma vari?vel
ggplot(data = weather, 
       aes(y = temp)) +
  geom_boxplot()

# Vendo a distribuição de multiplas vari?veis
ggplot(data = weather, 
       aes(x = month, y = temp)) +
  geom_boxplot()

# Qual o erro?

ggplot(data = weather,
       aes(x = factor(month), y = temp)) +
  geom_boxplot()

## Barplots

# Simulando alguns dados
frutas <- tibble(
  fruta = c("maçã", "maçã", "laranja", "maçã", "laranja"))

frutas_contadas <- tibble(
  frutas = c("maçã", "laranja"),
  numero = c(3, 2))

# Podemos Usar o geom_bar
ggplot(data = frutas,
       aes(x = fruta)) +
  geom_bar()

# Como também o geom_col
ggplot(data = frutas_contadas,
       aes(x = frutas, y = numero)) +
  geom_col()

# Qual a diferença entre os 2?

# geom_bar é ótimo para dados n?o contados no dataframe
# geom_col é ótimo para valores contados no dataframe

# Fazendo gráficos de proporções

# Usando o argumento fill
ggplot(data = a,
       aes(x = carrier, fill = origin)) +
  geom_bar()

# Usando o argumento color
ggplot(data = a,
       aes(x = carrier, color = origin)) +
  geom_bar()

# Fazendo gráficos de barras agrupados fazendo uso do argumento position

ggplot(data = a,
       aes(x = carrier, fill = origin)) +
  geom_bar(position = "dodge")

# Mantendo a proporção nas barras

ggplot(data = flights,
       aes(x = carrier, fill = origin)) +
  geom_bar(position = position_dodge(preserve = "single"))

## Scatterplot

#filtrando os dados do alaska 
alaska <- flights %>% 
  filter(carrier == "AS")

# executando o gráfico
ggplot(data = alaska,
       aes(x = dep_delay, y = arr_delay)) + 
  geom_point()  

## O que fazer se os pontos se sobescreverem?

# Opção 1 alterando a transparência com a função alpha(), dentro do geom.

ggplot(data = alaska,
       aes(x = dep_delay, y = arr_delay)) + 
  geom_point(alpha = .2)

# Opção 2 usando um geom que cause um "tremor"
ggplot(data = alaska,
       aes(x = dep_delay, y = arr_delay)) + 
  geom_jitter()  


# Opção 3 juntando tudo
ggplot(data = alaska,
       aes(x = dep_delay, y = arr_delay)) + 
  geom_jitter(alpha = .2)


## Lineplot

#  Pegando uma série temporal
clima_jan<- weather %>% 
  filter(origin == "EWR" & month == 1 & day <= 31)

ggplot(data = clima_jan,
       aes(x = time_hour, y = temp)) +
  geom_line()


## Alterando a Estrutura do gráfico

# Alterando os nomes dos eixos dos gráficos

# Fazemos uso da função labs()
ggplot(data = clima_jan,
       aes(x = time_hour, y = temp)) +
  geom_line()+
  labs(title = "Titulo do gráfico",
       subtitle = "Subtítulo do gráfico",
       x = "título do Eixo X",
       y = "título do Eixo Y",
       caption = "Legenda do gráfico")

# Alterando o nome da legenda dos valores
# fazemos uso da função guides()

ggplot(data = a,
       aes(x = carrier, fill = origin)) +
  geom_bar(position = "dodge")+
  guides(fill = guide_legend("título da Legenda"))

# Alterando a posição da legenda
# Fazemos uso da função theme()

ggplot(data = a,
       aes(x = carrier, fill = origin)) +
  geom_bar(position = "dodge")+
  guides(fill = guide_legend("título da Legenda"))+
  theme(legend.position = "bottom")

# Para alterar qualquer elemento do gráfico podemos usar a função theme

# centralizando o título

ggplot(data = clima_jan,
       aes(x = time_hour, y = temp)) +
  geom_line()+
  labs(title = "Titulo do gráfico",
       subtitle = "Subtítulo do gráfico",
       x = "título do Eixo X",
       y = "título do Eixo Y",
       caption = "Legenda do gráfico")+
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5),
        plot.caption = element_text(hjust =0))

# mudando a cor do fundo do gráfico, por exemplo

ggplot(data = a,
       aes(x = carrier, fill = origin)) +
  geom_bar(position = "dodge")+
  guides(fill = guide_legend("título da Legenda"))+
  theme(legend.position = "bottom",
        panel.background = element_rect(fill = "lightblue")
  )

# mudando a cor do painel

ggplot(data = a,
       aes(x = carrier, fill = origin)) +
  geom_bar(position = "dodge")+
  guides(fill = guide_legend("título da Legenda"))+
  theme(legend.position = "bottom",
        panel.background = element_rect(fill = "lightblue", color = "red", size = 5)
  )

# mudando o tipo de linha do painel

ggplot(data = a,
       aes(x = carrier, fill = origin)) +
  geom_bar(position = "dodge")+
  guides(fill = guide_legend("título da Legenda"))+
  theme(legend.position = "bottom",
        panel.background = element_rect(fill = "lightblue", color = "red",linetype = "dashed")
  )

# alterando a cor painel

ggplot(data = a,
       aes(x = carrier, fill = origin)) +
  geom_bar(position = "dodge")+
  guides(fill = guide_legend("título da Legenda"))+
  theme(legend.position = "bottom",
        panel.background = element_rect(fill = "lightblue", color = "red",linetype = "dashed"),
        plot.background = element_rect(fill = "green")
  )

# alterando a posição dos valores do eixo x

ggplot(data = a,
       aes(x = carrier, fill = origin)) +
  geom_bar(position = "dodge")+
  guides(fill = guide_legend("título da Legenda"))+
  theme(legend.position = "bottom",
        panel.background = element_rect(fill = "lightblue", color = "red",linetype = "dashed"),
        plot.background = element_rect(fill = "green"),
        axis.text.x = element_text(angle = 90)
        
  )

# também podemos usar temas pré definidos

ggplot(data = a,
       aes(x = carrier, fill = origin)) +
  geom_bar(position = "dodge")+
  guides(fill = guide_legend("título da Legenda"))+
  theme_light()+
  theme(legend.position = "bottom")


# por fim, podemos usar o themeset pra definir o theme de todos os nossos gráficos.
theme_set()