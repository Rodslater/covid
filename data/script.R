library(dplyr)
library(readr)
library(covid19br)


df <- covid19br::downloadCovid19(level = "state")
df <- df %>% 
  select(date, code=state, epi_week, newCases, newDeaths, accumCases, accumDeaths, pop)

dadosmapa <- df |>
  filter(between(date, max(date) - 30, max(date))) %>% # Últimos 30 dias notificados
  group_by(code) |>  
  summarise(incidencia = round((sum(newCases) / max(pop)) * 100000, digits = 2),
            mortalidade = round((sum(newDeaths) / max(pop)) * 100000, digits = 2),
            letalidade = round((sum(newDeaths) / max(newCases)) * 100, digits = 2))

df <- df %>% 
  filter(code == "SE")

cidades <- covid19br::downloadCovid19("cities")

cidades <- cidades %>%
  filter(state == "SE" & city_code != 280000, date == max(date)) %>% 
  select(city, city_code, accumCases, accumDeaths, pop) %>% 
  mutate(city_code= as.character(city_code),
         casos_100k = round(accumCases/pop*10^5,2),
         mortes_100k = round(accumDeaths/pop*10^5,2)) %>% 
  select(-pop)

saveRDS(df, 'data/df.rds')
saveRDS(cidades, 'data/cidades.rds')
saveRDS(dadosmapa, 'data/dadosmapa.rds')
