# Aula 6 - Indo além no ggplot2

library(tidyverse)

# Revisão do ggplot -------------------------------------------------------

# Construindo um gráfico no ggplot

ggplot(data = mpg, #Insiro o dataset
       aes(# Insiro as informações estéticas
         x = displ, # Declaro o Valor do eixo X
         y = hwy # Declaro o Valor do eixo Y
         )
  
)+ # O operador + indica uma nova layer
  geom_point( #Indico a geometria desejada
    
  )

## os 5 tipos de gráficos

mpg %>% 
  ggplot(aes( x = displ))+
  geom_histogram()

mpg %>% 
  ggplot(aes( y = displ))+
  geom_boxplot()

mpg %>% 
  ggplot(aes( x= drv))+
  geom_bar()

mpg %>% 
  ggplot(
    aes(x = displ, y = hwy)
  )+
  geom_point()

economics %>% 
  ggplot(
    aes(x = date,
        y = psavert))+
  geom_line()

# Construindo Uma visualização que use os elementos da ultima aula

gapminder::gapminder %>% 
  filter(year == 2007) %>% 
  select(-year) %>% 
  arrange(desc(pop)) %>%
  mutate(country = factor(country, country)) %>%
  ggplot(aes(x=gdpPercap, y=lifeExp, size=pop, fill=continent)) +
  geom_point(alpha=0.5, shape=21, color="black") +
  scale_size(range = c(.1, 24), name="Population (M)") +
  viridis::scale_fill_viridis(discrete=TRUE, guide=FALSE, option="A") +
  hrbrthemes::theme_ipsum() +
  theme(legend.position="bottom") +
  ylab("Life Expectancy") +
  xlab("Gdp per Capita") 
  theme(legend.position = "none")


 # Visualização Espacial ---------------------------------------------------

  # Executar uma visualização espacial no R é muito simples
  
  # Para coletar informações espaciais sobre os dados brasileiros sempre utilizamos
  #o pacote do ibge geobr. 
  
  # Apenas precisamos indicar o dataset que contem as informações de latitude e 
  #de longitude
  
 malha_rj <- geobr::read_municipality(code_muni = 33) 
  
  malha_rj %>% 
    ggplot()+
    geom_sf()
  
  sedes_mun_rj <- geobr::read_municipal_seat()
  
  sedes_mun_rj %>% 
    filter(code_state == 33) %>% 
    ggplot()+
    geom_sf()
  
  # Printando os municipios ocm as sedes municipais
  malha_rj  %>% 
    ggplot()+
    geom_sf()+
    geom_sf(data = sedes_mun_rj %>% 
              filter(code_state ==33))+
    theme_void()
  
  # Pegando as coord das escolas
 escolas <- geobr::read_schools() %>% 
   filter(abbrev_state == "RJ")
 
 # Printando Escolas
 escolas %>% 
   ggplot()+
   geom_sf()
 
 # Observando a distribuição das escolas
 malha_rj %>% 
   ggplot() +
   geom_sf(fill = "white")+
   geom_sf(data = escolas,
           aes(color = urban))+
   theme_void()


# comunicando coeficientes -----------------------------------------------------

 library(sjPlot)

 #Para testes de x²

wage <- ISLR::Wage 

wage %>% 
  plot_gpt(x = health_ins, y = jobclass, grp = education) 
 
  #Coeficientes dos modelos

modelo <- lm(wage ~ education,
             data = wage)

plot_model(modelo,
           show.values = TRUE, width = 0.1)

# Tabela do modelo
tab_model(modelo, 
          show.reflvl = T, 
          show.intercept = F, 
          p.style = "numeric_stars")

# gt - o ggplot das tabelas -----------------------------------------------
library(gt)
library(gtExtras)
 options(scipen = 999)
 # Importando os dados das ações
  df_acoes <- readr::read_csv("dados/dados_b3_2010_2022.csv") %>% 
   select(-1) %>% 
   mutate(ano = lubridate::year(ref_date)) 
 
 df_acoes %>% 
   filter(ano <= 2014) %>% 
   group_by(ticker, ano) %>% 
   summarise(media_retorno = mean(ret_adjusted_prices, na.rm = TRUE)) %>% 
   pivot_wider(names_from = ano,
               values_from = media_retorno) %>%
   ungroup() %>% 
   
   gt() %>%  # gera o formato gt
   tab_header( #altera as informações de header
     title = "Retorno Médios Ativos Ibovespa Durante o Governo Dilma ",
     subtitle = ""
   ) %>% 
   fmt_number( # Formata as colunas
     columns = c(2:4),
     suffixing = TRUE,
     decimals = 4
   )
   
  # Fazendo Tabelas Descritivas Poderosas
 
jovens_doutores <- readr::read_csv("dados/jovens_doutores.csv")

 jovens_doutores %>% 
   # Calculando as Estatístiscas Descritivas
  summarise(across(c(n_total_artigos:qualis_inferior, -parecerista),
                 list(min, mean, median, sd, max),
                 na.rm = TRUE)
            ) %>% 
   # Corrigindo os nomes
  rename_with(., ~str_replace_all(., c("_1", "_2",
                                       "_3", "_4",
                                       "_5"),
                                  c("_min", "_mean",
                                    "_median", "_sd",
                                    "_max")
                                  )
              ) %>% 
   # Empilhando os dados em formato long
  pivot_longer(c(1:20)) %>% 
   # Corrigindo os nomes
  mutate(estatistica = str_extract(name, c("min|mean|median|sd|max")),
         name = str_remove(name, c("_min|_mean|_median|_sd|_max"))) %>% 
   # Empilhando os dados em um formato Wide
  pivot_wider(names_from = "estatistica",
              values_from = "value") %>% 
   #Criando as Colunas de Distribuição
   
  mutate("Distribuição" = list(jovens_doutores$n_total_artigos,
                               jovens_doutores$n_web_qualis,
                               jovens_doutores$qualis_superior,
                               jovens_doutores$qualis_inferior),
         "Boxplot" = `Distribuição`) %>%
 
 #Reformando os nomes das Colunas 
 select("Variável" = name,
         "Mínimo" = min,
         "Média" = mean,
         "Mediana" = median,
         "Desvio Padrão" = sd,
         "Máximo" = max,
         "Distribuição",
         "Boxplot" ) %>% 
  gt::gt() %>% 
   tab_header(
     title = "Tabela Descritiva da Produção Científca dos Jovens Doutores"
   ) %>% 
  tab_source_note(source_note = "Fonte : Baruque Rodrigues et Al  (2022)") %>% 
  gtExtras::gt_plt_dist("Distribuição") %>% 
  gtExtras::gt_plt_dist("Boxplot", type = "boxplot")
 
 


