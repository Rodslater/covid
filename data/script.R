library(dplyr)
library(readr)
library(covid19br)


df <- covid19br::downloadCovid19(level = "state")
df <- df %>% 
  select(date, code=state, epi_week, newCases, newDeaths, accumCases, accumDeaths, pop)

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

saveRDS(df, paste0('data/df.rds'))
saveRDS(cidades, paste0('data/cidades.rds'))
