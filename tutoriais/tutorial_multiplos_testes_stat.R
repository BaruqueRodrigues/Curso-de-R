### Como fazer multiplos testes estatisticos em R 

# faremos uso do conceito DRY - Don't Repeat Yourself p produzir o código
# Para tal, precisamos ter um certo nível de conhecimento em r:
# 1. Pipeamento de funções
# 2. Pivoteamento de colunas
# 3. Aplicação de loops

# Pacotes necessários

library(tidyr) # pivoteamento dos dados
library(purrr) # ferramentas de programação funcional

# No nosso exemplo vamos executar multiplos testes de regressão
# Vamos usar os dados do datasus que vão utilizados um modelo de dados de painel

dados_painel <- rio::import("dados/dados_painel.rds")

glimpse(dados_painel)

# Vamos calcular um modelo de regressão para cada uma das taxas de mortalidade
# Onde cada uma delas será a nossa VD.

# A maneira clássica seria rodar essa chunk de código para cada uma das VDs
plm::plm(values_mortalidade~pessoas_psf,
         data = dados_painel,
         model = "within",
         index = c("ano", "municipio"))

# Entretanto vamos usar o R para facilitar a nossa vida

modelo_efeitos_fixos <- dados_painel %>% 
  # Organizando os dados em Formato Long empilhando as variáveis de mortalidade
  pivot_longer(
    c(mort_menor_1:mort_todos),
    names_to = "nomes_mortalidade",
    values_to = "values_mortalidade"
  ) %>% 
  # Eninhando os dados para identificar o tipo de mortalidade
  nest(-nomes_mortalidade) %>% 
  # Criando Uma coluna nos Dados Eninhados com os valores dos dados de painel p variável
  mutate(# Executando o modelo por variável
    panel_model = map(data, ~plm::plm(values_mortalidade~pessoas_psf,
                                 data = .,
                                 model = "within",
                                 index = c("ano", "municipio"))),
    # Transformando o modelo em um formato tabular
    panel_model_data = map(panel_model, broom::tidy)
  ) %>% 
  select(-data) %>% 
  # Desaninhando os dados e vendo os valores do modelo.
  unnest(panel_model_data)

# 
modelo_efeitos_fixos
