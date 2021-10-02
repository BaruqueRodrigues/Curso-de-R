### Juntando base de dados diferentes ###

# Passo 1 O que você quer?
# Quer juntar colunas de bancos de dados diferentes? Então merge
# Quer empilhar linhas de colunas que estão em bancos diferentes? Então rbind
# Quer empilhar colunas e linhas de bancos de dados diferentes? Então cbind


# Passo 2 identifique os dataframes alvo

banco_a <- data.frame(pais=c("BRA","ESP","GER",
                            "ARG"),
                     democracia=c(2,4,4,2),
                     lib_imprensa=c(2,4,4,3))



banco_b <- data.frame(pais=c("BRA","ESP","GER",
                             "ARG"),
                      pib=c(37, 30, 42,21),
                      gini=c(12,3,2,20),
                      qualidade_ar=c(4,1,1,0))




# Passo 3 veja quais colunas tem interesse pra você
# Como a coluna qualidade de ar não interessa pra analise eu devo remove-la

# removendo uma coluna

subset(banco_b, select = -qualidade_ar)

banco_b$qualidade_ar<-NULL

# Passo 4 executando o merge


merge( # função que executa a junção dos bancos
  banco_a,banco_b, # bancos de dados de interesse
  by = "pais"# variável que é comum nos bancos, e que é o identificador do merge
      )


# E se eu precisar fazer o merge com mais de uma coluna?


banco_a <- data.frame(pais=c("BRA","ESP","GER",
                             "ARG"),
                      pais2= c("Brasil", "Espanha",
                               "Alemanha","Argentina"),
                      democracia=c(2,4,4,2),
                      lib_imprensa=c(2,4,4,3))


banco_b <- data.frame(pais=c("BRA","ESP","GER",
                             "ARG"),
                      pais2= c("Brasil", "Espanha",
                               "Alemanha","Argentina"),
                      pib=c(37, 30, 42,21),
                      gini=c(12,3,2,20))

# Só incluir só colocar tudo no c()

merge( # função que executa a junção dos bancos
  banco_a,banco_b, # bancos de dados de interesse
  by = c("pais", "pais2")# variáveis comuns, e que é o identificador do merge
      )

# E se as variáveis tiverem nomes diferentes?

banco_a <- data.frame(pais=c("BRA","ESP","GER",
                             "ARG"),
                      pais2= c("Brasil", "Espanha",
                               "Alemanha","Argentina"),
                      democracia=c(2,4,4,2),
                      lib_imprensa=c(2,4,4,3))

banco_b <- data.frame(sigla=c("BRA","ESP","GER",
                             "ARG"),
                      completo= c("Brasil", "Espanha",
                               "Alemanha","Argentina"),
                      pib=c(37, 30, 42,21),
                      gini=c(12,3,2,20))

# Só é discriminar os valores na função usando by.x e by.y

merge( # função que executa a junção dos bancos
  banco_a,banco_b, # bancos de dados de interesse
  by.x = c("pais", "pais2"),# variáveis de x que são identificadoras do merge
  by.y = c("sigla", "completo")# variáveis de y que são identificadoras do merge
  )


# eu peço para manter apenas os valores de x, com o argumento all.x = TRUE
# se eu quiser apenas os valores de y, eu uso o argumento all.y = TRUE

banco_a <- data.frame(pais=c("BRA","MEX","URU",
                             "ARG", "USA"),
                      pais2= c("Brasil", "México",
                               "Uruguai","Argentina", "Estados Unidos da América"),
                      democracia=c(2,4,4,2,4),
                      lib_imprensa=c(2,4,4,3,4))

banco_b <- data.frame(sigla=c("BRA","ESP","GER",
                              "ARG", "POR" ),
                      completo= c("Brasil", "Espanha",
                                  "Alemanha","Argentina", "Portugal"),
                      pib=c(37, 30, 42,21, 35),
                      gini=c(12,3,2,20, 10))

merge( # função que executa a junção dos bancos
  banco_a,banco_b, # bancos de dados de interesse
  by.x = c("pais", "pais2"),# variáveis de x que são identificadoras do merge
  by.y = c("sigla", "completo"),# variáveis de y que são identificadoras do merge
  all = TRUE # argumento que indica que quero apenas os valores de x
      )
# E se eu quiser empilhas valores de colunas de bancos diferentes?
# uso o rbind()

banco_2018 <- data.frame(pais=c("BRA","ESP","GER",
                             "ARG"),
                      democracia=c(3,4,4,3),
                      lib_imprensa=c(3,3,3,3),
                      qualidade_ar=c(4,1,1,0))

banco_2019 <- data.frame(pais=c("BRA","ESP","GER",
                             "ARG"),
                      democracia=c(2,4,4,2),
                      lib_imprensa=c(2,4,4,3),
                      qualidade_ar=c(4,1,1,0))



banco_2020 <- data.frame(pais=c("BRA","ESP","GER",
                             "ARG"),
                      democracia=c(2,4,4,2),
                      lib_imprensa=c(1,4,4,2),
                      qualidade_ar=c(4,1,1,0))



rbind(banco_2018, banco_2019, banco_2020)
