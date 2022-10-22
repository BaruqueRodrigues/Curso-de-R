### Script Lista 2

library(tidyverse) 
install.packages("geobr")

# tidy data ---------------------------------------------------------------

# Construção do dataset de pessoas cadastradas no PSF

psf <- readr::read_delim("dados/dados_lista2/pessoas_cadastradas_PSF_1998a2012.csv", 
           delim = ";", escape_double = FALSE, locale = readr::locale(encoding = "WINDOWS-1252"), 
           trim_ws = TRUE, skip = 4) |> 
  #Transformando as colunas em numeric
  dplyr::mutate(dplyr::across(`1998`:`2012`, as.numeric)) %>% 
  #Empilhando os valores de ano.
  tidyr::pivot_longer(c(`1998`:`2012`),
                      names_to = "ano",
                      values_to = "pessoas_psf"
                      )
# Construção do dataser de pop_mun_menor_1 

pop_menor_1 <- readr::read_delim("dados/dados_lista2/pop_residente_menor1ano_1993a2012.csv", 
                  delim = ";", escape_double = FALSE, locale = readr::locale(encoding = "WINDOWS-1252"), 
                  trim_ws = TRUE, skip = 4) |>
  #Transformando as colunas em numeric
  dplyr::mutate(dplyr::across(`1993`:`2000`, as.numeric)) |>
  # Empilhando os valores de ano
  tidyr::pivot_longer(c(`1993`:`2012`),
                      names_to = "ano",
                      values_to = "pop_menor_1"
  )

# Construção do dataser de pop_1a4 

pop_1a4 <- readr::read_delim("dados/dados_lista2/pop_residente_1a4anos_1993a2012.csv", 
                                 delim = ";", escape_double = FALSE, locale = readr::locale(encoding = "WINDOWS-1252"), 
                                 trim_ws = TRUE, skip = 4) |>
  #Transformando as colunas em numeric
  dplyr::mutate(dplyr::across(`1993`:`2000`, as.numeric)) |>
  # Empilhando os valores
  tidyr::pivot_longer(c(`1993`:`2012`),
                      names_to = "ano",
                      values_to = "pop_1a4"
  )
# Construção do dataset de pop_15a59
pop_15a59 <- readr::read_delim("dados/dados_lista2/pop_residente_15a59anos_1993a2012.csv", 
                  delim = ";", escape_double = FALSE, locale = readr::locale(encoding = "WINDOWS-1252"), 
                  trim_ws = TRUE, skip = 4) |>
  dplyr::mutate(dplyr::across(`1993`:`2000`, as.numeric)) |>
  # Empilhando os valores de ano
  tidyr::pivot_longer(c(`1993`:`2012`),
                      names_to = "ano",
                      values_to = "pop_15a59"
  )

pop_maior_60 <- readr::read_delim("dados/dados_lista2/pop_residente_maior60anos_1993a2012.csv", 
                               delim = ";", escape_double = FALSE, locale = readr::locale(encoding = "WINDOWS-1252"), 
                               trim_ws = TRUE, skip = 4) |>
  dplyr::mutate(dplyr::across(`1993`:`2000`, as.numeric)) |>
  tidyr::pivot_longer(c(`1993`:`2012`),
                      names_to = "ano",
                      values_to = "pop_maior_60"
  )

# Construção do dataset de pop residente municipios

pop <- readr::read_delim("dados/dados_lista2/pop_residente_todos_1993a2012.csv", 
                  delim = ";", escape_double = FALSE, locale = readr::locale(encoding = "WINDOWS-1252"), 
                  trim_ws = TRUE, skip = 3) |>
  dplyr::mutate(dplyr::across(`1993`:`2000`, as.numeric)) |>
  # Empilhando os valores
  tidyr::pivot_longer(c(`1993`:`2012`),
                      names_to = "ano",
                      values_to = "pop_mun_todos"
  )

# Construção do dataset menor de 1 ano

mort_menor_1 <- readr::read_delim("dados/dados_lista2/mort_menor1ano_1993a1995.csv", 
                  delim = ";", escape_double = FALSE, locale = readr::locale(encoding = "WINDOWS-1252"), 
                  trim_ws = TRUE, skip = 4) %>% 
  dplyr::select(-Total) %>% 
  left_join(
    readr::read_delim("dados/dados_lista2/mort_menor1ano_1996a2012.csv", 
                      delim = ";", escape_double = FALSE, locale = readr::locale(encoding = "WINDOWS-1252"), 
                      trim_ws = TRUE, skip = 4) %>% 
      dplyr::select(-Total)
  ) %>% 
  dplyr::mutate(dplyr::across(`1993`:`2012`, as.numeric)) %>% 
  tidyr::pivot_longer(c(`1993`:`2012`),
                      names_to = "ano",
                      values_to = "mort_menor_1"
  )


# Construção do dataset mortalidade de 1 a 4 anos

mort_1a4 <- readr::read_delim("dados/dados_lista2/mort_1a4anos_1993a1995.csv", 
                              delim = ";", escape_double = FALSE, locale = readr::locale(encoding = "WINDOWS-1252"), 
                              trim_ws = TRUE, skip = 4) %>% 
  dplyr::select(-Total) %>% 
  left_join(
    readr::read_delim("dados/dados_lista2/mort_1a4anos_1996a2012.csv", 
                      delim = ";", escape_double = FALSE, locale = readr::locale(encoding = "WINDOWS-1252"), 
                      trim_ws = TRUE, skip = 4) %>% 
      dplyr::select(-Total)
  ) %>% 
  dplyr::mutate(dplyr::across(`1993`:`2012`, as.numeric)) %>% 
  tidyr::pivot_longer(c(`1993`:`2012`),
                      names_to = "ano",
                      values_to = "mort_1a4"
  )

# Construção do dataset mortalidade de 15 a 59 anos

mort_15a59 <- readr::read_delim("dados/dados_lista2/mort_15a59anos_1993a1995.csv", 
                  delim = ";", escape_double = FALSE, locale = readr::locale(encoding = "WINDOWS-1252"), 
                  trim_ws = TRUE, skip = 4) %>% 
  dplyr::select(-Total) %>% 
  left_join(
    readr::read_delim("dados/dados_lista2/mort_15a59anos_1996a2012.csv", 
                      delim = ";", escape_double = FALSE, locale = readr::locale(encoding = "WINDOWS-1252"), 
                      trim_ws = TRUE, skip = 4) %>% 
      dplyr::select(-Total)
  ) %>% 
  dplyr::mutate(dplyr::across(`1993`:`2012`, as.numeric)) %>% 
  tidyr::pivot_longer(c(`1993`:`2012`),
                      names_to = "ano",
                      values_to = "mort_15a59"
  )

# Construção do dataset mortalidade maior de 60 anos

mort_maior_60 <- readr::read_delim("dados/dados_lista2/mort_maior60anos_1993a1995.csv", 
                                delim = ";", escape_double = FALSE, locale = readr::locale(encoding = "WINDOWS-1252"), 
                                trim_ws = TRUE, skip = 4) %>% 
  dplyr::select(-Total) %>% 
  left_join(
    readr::read_delim("dados/dados_lista2/mort_maior60anos_1996a2012.csv", 
                      delim = ";", escape_double = FALSE, locale = readr::locale(encoding = "WINDOWS-1252"), 
                      trim_ws = TRUE, skip = 4) %>% 
      dplyr::select(-Total)
  ) %>% 
  dplyr::mutate(dplyr::across(`1993`:`2012`, as.numeric)) %>% 
  tidyr::pivot_longer(c(`1993`:`2012`),
                      names_to = "ano",
                      values_to = "mort_maior_60"
  )
# Construção do dataset mortalidade todos

mort_todos <- readr::read_delim("dados/dados_lista2/mort_todos_1993a1995.csv", 
                  delim = ";", escape_double = FALSE, locale = readr::locale(encoding = "WINDOWS-1252"), 
                  trim_ws = TRUE, skip = 3)|>
  dplyr::select(-Total) |> 
  dplyr::left_join(
    readr::read_delim("dados/dados_lista2/mort_todos_1996a2012.csv", 
                      delim = ";", escape_double = FALSE, locale = readr::locale(encoding = "WINDOWS-1252"), 
                      trim_ws = TRUE, skip = 3) |>
      dplyr::select(-Total)
  ) %>% 
  dplyr::mutate(dplyr::across(`1993`:`2012`, as.numeric)) %>% 
  tidyr::pivot_longer(c(`1993`:`2012`),
                      names_to = "ano",
                      values_to = "mort_todos"
  )

# Criando o dataset de trabalho
dados_painel <- psf %>% 
  left_join(pop_menor_1) %>% 
  left_join(pop_1a4) %>% 
  left_join(pop_15a59) %>% 
  left_join(pop_maior_60) %>% 
  left_join(pop) %>% 
  left_join(mort_menor_1) %>% 
  left_join(mort_1a4) %>% 
  left_join(mort_15a59) %>% 
  left_join(mort_maior_60) %>% 
  left_join(mort_todos)

# Limpar objetos desnecessários no environment 
rm(list = c("psf", "pop_menor_1", "pop_1a4",
            "pop_15a59", "pop_maior_60", "pop",
            "mort_menor_1", "mort_1a4", "mort_15a59",
            "mort_maior_60", "mort_todos"))             

# Fazendo as manipulações da questão 2
dados_painel <- dados_painel %>% 
  #tidyway colnames
  janitor::clean_names() %>% 
  #transformando na em 0
  replace_na(list("pessoas_psf"= 0,
                  "pop_menor_1"= 0, "pop_1a4"= 0, 
                  "pop_15a59"= 0, "pop_maior_60"= 0, 
                  "pop_mun_todos"= 0, "mort_menor_1" = 0,
                  "mort_1a4"= 0, "mort_15a59" = 0, 
                  "mort_maior_60"= 0, "mort_todos"= 0)) %>% 
  #Criando a Variável da taxa de mortalidade
  mutate(tx_mort_menor_1 = mort_menor_1/pop_menor_1*1000,
         tx_mort_menor_1a4 = mort_1a4/pop_1a4*1000,
         tx_mort_menor_15a59 = mort_15a59/pop_15a59*100000,
         tx_mort_menor_maior_60 = mort_maior_60/pop_maior_60*100000,
         tx_mort_todos = mort_todos/pop_mun_todos*100000,
  #Criando a Variável taxa de cobertura
  tx_cobertura_psf = pessoas_psf/pop_mun_todos*100,
  #Criando a variável UF
  cod_uf = str_sub(municipio, end = 2),
  #Dummy existencia PSF
  existe_psf = ifelse(pessoas_psf != 0, 1, 0)) %>% 
  # Pegando a informação das UFs no pacote {geobr}
  left_join(geobr::read_state() %>% 
              tibble() %>% 
              select(cod_uf =code_state, sigla_uf = abbrev_state) %>% 
              mutate(cod_uf = as.character(cod_uf))) 


# Questão 3

install.packages("plm")

library(plm)

### Questão 3
# Modelo Efeitos Fixo 

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
         panel_model = map(data, ~plm(values_mortalidade~pessoas_psf,
                                          data = .,
                                          model = "within",
                                            index = c("ano", "municipio"))),
         # Transformando o modelo em um formato tabular
         panel_model_data = map(panel_model, broom::tidy)
         ) %>% 
  # Desaninhando os dados e vendo os valores do modelo.
  unnest(panel_model_data)


### Questão 4

# Modelo com interações

modelo_interacoes <-dados_painel %>% # Organizando os dados em Formato Long empilhando as variáveis de mortalidade
  pivot_longer(
    c(mort_menor_1:mort_todos),
    names_to = "nomes_mortalidade",
    values_to = "values_mortalidade"
  ) %>% 
  # Eninhando os dados para identificar o tipo de mortalidade
  nest(-nomes_mortalidade) %>% 
  # Criando Uma coluna nos Dados Eninhados com os valores dos dados de painel p variável
  mutate(# Executando o modelo por variável
    panel_model = map(data, ~plm(values_mortalidade~pessoas_psf+ano+sigla_uf+ano*sigla_uf,
                                 data = .)),
                      # Transformando o modelo em um formato tabular
    panel_model_values = map(panel_model, broom::tidy)) %>% 
  # Desaninhando os dados e vendo os valores do modelo.
  unnest(panel_model_values)
  
### Questão 5 


# Modelo efeitos fixos na dummy T (existe_psf)
modelo_efeitos_fixos_dummy_t <- dados_painel %>% 
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
    panel_model = map(data, ~plm(values_mortalidade~existe_psf,
                                 data = .,
                                 model = "within",
                                 index = c("ano", "municipio"))),
                      # Transformando o modelo em um formato tabular
    panel_model_values = map(panel_model, broom::tidy)
  ) %>% 
  # Desaninhando os dados e vendo os valores do modelo.
  unnest(panel_model_values)

# Modelo com interações na dummy_T (existe_psf)

modelo_interacoes_dummy_t <-dados_painel %>% # Organizando os dados em Formato Long empilhando as variáveis de mortalidade
  pivot_longer(
    c(mort_menor_1:mort_todos),
    names_to = "nomes_mortalidade",
    values_to = "values_mortalidade"
  ) %>% 
  # Eninhando os dados para identificar o tipo de mortalidade
  nest(-nomes_mortalidade) %>% 
  # Criando Uma coluna nos Dados Eninhados com os valores dos dados de painel p variável
  mutate(# Executando o modelo por variável
    panel_model = map(data, ~plm(values_mortalidade~existe_psf+ano+sigla_uf+ano*sigla_uf,
                                 data = .)),
                      # Transformando o modelo em um formato tabular
                      panel_model_values = map(panel_model, broom::tidy)
  ) %>% 
  # Desaninhando os dados e vendo os valores do modelo.
  unnest(panel_model_values)

# Questão 6 criando uma nova dummy (event_study)  


